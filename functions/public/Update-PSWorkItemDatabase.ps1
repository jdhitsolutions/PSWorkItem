<#
update the PSWorkItemArchive table to add the Original ID column to support
#Issue #7
https://github.com/jdhitsolutions/PSWorkItem/issues/7
#>

Function Update-PSWorkItemDatabase {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('none','MySQLiteTableDetail')]
    [alias('alias')]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "The path to the PSWorkItem SQLite database file. It should end in .db")]
        [ValidatePattern("\.db$")]
        [ValidateScript(
            {
                $parent = Split-Path -Path $_ -Parent
                Test-Path $parent
            },
            ErrorMessage = "Failed to validate the parent path."
        )]
        [String]$Path = $PSWorkItemPath,
        [Switch]$PassThru
    )

    Begin {
        StartTimer
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        if ($MyInvocation.CommandOrigin -eq 'Runspace') {
            #Hide this metadata when the command is called from another command
            _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
            _verbose -message ($strings.UsingHost -f $host.Name)
            _verbose -message ($strings.UsingOS -f $PSVersionTable.OS)
            _verbose -message ($strings.UsingModule -f $ModuleVersion)
            _verbose -message ($strings.UsingDB -f $path)
            _verbose ($strings.DetectedCulture -f (Get-Culture))
        }

        $dbConnection = Open-MySQLiteDB -Path $Path
        $splat = @{
            Connection = $dbConnection
            Query = ""
            KeepAlive = $True
        }
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        _verbose -message ($strings.UsingDB -f $Path)
        #UPDATE ARCHIVE TABLE
        #test for column existence
        _verbose -message ($strings.TestColumnID)
        $splat.Query = "pragma table_info('archive')"
        $test = Invoke-MySQLiteQuery @splat | Where-Object name -eq 'ID'
        if ($test) {
            Write-Warning $strings.IDColumnExists
        }
        else {
            _verbose -message $strings.AddIDColumn
            #append the new column
            #It is impossible to set a value for the ID column in the archive table
            #since there is no way of knowing what the original ID was. Set the ID to 0.
            If ($PSCmdlet.ShouldProcess("table archive","Adding column ID")) {
                $splat.query = "ALTER TABLE archive ADD id integer;"
                Invoke-MySQLiteQuery @splat

                _verbose -message $strings.UpdateArchiveTable
                $splat.query = "Select taskId,RowID from archive"
                $items = Invoke-MySQLiteQuery @splat
                Foreach ($item in $items) {
                    $splat.query = "UPDATE archive set id = '0' Where taskid='{0}'" -f $item.taskid
                    _verbose -message $splat.query
                    Invoke-MySQLiteQuery @splat
                }
            } #WhatIf
        }
        #UPDATE TASKS TABLE
        #test for column existence
        _verbose -message $strings.TestingColumnID
        $splat.query = "pragma table_info('tasks')"
        $test = Invoke-MySQLiteQuery @splat | Where-Object name -eq 'ID'
        if ($test) {
            Write-Warning $strings.IDColumnExists
        }
        else {
            _verbose -message $strings.AddIDColumn
            If ($PSCmdlet.ShouldProcess("table tasks","Adding column ID")) {
                $splat.query = "ALTER TABLE tasks ADD id integer;"
                Invoke-MySQLiteQuery @splat

                #Update ID column with RowID
                _verbose -message $strings.UpdateTaskTable
                $splat.query = "Select taskId,RowID from tasks"
                $items = Invoke-MySQLiteQuery @splat
                Foreach ($item in $items) {
                    $splat.query = "UPDATE tasks set id = '{0}' Where taskid='{1}'" -f $item.rowid,$item.taskid
                    _verbose -message $splat.query
                    Invoke-MySQLiteQuery @splat
                }
            } #WhatIf
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        If ($PassThru -AND (-Not $WhatIfPreference)) {
            Get-MySQLiteTable -Connection $dbConnection -KeepAlive -Detail | Where-Object table -eq archive
        }
        If ($PassThru -AND (-Not $WhatIfPreference)) {
            Get-MySQLiteTable -Connection $dbConnection -Detail | Where-Object table -eq archive
        }
        _verbose -message $strings.CloseDBConnection
        Close-MySQLiteDB -Connection $dbConnection
        _verbose -message $strings.Ending
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end

} #close Update-PSWorkItemDatabase