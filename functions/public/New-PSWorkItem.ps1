Function New-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess)]
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
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Select a valid catetory"
            )]
        [ValidateNotNullOrEmpty()]
        [string]$Category,
        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = "Add a comment or task description"
            )]
        [alias("comment")]
        [string]$Description,
        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = "When is this task due? The default is 30 days from now.")]
        [datetime]$DueDate = (Get-Date).AddDays(30),
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
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Validating category $Category"
        $splat.query = "SELECT * FROM categories WHERE category = '$Category' collate nocase"
        $cat = Invoke-MySQLiteQuery @splat
        if ($cat.category -eq $Category) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Adding task $name with category $Category due $dueDate"
            $task = [psworkitem]::new($Name, $Category)
            $task.description = $Description
            $task.duedate = $DueDate
            $splat.query = "Insert into tasks (taskid,taskcreated,taskmodified,name,description,category,duedate,progress,completed) values ('$($task.taskid)', '$($Task.TaskCreated)','$($task.TaskModified)','$($task.name)','$($task.description)','$($task.Category)', '$($task.Duedate)', '$($task.progress)','$($task.completed)')"
            Write-Verbose $splat.query
            if ($pscmdlet.ShouldProcess($task.name)) {
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

