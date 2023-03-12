Function Remove-PSWorkItem {
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
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): PSBoundparameters"
        $PSBoundParameters | Out-String | Write-Verbose
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Opening a connection to $Path"
        Try {
            $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
            $conn | Out-String | Write-Debug
        }
        Catch {
            Throw "$($MyInvocation.MyCommand): Failed to open the database $Path"
        }

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection = $conn
            KeepAlive  = $true
            Query      = ""
        }
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Removing task $ID"
        $splat.query = "SELECT * FROM tasks WHERE id = '$ID' collate nocase"
        $task = Invoke-MySQLiteQuery @splat
        $splat.query = "DELETE FROM tasks WHERE taskid = '$($task.taskid)'"
        if ($PSCmdlet.ShouldProcess($task.taskid, "Remove-PSWorkItem")) {
            Invoke-MySQLiteQuery @splat
        }
    } #process

    End {
        if ($conn.state -eq 'Open') {
            Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Closing database connection."
            Close-MySQLiteDB -Connection $conn
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending "
    } #end

}
