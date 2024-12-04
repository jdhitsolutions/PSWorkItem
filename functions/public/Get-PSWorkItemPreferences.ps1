Function Get-PSWorkItemPreference {
    [cmdletbinding()]
    [OutputType('psWorkItemPreference')]
    Param()

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
        $PrefPath = Join-Path -Path $HOME -ChildPath .psworkitempref.json
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        if (Test-Path -Path $PrefPath) {
            _verbose -message ($strings.GetPreferences -f $PrefPath)
            $pref = Get-Content -Path $PrefPath | ConvertFrom-Json
            foreach ($cat in $pref.Categories) {
                _verbose -Message $cat.Category
                [PSCustomObject]@{
                    PSTypeName = 'psWorkItemPreference'
                    Path       = $pref.Path
                    Category   = $cat.Category
                    ANSI       = $cat.ANSI
                    ANSIString = $cat.ANSI -replace "`e", "``e"
                }
            } #foreach $cat
        }
        else {
            Write-Warning ($strings.NoPreferenceFile -f $prefPath)
        }
    } #process

    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end

} #close Get-PSWorkItemPreference