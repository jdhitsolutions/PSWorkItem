Function Get-PSWorkItem {
    [cmdletbinding(DefaultParameterSetName = "days")]
    [alias('gwi')]
    [outputType('PSWorkItem')]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "The name of the work item. Wilcards are supported.",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "name"
        )]
        [ValidateNotNullOrEmpty()]
        [alias("task")]
        [string]$Name,

        [Parameter(
            HelpMessage = "The task ID.",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "id"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

        [Parameter(
            HelpMessage = "Get open tasks due in the number of days between 1 and 365.",
            ParameterSetName = "days"
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 365)]
        [int]$DaysDue = 10,

        [Parameter(
            HelpMessage = "Get all open tasks",
            ParameterSetName = "all"
        )]
        [switch]$All,

        [Parameter(
            HelpMessage = "Get all open tasks by category",
            ParameterSetName = "category"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Category,

        [Parameter(HelpMessage = "The path to the PSWorkitem SQLite database file. It should end in .db")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\.db$")]
        [ValidateScript({
                if (Test-Path $_) {
                    Return $True
                }
                else {
                    Throw "Failed to validate $_"
                    Return $False
                }
            })]
        [string]$Path = $PSWorkItemPath
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting "
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Detected culture $(Get-Culture)"
    } #begin

    Process {
        $results = [System.Collections.Generic.list[object]]::new()
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Detected parameter set $($pscmdlet.parametersetname)"
        Switch -regex ($PScmdlet.ParameterSetName) {
            "all|days" { $query = "Select *,RowID from tasks" }
            "category" { $query = "Select *,RowID from tasks where category ='$Category' collate nocase" }
            <#
          6 August 2022 -JDH
          Because SQLite doesn't have a datetime type, querying is messy. It is just
          as easy to get everything and then use PowerShell to filter by date. This
          also simplifies things when runnng under different cultures.
          "days" {
                $d = (Get-Date).AddDays($DaysDue)
                $query = "Select *,RowID from tasks where duedate <= '$d' collate nocase"
            } #>
            "id" { $query = "Select *,RowID from tasks where RowID ='$ID'" }
            "name" {
                if ($Name -match "\*") {
                    $Name = $name.replace("*", "%")
                    $query = "Select *,RowID from tasks where name like '$Name' collate nocase"
                }
                else {
                    $query = "Select *,RowID from tasks where name = '$Name' collate nocase"
                }
            }
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): $query"
        $tasks = Invoke-MySQLiteQuery -Query $query -Path $Path

        if ($tasks.count -gt 0) {

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Found $($tasks.count) matching tasks"
            if ($pscmdlet.ParameterSetName -eq 'days') {
                $d = (Get-Date).AddDays($DaysDue)
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Re-filtering for tasks due in the next $DaysDue day(s)."
                Write-Verbose ("[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Cutoff date is {0}" -f $d)
                Write-Verbose ("[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Filtering for items due before {0}" -f $d)
                <#
                This format doesn't appear to respect culture
                $tasks = ($tasks).Where({ [datetime]$_.duedate -le $d })
                #>
                $tasks = $tasks | Where-Object { ($_.duedate -as [datetime]) -le $d}
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Re-Filtering found $($tasks.count) items"
            }
            $i=0
            foreach ($task in $tasks) {
              Write-Debug "Converting rowid $($task.rowid)"
              $nwi = _newWorkItem $task
              write-Debug "Adding $($nwi.name) to the result list"
                $results.Add($nwi)
                $i++
            }
            Write-Debug "processed $i tasks"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Sorting $($results.count) results"
            $results | Sort-Object -Property DueDate
        }
        else {
            Write-Warning "Failed to find any matching tasks"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end
}
