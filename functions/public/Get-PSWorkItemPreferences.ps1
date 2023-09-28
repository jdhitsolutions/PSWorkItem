Function Get-PSWorkItemPreference {
    [cmdletbinding()]
    [OutputType('psWorkItemPreference')]
    Param()

    Begin {
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
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
    } #end

} #close Get-PSWorkItemPreference