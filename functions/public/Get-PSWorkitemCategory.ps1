Function Get-PSWorkItemCategory {
    [cmdletbinding()]
    [OutputType('PSWorkItemCategory')]
    Param(
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
            $attributes.ValueFromPipeline = $True
            $attributes.ValueFromPipelineByPropertyName = $True
            $attributes.Position = 0
            $attributes.HelpMessage = 'Removed archived PSWorkItems by the selected category'

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

            # Adding a parameter alias
            $dynAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList 'Name'
            $attributeCollection.Add($dynAlias)

            # Defining the runtime parameter
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('Category', [String], $attributeCollection)
            $dynParam1.Value = '*'
            $paramDictionary.Add('Category', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam
    Begin {
        StartTimer
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
        _verbose -message ($strings.UsingDB -f $path)
        Write-Debug 'Using bound parameters'
        $PSBoundParameters | Out-String | Write-Debug

        $splat = @{
            Query = ''
            Path  = $Path
            As    = 'Object'
        }
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        If ($PSBoundParameters.ContainsKey('Category')) {
            $Category = $PSBoundParameters['Category']
        }
        else {
            $Category = '*'
        }
        if ($Category -eq '*') {
            _verbose -message $strings.GetAllCategories
            $splat.Query = 'SELECT * FROM categories'
            $data = Invoke-MySQLiteQuery @splat
        }
        else {
            Foreach ($item in $Category) {
                _verbose -message ($strings.GetCategory -f $item)
                #make a case-insensitive query
                $splat.Query = "SELECT * FROM categories WHERE category = '$item' collate nocase"
                $data = Invoke-MySQLiteQuery @splat
            }
        }
        _verbose -message ($strings.FoundCategories -f $data.count)
        foreach ($cat in $data) {
            _verbose -message ($strings.CreateCategory -f $cat.category)
            [PSWorkItemCategory]::New($cat.category, $cat.description)
        }
    } #process

    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end
}
