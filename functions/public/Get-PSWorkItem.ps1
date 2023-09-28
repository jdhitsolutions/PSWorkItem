Function Get-PSWorkItem {
    [cmdletbinding(DefaultParameterSetName = 'days')]
    [alias('gwi')]
    [outputType('PSWorkItem')]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = 'The name of the work item. Wildcards are supported.',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'name'
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [alias('task')]
        [String]$Name,

        [Parameter(
            HelpMessage = 'The task ID.',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'id'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID,

        [Parameter(
            HelpMessage = 'Get open tasks due in the number of days between 1 and 365.',
            ParameterSetName = 'days'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 365)]
        [int]$DaysDue = 10,

        [Parameter(
            HelpMessage = 'Get all open tasks',
            ParameterSetName = 'all'
        )]
        [Switch]$All,

        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            { Test-Path $_ },
            ErrorMessage = 'Could not validate the database path.'
        )]
        [String]$Path = $global:PSWorkItemPath
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
            $attributes.HelpMessage = 'Get all open tasks by category'

            # Adding ValidateSet parameter validation
            #It is possible categories might be entered in different cases in the database
            [string[]]$values = (Get-PSWorkItemData -Table Categories -Path $Path).Category |
            ForEach-Object { [CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) } |
            Select-Object -Unique | Sort-Object
            $v = [System.Management.Automation.ValidateSetAttribute]::New($values)
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
        _verbose ($strings.DetectedCulture -f (Get-Culture))
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        $results = [System.Collections.Generic.list[object]]::new()
        _verbose -message ($strings.DetectedParameterSet -f $PSCmdlet.ParameterSetName)
        Switch -regex ($PSCmdlet.ParameterSetName) {
            'all|days' { $query = 'Select * from tasks' }
            'category' { $query = "Select * from tasks where category ='$($PSBoundParameters['Category'])' collate nocase" }
            <#
                6 August 2022 -JDH
                Because SQLite doesn't have a datetime type, querying is messy. It is just
                as easy to get everything and then use PowerShell to filter by date. This
                also simplifies things when running under different cultures.
                "days" {
                        $d = (Get-Date).AddDays($DaysDue)
                        $query = "Select * from tasks where duedate <= '$d' collate nocase"
                    }
            #>
            'id' { $query = "Select * from tasks where ID ='$ID'" }
            'name' {
                if ($Name -match '\*') {
                    $Name = $name.replace('*', '%')
                }
                $query = "Select * from tasks where name = '$Name' collate nocase"
            }
        }

        _verbose -message $query
        $tasks = Invoke-MySQLiteQuery -Query $query -Path $Path

        if ($tasks.count -gt 0) {
            _verbose -message ($strings.FoundMatching -f $tasks.count)
            if ($PSCmdlet.ParameterSetName -eq 'days') {
                $d = (Get-Date).AddDays($DaysDue)
                _verbose -message ($strings.RefilteringTasks -f $DaysDue)
                _verbose -message ($strings.CutOffDate -f $d)
                _verbose -message ($strings.FilterItemsDue -f $d)
                <#
                This format doesn't appear to respect culture
                $tasks = ($tasks).Where({ [DateTime]$_.duedate -le $d })
                #>
                $tasks = $tasks | Where-Object { ($_.duedate -as [DateTime]) -le $d }
                _verbose -message ($strings.Refiltering -f $tasks.count)
            }
            $i = 0
            foreach ($task in $tasks) {
                Write-Debug "Converting id $($task.id)"
                $nwi = _newWorkItem $task -path $path
                Write-Debug "Adding $($nwi.name) to the result list"
                $results.Add($nwi)
                $i++
            } #foreach
            Write-Debug "processed $i tasks"
            _verbose -message ($strings.Sorting -f $results.count)
            $results | Sort-Object -Property DueDate
        }
        else {
            Write-Warning $strings.WarnNoTasksFound
        }
    } #process

    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending
    } #end
}
