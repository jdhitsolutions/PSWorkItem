Function Set-PSWorkItemCategory {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None', 'PSWorkItemCategory')]
    Param(
        [Parameter(
            HelpMessage = 'Specify a category comment or description.'
        )]
        [String]$Description,

        [Parameter(HelpMessage = 'Specify a new name for the category. This is case-sensitive. Be careful renaming a category with active tasks using the old category name.')]
        [ValidateNotNullOrEmpty()]
        [string]$NewName,

        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            {Test-Path $_},
            ErrorMessage = "Could not validate the database path."
        )]
        [String]$Path = $PSWorkItemPath,

        [switch]$PassThru
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
            $attributes.Position = 0
            $attributes.Mandatory = $True
            $attributes.HelpMessage = 'Specify a case-sensitive category name'

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
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
        if ((-Not $PSBoundParameters.ContainsKey('Description')) -AND (-Not $PSBoundParameters.ContainsKey('NewName'))) {
            Write-Warning $strings.WarnDescriptionOrName
            Return
        }
        Write-Debug 'Using bound parameters'
        $PSBoundParameters | Out-String | Write-Debug

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
            Connection  = $conn
            KeepAlive   = $true
            Query       = ''
            ErrorAction = 'Stop'
        }

        $BaseQuery = 'Update categories set '
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        $Category = $PSBoundParameters['Category']
        _verbose -message ($strings.ProcessCategory -f $Category)
        if ($conn.state -eq 'open') {
            _verbose -message ($strings.ValidateCategory -f $category)
            $splat.query = "SELECT * FROM categories WHERE category = '$Category' collate nocase"
            Try {
                $cat = Invoke-MySQLiteQuery @splat
            }
            Catch {
                Write-Warning ($strings.FailedQuery -f $splat.query)
                Close-MySQLiteDB -Connection $conn
                Throw $_
            }
            if ($cat.category -eq $Category) {
                #update the category
                # -Query "Update categories set description = 'work stuff',category='newname' Where category='work' collate nocase"
                $updates = @{
                    Description = $Description
                    Category    = $NewName
                }
                $updates.GetEnumerator() | Where-Object { $_.value } | ForEach-Object -Begin { $set = @() } -Process {
                    $set += "$($_.key) = '$($_.value)'" }-End { $BaseQuery += ($set -join ', ')
                }

                $BaseQuery += " WHERE category = '$category' collate nocase"
                $splat.query = $BaseQuery
                if ($PSCmdlet.ShouldProcess($BaseQuery)) {
                    Invoke-MySQLiteQuery @splat
                    if ($PassThru) {
                        if ($NewName) {
                            Get-PSWorkItemCategory -Category $NewName -Path $Path
                        }
                        else {
                            Get-PSWorkItemCategory -Category $Category -Path $Path
                        }
                    }
                }
            } #If category found
        } #IF connection open
        else {
            Write-Warning "$($MyInvocation.MyCommand): $($strings.DatabaseConnectionNotOpen)"
        }

    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        if ($conn.state -eq 'open') {
            _verbose -message ($strings.CloseDBConnection)
            Close-MySQLiteDB -Connection $conn
        }
        _verbose -message $strings.Ending
        _verbose -message ($strings.RunTime -f (StopTimer))

    } #end

} #close Set-PSWorkItemCategory