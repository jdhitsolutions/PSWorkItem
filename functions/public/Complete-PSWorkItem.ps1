Function Complete-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess)]
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
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Completing task id $ID "
        #validate the task id
        $splat.query = "SELECT *,RowID FROM tasks WHERE RowID = '$ID'"
        Write-Debug $splat.query
        $task = Invoke-MySQLiteQuery @splat
        if ($task.RowID -eq $ID) {

            #update the task to mark it complete
            $splat.query = "UPDATE tasks set taskmodified='$(Get-Date)', completed='1',progress='100' WHERE RowID= '$ID'"
            if ($Pscmdlet.ShouldProcess($splat.query, "Complete-PSWorkItem")) {
                Invoke-MySQLiteQuery @splat
                #copy the task to the archive table
                $splat.query = "INSERT into archive SELECT * from tasks WHERE RowID= '$ID'"
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Moving item to Archive."
                Write-Debug $splat.query
                Invoke-MySQLiteQuery @splat
                #Validate the copy using the task GUID
                $splat.query = "SELECT * from archive WHERE taskid= '$($task.taskid)'"
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Validating the move"
                Write-Debug $splat.query

                $archived = Invoke-MySQLiteQuery @splat
                if ($archived.taskid -eq $task.taskId) {
                    #remove the task from the tasks table
                    $splat.query = "DELETE from tasks WHERE taskid = '$($task.taskid)'"
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Removing the original task"
                    Write-Debug $splat.query
                    Invoke-MySQLiteQuery @splat
                }
                else {
                    Write-Warning "Could not verify that task $ID [$($task.taskid)] was copied to the archive table."
                }

            } #Whatif
        } #if ID verified
        else {
            Write-Warning "Failed to find task with id $ID"
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
