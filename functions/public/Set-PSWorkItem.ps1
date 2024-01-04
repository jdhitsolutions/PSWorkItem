Function Set-PSWorkItem {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    [alias('swi')]
    [OutputType('None', 'PSWorkItem')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'The work item ID.',
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [int]$ID,

        [Parameter(HelpMessage = 'The name of the work item.', ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript(
            { $_ -notMatch "'" },
            ErrorMessage = 'Do not include apostrophes in the name.'
        )]
        [alias('task')]
        [String]$Name,

        [Parameter(HelpMessage = 'Specify an updated description.', ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript(
            { $_ -notMatch "'" },
            ErrorMessage = 'Do not include apostrophes in the description.'
        )]
        [String]$Description,

        [Parameter(HelpMessage = 'Specify an updated due date.', ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [DateTime]$DueDate,

<#         [Parameter(HelpMessage = 'Specify an updated category', ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [String]$Category, #>

        [Parameter(HelpMessage = 'Specify a percentage complete.', ParameterSetName = 'set')]
        [ValidateRange(0, 100)]
        [int]$Progress,

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

        [Switch]$PassThru,

        [Parameter(ParameterSetName = 'clear')]
        [Switch]$ClearDescription
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
        $attributes.HelpMessage = 'Specify an updated category. You can run Get-PSWorkItemCategory to see the list.'
        # Adding ValidateSet parameter validation
        #It is possible categories might be entered in different cases in the database
        [string[]]$values = (Get-PSWorkItemData -Table Categories -Path $Path).Category |
        ForEach-Object { [CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) } |
        Select-Object -Unique | Sort-Object
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
        StartTimer
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)

        Write-Debug "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): PSBoundParameters"
        $PSBoundParameters | Out-String | Write-Debug

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection  = $Null
            KeepAlive   = $true
            Query       = ''
            ErrorAction = 'Stop'
        }
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'

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

        <#
        9/16/2022 Issue #2
        Modify how the query string is built. PowerShell doesn't respect culture
        With variable expansion. JDH
        #>
        $BaseQuery = "UPDATE tasks set taskmodified = '{0}'" -f (Get-Date)
        if ($PSBoundParameters.ContainsKey('Category')) {
            $category = $PSBoundParameters["Category"]
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
        }
        if (($cat.category -eq $Category) -OR (-Not $PSBoundParameters.ContainsKey('Category'))) {
            _verbose -message $strings.SetTask
            if ($PSCmdlet.ParameterSetName -eq 'Set') {
                $updates = @{
                    name        = $name
                    description = $Description
                    duedate     = $DueDate
                    progress    = $Progress
                    category    = $Category
                }
                $updates.GetEnumerator() | Where-Object { $_.value } | ForEach-Object {
                    $BaseQuery += ", $($_.key) = '$($_.value)'"
                }
            }
            else {
                #Update tasks Set Description = '' where ID = '3'"
                $BaseQuery += ",Description = ''"
            }
            $BaseQuery += " WHERE ID = '$ID'"
            $splat.query = $BaseQuery
            _verbose -message $splat.query
            if ($PSCmdlet.ShouldProcess($splat.query, 'Invoke update')) {
                Try {
                    Invoke-MySQLiteQuery @splat
                }
                Catch {
                    Write-Warning ($strings.FailedQuery -f $splat.query)
                    Close-MySQLiteDB -Connection $conn
                    Throw $_
                }

                if ($PassThru) {
                    Write-Debug 'Task object'
                    $task | Select-Object * | Out-String | Write-Debug
                    Write-Debug "TaskID = $($task.taskid)"
                    $splat.query = "Select * from tasks where ID = '$ID'"
                    Write-Debug "Query = $($splat.query)"
                    _verbose -message $splat.query
                    $data = Invoke-MySQLiteQuery @splat
                    $data | Out-String | Write-Debug
                    _newWorkItem $data -path $Path
                }
            }
        }
        else {
            Write-Warning $strings.InvalidCategory
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
