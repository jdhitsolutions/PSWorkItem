Function Remove-PSWorkItemArchive {
    [cmdletbinding(SupportsShouldProcess,DefaultParameterSetName = "id")]
    [alias("rwi")]
    [outputType("None")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The archive work item ID.",
            ValueFromPipelineByPropertyName,
            ParameterSetName = "id"
        )]
        [ValidateNotNullOrEmpty()]
        [int]$ID,

        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "A PSWorkItem category",
            ParameterSetName = "category"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Category,

        [Parameter(
            Position = 0,
            HelpMessage = "The name of the archive work item. Wildcards are supported.",
            ParameterSetName = "name"
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [alias("task")]
        [String]$Name,

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
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): PSBoundParameters"
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
        Switch ($PSCmdlet.ParameterSetName) {
            "id" {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Removing archived task $ID"
                $splat.query = "SELECT * FROM archive WHERE id = '$ID'"
                $warn = "Failed to find an archived work item with an ID of $id"
            }
            "category" {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Removing archived tasks in the $category category"
                $splat.query = "SELECT * FROM archive WHERE category = '$Category' collate nocase"
                $warn = "Failed to find matching archived work items in the $Category category"
            }
            "name" {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Removing archived tasks by name $Name"
                if ($Name -match "\*") {
                    $Name = $name.replace("*", "%")
                }
                $splat.query = "SELECT * FROM archive WHERE name like '$name' collate nocase"
                $warn = "Failed to find any archived work items called $name"
            }
        }

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($splat.query)"
        $tasks = Invoke-MySQLiteQuery @splat
        if ($tasks.taskid) {
            #An older database that was upgraded might have multiple items
            #with the same ID
            foreach ($task in $tasks) {
                $splat.query = "DELETE FROM archive WHERE taskid = '$($task.taskid)'"
                if ($PSCmdlet.ShouldProcess($task.taskid, "Remove-PSWorkItemArchive")) {
                    Invoke-MySQLiteQuery @splat
                }
            } #foreach
        }
        else {
            Write-Warning $warn
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
