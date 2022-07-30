Function Get-PSWorkItemArchive {
    [cmdletbinding(DefaultParameterSetName = "name")]
    [OutputType("PSWorkItemArchive")]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "The name of the work item. Wilcards are supported.",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "name"
        )]
        [ValidateNotNullOrEmpty()]
        [alias("task")]
        [string]$Name = "*",

        [Parameter(
            HelpMessage = "The task ID.",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "id"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

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
    } #begin

    Process {
        Switch ($PScmdlet.ParameterSetName) {
            "category" {$query = "Select *,RowID from archive where category ='$Category' collate nocase"}

            "id" {$query = "Select *,RowID from archive where RowID ='$ID'"}
            "name" {
                if ($Name -match "\*") {
                    $Name = $name.replace("*","%")
                    $query = "Select *,RowID from archive where name like '$Name' collate nocase"
                }
                else {
                    $query = "Select *,RowID from archive where name = '$Name' collate nocase"
                }
            }
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): $query"
        $tasks = invoke-MySQLiteQuery -query $query -Path $PSWorkItemPath
        if ($tasks.count -gt 0) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Found $($tasks.count) matching tasks"
           $results = foreach ($task in $tasks) {
            $t = _newWorkItem $task
            #insert a new typename
            $t.psobject.typenames.insert(0,"PSWorkItemArchive")
            $t
           }
           $results | Sort-Object -Property TaskModified
        }
        else {
            Write-Warning "Failed to find any matching archived tasks"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending."
    } #end

}