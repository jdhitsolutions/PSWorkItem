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
        [string]$Name,
        [Parameter(
            Position = 1,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select a valid catetory"
            )]
        [ValidateNotNullOrEmpty()]
        [string]$Category,
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Add a comment or task description"
            )]
        [alias("comment")]
        [string]$Description,
        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = "When is this task due? The default is 30 days from now.",
            ParameterSetName = "date"
            )]
        [datetime]$DueDate = (Get-Date).AddDays(30),

        [Parameter(
            HelpMessage = "Specify the number of days before the task is due to be completed. Enter a value between 1 and 365",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "days"
            )]
        [ValidateRange(1,365)]
        [int]$DaysDue,

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
        [string]$Path = $PSWorkItemPath,

        [switch]$Passthru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting"
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
            KeepAlive = $true
            Query = ""
        }
    } #begin

    Process {
        if ($pscmdlet.ParameterSetName -eq 'days') {
            $DueDate = (Get-Date).AddDays($DaysDue)
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Validating category $Category"
        $splat.query = "SELECT * FROM categories WHERE category = '$Category' collate nocase"
        $cat = Invoke-MySQLiteQuery @splat
        if ($cat.category -eq $Category) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Adding task $name with category $Category due $dueDate"
            $task = [psworkitem]::new($Name, $Category)
            $task.description = $Description
            $task.duedate = $DueDate
            Write-Debug "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Detected culture $(Get-Culture)"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Inserting task:"
            $task | Select-Object * | Out-String | Write-Debug
            <#
            6 Aug 2022 variable expansion appears to be culture-invariant. This is a problem
            with datetime values. Explicitly getting a string appears to resolve problem. - JDH
            #>
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Task created $($task.taskcreated.ToString())"
            $splat.query = "Insert into tasks (taskid,taskcreated,taskmodified,name,description,category,duedate,progress,completed) values ('$($task.taskid)', '$($Task.TaskCreated.toString())','$($task.TaskModified.ToString())','$($task.name)','$($task.description)','$($task.Category)', '$($task.Duedate.ToString())', '$($task.progress)','$($task.completed)')"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($splat.query)"
            $whatIf = "{0} [{1}] Category: {2} Due: {3}" -f $task.name,$task.description,$task.category,$task.duedate
            if ($pscmdlet.ShouldProcess($whatIf, "Create PSWorkitem")) {
                Invoke-MySQLiteQuery @splat
                if ($Passthru) {
                    Write-Debug "Task object"
                    $task | Select-Object * | Out-String | Write-Debug
                    Write-Debug "TaskID = $($task.taskid)"
                    $splat.query = "Select *,RowID from tasks where taskid = '$($task.taskid)'"
                    Write-Debug "Query = $($splat.query)"
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): $($splat.query)"
                    $data = Invoke-MySQLiteQuery @splat
                    $data | Out-String | Write-Verbose
                    _newWorkItem $data
                }
            }
        }
        else {
            Write-Warning "The category $category is not valid."
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

