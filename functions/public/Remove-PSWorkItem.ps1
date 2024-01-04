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

        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            {Test-Path $_},
            ErrorMessage = "Could not validate the database path."
        )]
        [String]$Path = $PSWorkItemPath
    )
    Begin {
        StartTimer
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
        Write-Debug "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): PSBoundParameters"
        $PSBoundParameters | Out-String | Write-Debug

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection = $Null
            KeepAlive  = $true
            Query      = ""
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
        _verbose -message ($strings.RemoveTaskID -f $ID)
        $splat.query = "SELECT * FROM tasks WHERE id = '$ID' collate nocase"
        $task = Invoke-MySQLiteQuery @splat
        $splat.query = "DELETE FROM tasks WHERE taskid = '$($task.taskid)'"
        if ($PSCmdlet.ShouldProcess($task.taskid, "Remove-PSWorkItem")) {
            Invoke-MySQLiteQuery @splat
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        if ($conn.state -eq 'Open') {
            _verbose -message $strings.CloseDBConnection
            Close-MySQLiteDB -Connection $conn
        }
        _verbose -message $strings.Ending
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end
}
