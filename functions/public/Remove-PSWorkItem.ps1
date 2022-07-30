Function  Remove-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess)]
    [alias("rwi")]
    [outputType("None")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The work item ID.",
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [int]$ID,

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
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting"
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): PSBoundparameters"
        $PSBoundParameters | Out-String | Write-Verbose
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Opening a connection to $Path"
        Try {
            $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
            $conn | Out-String | Write-Debug
        }
        Catch {
            Throw "$($myinvocation.mycommand): Failed to open the database $Path"
        }

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection = $conn
            KeepAlive  = $true
            Query      = ""
        }
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Removing task $ID"
        #get the task by RowID
        $splat.query = "SELECT * FROM tasks WHERE rowid = '$ID'"
        $task = Invoke-MySQLiteQuery @splat
        $splat.query = "DELETE FROM tasks WHERE taskid = '$($task.taskid)'"
        if ($pscmdlet.ShouldProcess($task.taskid, "Remove-PSWorkItem")) {
            Invoke-MySQLiteQuery @splat
        }
    } #process

    End {
        if ($conn.state -eq 'Open') {
            Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Closing database connection."
            Close-MySQLiteDB -Connection $conn
        }
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending "
    } #end

}
