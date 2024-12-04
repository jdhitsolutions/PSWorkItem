#private helper functions

Function StartTimer {
    $script:timer = [System.Diagnostics.Stopwatch]::new()
    $script:timer.Start()
}

Function StopTimer {
    if ($script:timer.IsRunning) {
        $script:timer.Stop()
    }
    $script:timer.Elapsed
}

function _newWorkItem {
    [cmdletbinding()]
    Param([object]$data, [String]$path)

    # modified 6 August 2022 to explicitly set datetime values to handle culture - JDH
    Write-Debug "[$((Get-Date).TimeOfDay) _newWorkItem] $($data | Out-String)"

    Write-Debug "[$((Get-Date).TimeOfDay) _newWorkItem] Creating item '$($data.name) - $($data.category)' [$($data.TaskId)]"
    $item = [PSWorkItem]::new($data.name, $data.category)
    $item.ID = $data.ID
    $item.Description = $data.description
    $item.progress = $data.progress
    # 21 August 2024 - Don't force the datetime conversion. The property should handle it.
    # This is related to fixing datetime handling in the MySQLite module
    $item.DueDate = $data.DueDate #-as [DateTime]
    $item.TaskCreated = $data.TaskCreated #-as [DateTime]
    $item.TaskModified = $data.TaskModified #-as [DateTime]
    $item.Completed = $data.completed
    $item.taskId = $data.TaskId
    if ($path -ne '') {
        $item.path = Convert-Path $path
    }

    $item | Select-Object * | Out-String | Write-Debug
    $item
}

function _newWorkItemArchive {
    [cmdletbinding()]
    Param([object]$data, [String]$path)

    Write-Debug "[$((Get-Date).TimeOfDay) _newWorkItemArchive] Creating item '$($data.name)' [$($data.taskid)]"

    $data | Select-Object * | Out-String | Write-Debug

    $item = [PSWorkItemArchive]::new()
    $item.name = $data.name
    $item.Category = $data.category
    $item.ID = If ($data.ID -is [DBNull]) { 0 } else { $data.id }
    $item.Description = $data.description
    $item.progress = 100
    # 21 August 2024 - Don't force the datetime conversion. The property should handle it.
    # This is related to fixing datetime handling in the MySQLite module
    $item.DueDate = $data.DueDate # - as [DateTime]
    $item.TaskCreated = $data.TaskCreated # -as [DateTime]
    $item.TaskModified = $data.TaskModified #-as [DateTime]
    $item.Completed = $data.completed
    $item.taskId = $data.TaskId

    if ($path -ne '') {
        $item.path = Convert-Path $path
    }

    $item | Select-Object * | Out-String | Write-Debug
    $item
}

function _getLastTaskID {
    [cmdletbinding()]
    Param([string]$table, [String]$path)
    #Get the last TaskNumber value from the specified table

    $query = "Select ID from $table Order By ID DESC Limit 1"
    Write-Debug "[$((Get-Date).TimeOfDay) _getLastTaskID] $query"
    Try {
        $r = Invoke-MySQLiteQuery -Path $path -Query $query -ErrorAction Stop
    }
    Catch {
        $r = @{ID = 0 }
    }
    $r.ID
}

function _verbose {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Message,
        [string]$Block = 'PROCESS',
        [string]$Command
    )

    #Display each command name in a different color sequence
    if ($script:VerboseANSI.ContainsKey($Command)) {
        [string]$ANSI = $script:VerboseANSI[$Command]
    }
    else {
        [string]$ANSI = $script:VerboseANSI['DEFAULT']
    }

    $BlockString = $Block.ToUpper().PadRight(7, ' ')
    $Reset = "$([char]27)[0m"
    $ToD = (Get-Date).TimeOfDay
    $AnsiCommand = "$([char]27)$Ansi$($command)"
    $Italic = "$([char]27)[3m"
    if ($Host.Name -eq 'Windows PowerShell ISE Host') {
        $msg = '[{0:hh\:mm\:ss\:ffff} {1}] {2}-> {3}' -f $Tod, $BlockString, $Command, $Message
    }
    else {
        $msg = '[{0:hh\:mm\:ss\:ffff} {1}] {2}{3}-> {4} {5}{3}' -f $Tod, $BlockString, $AnsiCommand, $Reset, $Italic, $Message
    }
    #use the built-in Write-Verbose cmdlet
    Microsoft.PowerShell.Utility\Write-Verbose -Message $msg

}

<# function _verbose {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Message,
        [string]$Block = "Process",
        [string]$Command
    )

    $BlockString = $Block.ToUpper()

    Write-Verbose "[$((Get-Date).TimeOfDay) $BlockString] $([char]27)[1m$($command)$([char]27)[0m: $([char]27)[3m$message$([char]27)[0m"

} #>