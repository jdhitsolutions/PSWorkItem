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
    Write-Debug "[$((Get-Date).TimeOfDay) _newWorkItem] Creating item '$($data.name)' [$($data.taskid)]"
    $item = [PSWorkItem]::new($data.name, $data.category)
    $item.ID = $data.ID
    $item.Description = $data.description
    $item.DueDate = $data.duedate -as [DateTime]
    $item.progress = $data.progress
    $item.taskcreated = $data.TaskCreated -as [DateTime]
    $item.taskmodified = $data.TaskModified -as [DateTime]
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
    $item.DueDate = $data.duedate -as [DateTime]
    $item.progress = 100
    $item.taskcreated = $data.TaskCreated -as [DateTime]
    $item.taskmodified = $data.TaskModified -as [DateTime]
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
        [string]$Block = "Process",
        [string]$Command
    )

    $BlockString = $Block.ToUpper()

    Write-Verbose "[$((Get-Date).TimeOfDay) $BlockString] $([char]27)[1m$($command)$([char]27)[0m: $([char]27)[3m$message$([char]27)[0m"

}