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
        [String]$Name,

        [Parameter(HelpMessage = "Specify an updated description.")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(HelpMessage = "Specify an updated due date.")]
        [ValidateNotNullOrEmpty()]
        [DateTime]$DueDate,

        [Parameter(HelpMessage = "Specify an updated category")]
        [ValidateNotNullOrEmpty()]
        [String]$Category,

        [Parameter(HelpMessage = "Specify a percentage complete.")]
        [ValidateRange(0, 100)]
        [int]$Progress,

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
            Connection  = $conn
            KeepAlive   = $true
            Query       = ""
            ErrorAction = "Stop"
        }
    } #begin

    Process {
        <#
        9/16/2022 Issue #2
        Modify how the query string is built. PowerShell doesn't respect culture
        With variable expansion. JDH
        #>
        $BaseQuery = "UPDATE tasks set taskmodified = '{0}'" -f (Get-Date)
        if ($PSBoundParameters.ContainsKey("Category")) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Validating category $category"
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
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Setting task"
            $updates = @{
                name        = $name
                description = $Description
                duedate     = $DueDate
                progress    = $Progress
                category    = $Category
            }
            $updates.GetEnumerator() | Where-Object { $_.value } | ForEach-Object {
                $BaseQuery += ", $($_.key) = '$($_.value)'"
            }
            $BaseQuery += " WHERE ID = '$ID'"
            $splat.query = $BaseQuery
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($splat.query)"
            if ($PSCmdlet.ShouldProcess($splat.query, "Invoke update")) {
                Try {
                    Invoke-MySQLiteQuery @splat
                }
                Catch {
                    Write-Warning "Failed to execute query $($splat.query)"
                    Close-MySQLiteDB -Connection $conn
                    Throw $_
                }

                if ($PassThru) {
                    Write-Debug "Task object"
                    $task | Select-Object * | Out-String | Write-Debug
                    Write-Debug "TaskID = $($task.taskid)"
                    $splat.query = "Select * from tasks where ID = '$ID'"
                    Write-Debug "Query = $($splat.query)"
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($splat.query)"
                    $data = Invoke-MySQLiteQuery @splat
                    $data | Out-String | Write-Verbose
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
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending"
    } #end
}
