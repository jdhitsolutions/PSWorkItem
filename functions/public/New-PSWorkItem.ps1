Function New-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess,DefaultParameterSetName = "date")]
    [alias('nwi')]
    [OutputType("none","PSWorkItem")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The name of the work item.",
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [alias("task")]
        [String]$Name,
        [Parameter(
            Position = 1,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select a valid category. You can run Get-PSWorkItemCategory to see the list."
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Category,
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Add a comment or task description"
        )]
        [alias("comment")]
        [String]$Description,
        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = "When is this task due? The default is 30 days from now.",
            ParameterSetName = "date"
        )]
        [Alias("Date")]
        [DateTime]$DueDate = (Get-Date).AddDays(30),

        [Parameter(
            HelpMessage = "Specify the number of days before the task is due to be completed. Enter a value between 1 and 365",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "days"
        )]
        [ValidateRange(1,365)]
        [int]$DaysDue,

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
        [String]$Path = $PSWorkItemPath,

        [Switch]$PassThru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting"
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
            KeepAlive = $true
            Query = ""
        }
    } #begin

    Process {
        $test = Invoke-MySQLiteQuery -Path $path -query "pragma table_info('archive')" | Where-Object name -eq 'ID'
        if (-Not $test) {
            Write-Warning "Cannot verify the tasks table column ID. Please run Update-PSWorkItemDatabase to update the table then try completing the command again. It is recommended that you backup your database before updating the table."
            Return
        }
        if ($PSCmdlet.ParameterSetName -eq 'days') {
            $DueDate = (Get-Date).AddDays($DaysDue)
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Validating category $Category"
        $splat.query = "SELECT * FROM categories WHERE category = '$Category' collate nocase"
        $cat = Invoke-MySQLiteQuery @splat
        if ($cat.category -eq $Category) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Adding task $name with category $Category due $dueDate"
            #create a new instance of the PSWorkItem class
            $task = [PSWorkItem]::new($Name, $Category)
            $task.description = $Description
            $task.duedate = $DueDate
            #Calculate ID
            # Get highest TaskNumber from the archive items
            $archiveID = _getLastTaskID -table archive -path $path
            # Get highest TaskNumber from tasks
            $taskID = _getLastTaskID -table tasks -path $path
            $LastID = $archiveID,$taskID | Sort-Object | Select-Object -last 1
            $task.ID = $LastID+1

            <#
                If Archive TaskNumber is 0 or null, use the RowID as the new TaskNumber value for the task
                if the archive tasknumber is equal to the task RowID, set the new TaskNumber value to RowID+1
                if task tasknumber >= archive tasknumber, set the new Tasknumber to highest Task TaskNumber+1
            #>
            Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Detected culture $(Get-Culture)"
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Inserting task:"
            $task | Select-Object * | Out-String | Write-Debug
            <#
            6 Aug 2022 variable expansion appears to be culture-invariant. This is a problem
            with datetime values. Explicitly getting a string appears to resolve problem. - JDH
            #>
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Task created $($task.taskcreated.ToString())"
            $splat.query = "Insert into tasks (taskid,taskcreated,taskmodified,name,description,category,duedate,progress,completed,id) values ('$($task.taskid)', '$($Task.TaskCreated.toString())','$($task.TaskModified.ToString())','$($task.name)','$($task.description)','$($task.Category)', '$($task.Duedate.ToString())', '$($task.progress)','$($task.completed)','$($task.id)')"
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($splat.query)"
            $global:q = $splat.query
            $whatIf = "{0} [{1}] Category: {2} Due: {3}" -f $task.name,$task.description,$task.category,$task.duedate
            if ($PSCmdlet.ShouldProcess($whatIf, "Create PSWorkItem")) {
                Invoke-MySQLiteQuery @splat
                if ($PassThru) {
                    Write-Debug "Task object"
                    $task | Select-Object * | Out-String | Write-Debug
                    Write-Debug "TaskID = $($task.taskid)"
                    $splat.query = "Select * from tasks where taskid = '$($task.taskid)'"
                    Write-Debug "Query = $($splat.query)"
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($splat.query)"
                    $data = Invoke-MySQLiteQuery @splat
                    $data | Out-String | Write-Verbose
                    #create the work item output
                    _newWorkItem $data -path $Path
                }
            }
        }
        else {
            Write-Warning "The category $category is not valid."
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

