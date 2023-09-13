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
        [Parameter(Position = 0, HelpMessage = "The path to the PSWorkItem SQLite database file. It should end in .db")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\.db$")]
        [ValidateScript({
            $parent = Split-Path -Path $_ -Parent
            if (Test-Path $parent) {
                Return $True
            }
            else {
                Throw "Failed to validate the parent path $parent."
                Return $False
            }
        })]
        [String]$Path = $PSWorkItemPath,
        [Switch]$PassThru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Opening database connection to $Path"
        $dbConnection = Open-MySQLiteDB -Path $Path
        $splat = @{
            Connection = $dbConnection
            Query = ""
            KeepAlive = $True
        }
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $Path"
        #UPDATE ARCHIVE TABLE
        #test for column existence
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Testing for column ID"
        $splat.Query = "pragma table_info('archive')"
        $test = Invoke-MySQLiteQuery @splat | Where-Object name -eq 'ID'
        if ($test) {
            Write-Warning "The column ID already exists in the archive table. No further action needed."
        }
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding the column ID"
            #append the new column
            #It is impossible to set a value for the ID column in the archive table
            #since there is no way of knowing what the original ID was. Set the ID to 0.
            If ($PSCmdlet.ShouldProcess("table archive","Adding column ID")) {
                $splat.query = "ALTER TABLE archive ADD id integer;"
                Invoke-MySQLiteQuery @splat

                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating archive table values"
                $splat.query = "Select taskId,RowID from archive"
                $items = Invoke-MySQLiteQuery @splat
                Foreach ($item in $items) {
                    $splat.query = "UPDATE archive set id = '0' Where taskid='{0}'" -f $item.taskid
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($splat.query)"
                    Invoke-MySQLiteQuery @splat
                }
            } #WhatIf
        }
        #UPDATE TASKS TABLE
        #test for column existence
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Testing for column ID"
        $splat.query = "pragma table_info('tasks')"
        $test = Invoke-MySQLiteQuery @splat | Where-Object name -eq 'ID'
        if ($test) {
            Write-Warning "The column ID already exists in the tasks table. No further action needed."
        }
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding the column ID"
            If ($PSCmdlet.ShouldProcess("table tasks","Adding column ID")) {
                $splat.query = "ALTER TABLE tasks ADD id integer;"
                Invoke-MySQLiteQuery @splat

                #Update ID column with RowID
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating tasks table values"
                $splat.query = "Select taskId,RowID from tasks"
                $items = Invoke-MySQLiteQuery @splat
                Foreach ($item in $items) {
                    $splat.query = "UPDATE tasks set id = '{0}' Where taskid='{1}'" -f $item.rowid,$item.taskid
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($splat.query)"
                    Invoke-MySQLiteQuery @splat
                }
            } #WhatIf
        }
    } #process

    End {
        If ($PassThru -AND (-Not $WhatIfPreference)) {
            Get-MySQLiteTable -Connection $dbConnection -KeepAlive -Detail | Where-Object table -eq archive
        }
        If ($PassThru -AND (-Not $WhatIfPreference)) {
            Get-MySQLiteTable -Connection $dbConnection -Detail | Where-Object table -eq archive
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Closing database connection"
        Close-MySQLiteDB -Connection $dbConnection
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Update-PSWorkItemDatabase