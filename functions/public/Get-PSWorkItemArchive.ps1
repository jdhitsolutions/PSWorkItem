Function Get-PSWorkItemArchive {
    [cmdletbinding(DefaultParameterSetName = 'name')]
    [OutputType('PSWorkItemArchive')]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = 'The name of the work item. Wildcards are supported.',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'name'
        )]
        [ValidateNotNullOrEmpty()]
        [alias('task')]
        [String]$Name = '*',

        [Parameter(
            HelpMessage = 'The task ID.',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'id'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID,

        [Parameter(
            HelpMessage = 'Get all open tasks by category',
            ParameterSetName = 'category'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Category,

        [Parameter(HelpMessage = 'The path to the PSWorkItem SQLite database file. It should end in .db')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('\.db$')]
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
    } #begin

    Process {
        #test if archive table has been updated to include the OriginalTaskID column
        $test = Invoke-MySQLiteQuery -Path $path -query "pragma table_info('archive')" | Where-Object name -eq 'id'
        if (-Not $test) {
            Write-Warning "Cannot verify the archive table column ID. Please run Update-PSWorkItemArchive to update the table then try completing the command again. It is recommended that you backup your database before updating the table."
            Return
        }
        Switch ($PSCmdlet.ParameterSetName) {
            'category' { $query = "Select * from archive where category ='$Category' collate nocase" }

            'id' { $query = "Select * from archive where ID ='$ID'" }
            'name' {
                if ($Name -match '\*') {
                    $Name = $name.replace('*', '%')
                    $query = "Select * from archive where name like '$Name' collate nocase"
                }
                else {
                    $query = "Select * from archive where name = '$Name' collate nocase"
                }
            }
        }

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $query"
        $tasks = Invoke-MySQLiteQuery -Query $query -Path $Path
        if ($tasks.count -gt 0) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Found $($tasks.count) matching archived tasks"
            $results = foreach ($task in $tasks) {
                $task | Out-String | Write-Debug
                #March 10, 2023 PSWorkItemArchive is now a defined class
                _newWorkItemArchive $task -path $path
                #insert a new typename
                #$t.PSObject.TypeNames.insert(0, 'PSWorkItemArchive')
                #$t
            }
            $results | Sort-Object -Property TaskModified
        }
        else {
            Write-Warning 'Failed to find any matching archived tasks'
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending."
    } #end

}