Function Set-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess)]
    [alias("swi")]
    [OutputType("None", "PSWorkItem")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The work item ID.",
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [int]$ID,

        [Parameter(HelpMessage = "The name of the work item.")]
        [ValidateNotNullOrEmpty()]
        [alias("task")]
        [string]$Name,

        [Parameter(HelpMessage = "Specify an updated description.")]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(HelpMessage = "Specify an updated due date.")]
        [ValidateNotNullOrEmpty()]
        [datetime]$DueDate,

        [Parameter(HelpMessage = "Specify an updated category")]
        [ValidateNotNullOrEmpty()]
        [string]$Category,

        [Parameter(HelpMessage = "Specify a percentage complete.")]
        [ValidateRange(0, 100)]
        [int]$Progress,

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
            Connection  = $conn
            KeepAlive   = $true
            Query       = ""
            ErrorAction = "Stop"
        }
    } #begin

    Process {
        $basequery = "UPDATE tasks set taskmodified = '$(Get-Date)'"
        if ($PSBoundParameters.ContainsKey("Category")) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Validating category $category"
            $splat.query = "SELECT * FROM categories WHERE category = '$Category' collate nocase"
            Try {
                $cat = Invoke-MySQLiteQuery @splat
            }
            Catch {
                Write-Warning "Failed to execute query $($splat.query)"
                Close-MySQLiteDB -Connection $conn
                Throw $_
            }
        }
        if (($cat.category -eq $Category) -OR (-Not $PSBoundParameters.ContainsKey("Category"))) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Setting task"
            $updates = @{
                name        = $name
                description = $Description
                duedate     = $DueDate
                progress    = $Progress
                category    = $Category
            }
            $updates.GetEnumerator() | Where-Object { $_.value } | ForEach-Object {
                $basequery += ", $($_.key) = '$($_.value)'"
            }
            $basequery += " WHERE ROWID = '$ID'"
            $splat.query = $basequery
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): $($splat.query)"
            if ($pscmdlet.ShouldProcess($splat.query, "Invoke update")) {

                Try {
                    Invoke-MySQLiteQuery @splat
                }
                Catch {
                    Write-Warning "Failed to execute query $($splat.query)"
                    Close-MySQLiteDB -Connection $conn
                    Throw $_
                }

                if ($passthru) {
                    Write-Debug "Task object"
                    $task | Select-Object * | Out-String | Write-Debug
                    Write-Debug "TaskID = $($task.taskid)"
                    $splat.query = "Select *,RowID from tasks where RowID = '$ID'"
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
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end
}
