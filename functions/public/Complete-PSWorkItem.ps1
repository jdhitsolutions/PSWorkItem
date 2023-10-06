Function Complete-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess)]
    [Alias('cwi')]
    [OutputType("None","PSWorkItemArchive")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The work item ID.",
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [int]$ID,

        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            {Test-Path $_},
            ErrorMessage = "Could not validate the database path."
        )]
        [String]$Path = $PSWorkItemPath,

        [Parameter(HelpMessage = "Specify the completion date. The default is now.")]
        [ValidateNotNullOrEmpty()]
        [DateTime]$CompletionDate = (Get-Date),

        [Switch]$PassThru
    )
    Begin {
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
        Write-Debug "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): PSBoundParameters"
        $PSBoundParameters | Out-String | Write-Debug

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection  = $Null
            KeepAlive   = $true
            Query       = ""
            ErrorAction = "Stop"
        }
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"

        #28 Sept 2023 Move Path to the process block so the parameter can
        #accept pipeline input by property name.
        _verbose -message ($strings.UsingDB -f $Path)
        if ($conn.state -ne 'Open') {
            Try {
                _verbose -message $strings.OpenDBConnection
                $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
                $conn | Out-String | Write-Debug
                $splat.Connection = $conn
            }
            Catch {
                Throw "$($MyInvocation.MyCommand): $($strings.FailToOpen -f $Path)"
            }
        }

        _verbose -message ($strings.CompleteTask -f $ID)
        #test if archive table has been updated to include the OriginalTaskID column
        $test = Invoke-MySQLiteQuery -Path $path -query "pragma table_info('archive')" |
        Where-Object name -eq 'id'
        if (-Not $test) {
            Write-Warning $strings.FailedArchiveID
            Return
        }
        #validate the task id
        $splat.query = "SELECT * FROM tasks WHERE ID = '$ID'"
        _verbose -message $splat.query
        Try {
            $task = Invoke-MySQLiteQuery @splat
        }
        Catch {
            Write-Warning ($strings.FailedQuery -f $splat.query)
            Close-MySQLiteDB $conn
            Throw $_
        }

        #update the task to mark it complete
        $splat.query = "UPDATE tasks set taskmodified='{0}', completed='1',progress='100' WHERE ID= '{1}'" -f $CompletionDate,$ID
        If ($WhatIfPreference) {
            _verbose "WhatIf: $($splat.query)"
        }
        elseif ($task.ID -eq $ID) {
            if ($PSCmdlet.ShouldProcess($splat.query, "Complete-PSWorkItem")) {
                _verbose -message $splat.query
                Try {
                    Invoke-MySQLiteQuery @splat
                }
                Catch {
                    Write-Warning ($strings.FailedQuery -f $splat.query)
                    #"Failed to execute query $($splat.query)"
                    Close-MySQLiteDB $conn
                    Throw $_
                }
                #copy the task to the archive table
                $splat.query = "INSERT into archive SELECT * from tasks WHERE ID= '$ID'"
                # "INSERT into archive SELECT *,ROWID AS originalid from tasks WHERE RowID= '$ID'"
                _verbose -message $strings.MoveItem
                _verbose -message $splat.query
                Try {
                    Invoke-MySQLiteQuery @splat
                }
                Catch {
                    Write-Warning ($strings.FailedQuery -f $splat.query)
                    Close-MySQLiteDB $conn
                    Throw $_
                }

                #Validate the copy using the task GUID
                $splat.query = "SELECT * from archive WHERE taskid='$($task.taskid)'"
                _verbose -message $strings.ValidateMove
                _verbose -message $splat.query
                Try {
                    $archived = Invoke-MySQLiteQuery @splat
                }
                Catch {
                    Write-Warning ($strings.FailedQuery -f $splat.query)
                    Close-MySQLiteDB $conn
                    Throw $_
                }
                if ($archived.taskid -eq $task.taskId) {
                    #remove the task from the tasks table
                    $splat.query = "DELETE from tasks WHERE taskid = '$($task.taskid)'"
                    _verbose -message $strings.RemoveTask
                    Write-Debug $splat.query
                    Try {
                        Invoke-MySQLiteQuery @splat
                    }
                    Catch {
                        Write-Warning ($strings.FailedQuery -f $splat.query)
                        Close-MySQLiteDB $conn
                        Throw $_
                    }
                }
                else {
                    Write-Warning ($strings.FailedVerifyTaskID -f $id,$task.taskID)
                }
                if ($PassThru) {
                    $splat.Query = "SELECT * from archive WHERE taskid='$($task.taskid)'"
                    Try {
                        $pass = Invoke-MySQLiteQuery @splat
                        #March 10, 2023 PSWorkItemArchive is now a defined class
                        _newWorkItemArchive $pass -path $Path
                    }
                    Catch {
                        Write-Warning ($strings.FailedQuery -f $splat.query)
                        Close-MySQLiteDB $conn
                        Throw $_
                    }
                }
            } #WhatIf
        } #if ID verified
        else {
            Write-Warning ($strings.FailedToFind -f $id)
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        if ($conn.state -eq 'Open') {
            _verbose -message ($strings.CloseDBConnection -f $path)
            Close-MySQLiteDB -Connection $conn
        }
        _verbose -message $strings.Ending
    } #end
}
