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
        [SupportsWildcards()]
        [alias("task")]
        [String]$Name,

        [Parameter(
            HelpMessage = "The task ID.",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "id"
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID,

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
        [Switch]$All,

        [Parameter(
            HelpMessage = "Get all open tasks by category",
            ParameterSetName = "category"
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Category,

        [Parameter(HelpMessage = "The path to the PSWorkItem SQLite database file. It should end in .db")]
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
        [String]$Path = $PSWorkItemPath
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting "
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Detected culture $(Get-Culture)"
    } #begin

    Process {
        $results = [System.Collections.Generic.list[object]]::new()
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Detected parameter set $($PSCmdlet.parametersetname)"
        Switch -regex ($PSCmdlet.ParameterSetName) {
            "all|days" { $query = "Select * from tasks" }
            "category" { $query = "Select * from tasks where category ='$Category' collate nocase" }
            <#
                6 August 2022 -JDH
                Because SQLite doesn't have a datetime type, querying is messy. It is just
                as easy to get everything and then use PowerShell to filter by date. This
                also simplifies things when running under different cultures.
                "days" {
                        $d = (Get-Date).AddDays($DaysDue)
                        $query = "Select * from tasks where duedate <= '$d' collate nocase"
                    } 
            #>
            "id" { $query = "Select * from tasks where ID ='$ID'" }
            "name" {
                if ($Name -match "\*") {
                    $Name = $name.replace("*", "%")
                }
                $query = "Select * from tasks where name = '$Name' collate nocase"

            }
        }

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $query"
        $tasks = Invoke-MySQLiteQuery -Query $query -Path $Path

        if ($tasks.count -gt 0) {

            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Found $($tasks.count) matching tasks"
            if ($PSCmdlet.ParameterSetName -eq 'days') {
                $d = (Get-Date).AddDays($DaysDue)
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Re-filtering for tasks due in the next $DaysDue day(s)."
                Write-Verbose ("[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Cutoff date is {0}" -f $d)
                Write-Verbose ("[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Filtering for items due before {0}" -f $d)
                <#
                This format doesn't appear to respect culture
                $tasks = ($tasks).Where({ [DateTime]$_.duedate -le $d })
                #>
                $tasks = $tasks | Where-Object { ($_.duedate -as [DateTime]) -le $d}
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Re-Filtering found $($tasks.count) items"
            }
            $i=0
            foreach ($task in $tasks) {
              Write-Debug "Converting id $($task.id)"
              $nwi = _newWorkItem $task -path $path
              write-Debug "Adding $($nwi.name) to the result list"
                $results.Add($nwi)
                $i++
            }
            Write-Debug "processed $i tasks"
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Sorting $($results.count) results"
            $results | Sort-Object -Property DueDate
        }
        else {
            Write-Warning "Failed to find any matching tasks"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending"
    } #end
}
