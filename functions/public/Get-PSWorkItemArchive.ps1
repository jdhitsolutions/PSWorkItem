Function Get-PSWorkItemArchive {
    [cmdletbinding(DefaultParameterSetName = 'name')]
    [OutputType('PSWorkItemArchive')]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = 'The name of the work item. Wildcards are supported.',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'name'
        )]
        [ValidateNotNullOrEmpty()]
        [alias('task')]
        [String]$Name = '*',

        [Parameter(
            HelpMessage = 'The task ID.',
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'id'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID,

        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            {Test-Path $_},
            ErrorMessage = "Could not validate the database path."
        )]
        [String]$Path = $PSWorkItemPath
    )
    DynamicParam {
        # Added 26 Sept 2023 to support dynamic categories based on path
        if (-Not $PSBoundParameters.ContainsKey("Path")) {
            $Path = $global:PSWorkItemPath
        }
        If (Test-Path $Path) {

        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        # Defining parameter attributes
        $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.ParameterSetName = 'Category'
        $attributes.HelpMessage = 'Get all archived PSWorkItems by category'

        # Adding ValidateSet parameter validation
        #only get categories used in the Archive table
        #It is possible categories might be entered in different cases in the database
        [string[]]$values = (Get-PSWorkItemData -Table Archive -Path $Path).Category |
        Foreach-Object { [CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_)} |
        Select-Object -unique | Sort-Object
        $v = New-Object System.Management.Automation.ValidateSetAttribute($values)
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
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
        _verbose -message ($strings.UsingDB -f $path)
    } #begin

    Process {
        $Category = $PSBoundParameters["Category"]
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        #test if archive table has been updated to include the OriginalTaskID column
        $test = Invoke-MySQLiteQuery -Path $path -query "pragma table_info('archive')" | Where-Object name -eq 'id'
        if (-Not $test) {
            Write-Warning $strings.CannotVerifyIDColumn
            Return
        }
        Switch ($PSCmdlet.ParameterSetName) {
            'category' { $query = "Select * from archive where category ='$Category' collate nocase" }

            'id' { $query = "Select * from archive where ID ='$ID'" }
            'name' {
                if ($Name -match '\*') {
                    $Name = $name.replace('*', '%')
                    $query = "Select * from archive where name like '$Name' collate nocase"
                }
                else {
                    $query = "Select * from archive where name = '$Name' collate nocase"
                }
            }
        }

        _verbose -message $query
        $tasks = Invoke-MySQLiteQuery -Query $query -Path $Path
        if ($tasks.count -gt 0) {
            _verbose -message ($strings.FoundMatching -f $tasks.count)
            $results = foreach ($task in $tasks) {
                $task | Out-String | Write-Debug
                #March 10, 2023 PSWorkItemArchive is now a defined class
                _newWorkItemArchive $task -path $path
                #insert a new typename
                #$t.PSObject.TypeNames.insert(0, 'PSWorkItemArchive')
                #$t
            }
            $results | Sort-Object -Property TaskModified
        }
        else {
            Write-Warning $strings.FailedToFindArchivedTasks
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending
    } #end

}