Function New-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = 'date')]
    [alias('nwi')]
    [OutputType('none', 'PSWorkItem')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'The name of the work item. Do not include apostrophes.',
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript(
            { $_ -notMatch "'" },
            ErrorMessage = 'Do not include apostrophes in the name.'
        )]
        [alias('task')]
        [String]$Name,

        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Add a comment or task description. Do not include apostrophes.'
        )]
        [alias('comment')]
        [ValidateScript(
            { $_ -notMatch "'" },
            ErrorMessage = 'Do not include apostrophes in the description.'
        )]
        [String]$Description,
        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = "When is this task due? The default is the value of `$PSWorkItemDefaultDays.",
            ParameterSetName = 'date'
        )]
        [Alias('Date')]
        [DateTime]$DueDate = (Get-Date).AddDays($global:PSWorkItemDefaultDays),

        [Parameter(
            HelpMessage = 'Specify the number of days before the task is due to be completed. Enter a value between 1 and 365',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'days'
        )]
        [ValidateRange(1, 365)]
        [int]$DaysDue,

        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            { Test-Path $_ },
            ErrorMessage = 'Could not validate the database path.'
        )]
        [String]$Path = $PSWorkItemPath,

        [Switch]$PassThru
    )
    DynamicParam {
        # Added 26 Sept 2023 to support dynamic categories based on path
        if (-Not $PSBoundParameters.ContainsKey('Path')) {
            $Path = $global:PSWorkItemPath
        }
        If (Test-Path $Path) {
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            # Defining parameter attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.HelpMessage = 'Select a valid category. You can run Get-PSWorkItemCategory to see the list.'
            $attributes.ValueFromPipelineByPropertyName = $True
            $attributes.Mandatory = $True
            $attributes.Position = 1

            # Adding ValidateSet parameter validation
            #It is possible categories might be entered in different cases in the database
            [string[]]$values = (Get-PSWorkItemData -Table Categories -Path $Path).Category |
            ForEach-Object { [CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) } |
            Select-Object -Unique | Sort-Object
            $v = New-Object System.Management.Automation.ValidateSetAttribute($values
            )
            $AttributeCollection.Add($v)

            # Adding ValidateNotNullOrEmpty parameter validation
            $v = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
            $AttributeCollection.Add($v)
            $attributeCollection.Add($attributes)

            # Defining the runtime parameter
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('Category', [String], $attributeCollection)
            $paramDictionary.Add('Category', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam

    Begin {
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingDB -f $path)
        Try {
            $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
            $conn | Out-String | Write-Debug
        }
        Catch {
            Throw "$($MyInvocation.MyCommand): $($strings.FailToOpen -f $Path)"
        }

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection = $conn
            KeepAlive  = $true
            Query      = ''
        }
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        $test = Invoke-MySQLiteQuery -Path $path -Query "pragma table_info('archive')" | Where-Object name -EQ 'ID'
        if (-Not $test) {
            Write-Warning $strings.CannotVerifyIDColumn
            Return
        }
        if ($PSCmdlet.ParameterSetName -eq 'days') {
            $DueDate = (Get-Date).AddDays($DaysDue)
        }
        $Category = $PSBoundParameters['Category']
        _verbose -message ($strings.ValidateCategory -f $category)
        $splat.query = "SELECT * FROM categories WHERE category = '$Category' collate nocase"
        $cat = Invoke-MySQLiteQuery @splat
        if ($cat.category -eq $Category) {
            _verbose -message ($strings.AddTask -f $Name, $Category, $DueDate)
            #create a new instance of the PSWorkItem class
            $task = [PSWorkItem]::new($Name, $Category)
            $task.description = $Description
            $task.duedate = $DueDate
            #Calculate ID
            # Get highest TaskNumber from the archive items
            $archiveID = _getLastTaskID -table archive -path $path
            # Get highest TaskNumber from tasks
            $taskID = _getLastTaskID -table tasks -path $path
            $LastID = $archiveID, $taskID | Sort-Object | Select-Object -Last 1
            $task.ID = $LastID + 1

            <#
                If Archive TaskNumber is 0 or null, use the RowID as the new TaskNumber value for the task
                if the archive TaskNumber is equal to the task RowID, set the new TaskNumber value to RowID+1
                if task TaskNumber >= archive TaskNumber, set the new TaskNumber to highest Task TaskNumber+1
            #>
            Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Detected culture $(Get-Culture)"
            Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Inserting task:"
            $task | Select-Object * | Out-String | Write-Debug
            <#
            6 Aug 2022 variable expansion appears to be culture-invariant. This is a problem
            with datetime values. Explicitly getting a string appears to resolve problem. - JDH
            #>

            _verbose -message ($strings.TaskCreated -f $task.taskcreated.ToString())
            $splat.query = "Insert into tasks (taskid,taskcreated,taskmodified,name,description,category,duedate,progress,completed,id) values ('$($task.taskid)', '$($Task.TaskCreated.toString())','$($task.TaskModified.ToString())','$($task.name)','$($task.description)','$($task.Category)', '$($task.Duedate.ToString())', '$($task.progress)','$($task.completed)','$($task.id)')"

            _verbose -message $splat.query
            $global:q = $splat.query
            $whatIf = '{0} [{1}] Category: {2} Due: {3}' -f $task.name, $task.description, $task.category, $task.duedate
            if ($PSCmdlet.ShouldProcess($whatIf, 'Create PSWorkItem')) {
                Invoke-MySQLiteQuery @splat
                if ($PassThru) {
                    Write-Debug 'Task object'
                    $task | Select-Object * | Out-String | Write-Debug
                    Write-Debug "TaskID = $($task.taskid)"
                    $splat.query = "Select * from tasks where taskid = '$($task.taskid)'"
                    Write-Debug "Query = $($splat.query)"
                    _verbose -message $splat.query
                    $data = Invoke-MySQLiteQuery @splat
                    $data | Out-String | Write-Debug
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
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        if ($conn.state -eq 'Open') {
            _verbose -message $strings.CloseDBConnection
            Close-MySQLiteDB -Connection $conn
        }
        _verbose -message $strings.Ending

    } #end
}

