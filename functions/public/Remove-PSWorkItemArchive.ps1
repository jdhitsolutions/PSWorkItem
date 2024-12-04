Function Remove-PSWorkItemArchive {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = 'id')]
    [alias('rwi')]
    [outputType('None')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'The archive work item ID.',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'id'
        )]
        [ValidateNotNullOrEmpty()]
        [int]$ID,

        [Parameter(
            HelpMessage = 'The name of the archive work item. Wildcards are supported.',
            ParameterSetName = 'name'
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [alias('task')]
        [String]$Name,

        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            { Test-Path $_ },
            ErrorMessage = 'Could not validate the database path.'
        )]
        [String]$Path = $PSWorkItemPath
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
            $attributes.ParameterSetName = 'Category'
            $attributes.Mandatory = $True
            $attributes.HelpMessage = 'Removed archived PSWorkItems by the selected category'

            # Adding ValidateSet parameter validation
            #only get categories used in the Archive table
            #It is possible categories might be entered in different cases in the database
            [string[]]$value = (Get-PSWorkItemData -Table Categories -Path $Path).Category |
            ForEach-Object { [CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) } |
            Select-Object -Unique | Sort-Object
            $v = New-Object System.Management.Automation.ValidateSetAttribute($value)
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
        StartTimer
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        if ($MyInvocation.CommandOrigin -eq 'Runspace') {
            #Hide this metadata when the command is called from another command
            _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
            _verbose -message ($strings.UsingHost -f $host.Name)
            _verbose -message ($strings.UsingOS -f $PSVersionTable.OS)
            _verbose -message ($strings.UsingModule -f $ModuleVersion)
            _verbose -message ($strings.UsingDB -f $path)
            _verbose ($strings.DetectedCulture -f (Get-Culture))
        }
        Write-Debug "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): PSBoundParameters"
        $PSBoundParameters | Out-String | Write-Debug
        _verbose $strings.OpenDBConnection
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
        Switch ($PSCmdlet.ParameterSetName) {
            'id' {
                _verbose -message ($strings.RemoveArchivedTask -f $ID)
                $splat.query = "SELECT * FROM archive WHERE id = '$ID'"
                $warn = ($strings.FailedToFindArchiveID -f $ID)
            }
            'category' {
                $Category = $PSBoundParameters['Category']
                _verbose -message ($strings.RemoveArchivedTaskCategory -f $Category)
                $splat.query = "SELECT * FROM archive WHERE category = '$Category' collate nocase"
                $warn = ($strings.FailedToFindArchiveCategory -f $Category)
            }
            'name' {
                _verbose -message ($strings.RemoveArchivedTaskName -f $Name)
                if ($Name -match '\*') {
                    $Name = $name.replace('*', '%')
                }
                $splat.query = "SELECT * FROM archive WHERE name like '$name' collate nocase"
                $warn = ($strings.FailedToFindArchiveName -f $Name)
            }
        }

        _verbose -message $splat.query
        $tasks = Invoke-MySQLiteQuery @splat
        if ($tasks.taskid) {
            #An older database that was upgraded might have multiple items
            #with the same ID
            foreach ($task in $tasks) {
                $splat.query = "DELETE FROM archive WHERE taskid = '$($task.taskid)'"
                if ($PSCmdlet.ShouldProcess($task.taskid, 'Remove-PSWorkItemArchive')) {
                    Invoke-MySQLiteQuery @splat
                }
            } #foreach
        }
        else {
            Write-Warning $warn
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
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end

}
