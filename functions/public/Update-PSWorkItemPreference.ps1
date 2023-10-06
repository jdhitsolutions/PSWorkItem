Function Update-PSWorkItemPreference {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('System.IO.FileInfo','None')]
    Param(
        [Parameter(HelpMessage = "Specify the default category for new PSWorkItems")]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({
            (Get-PSWorkItemData -Table Categories -Path $global:PSWorkItemPath).Category |
            ForEach-Object { [CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) } |
            Select-Object -Unique | Sort-Object
        })]
        [ValidateScript(
            { (Get-PSWorkItemData -Table Categories -Path $global:PSWorkItemPath).Category -Contains $_ },
            ErrorMessage = "You entered an invalid category."
        )]
        [string]$DefaultCategory,

        [Parameter(
            HelpMessage = "Update PSWorkitem user preferences settings file."
        )]
        [ValidateNotNullOrEmpty()]
        [Switch]$Passthru
    )

    Begin {
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
        $FilePath = Join-Path -Path $HOME -ChildPath ".psworkitempref.json"
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        _verbose -message $strings.UpdatePreference
        #export global variables
        $pref = [PSCustomObject]@{
            Path = $global:PSWorkItemPath
            DefaultDays = $global:PSWorkItemDefaultDays
            DefaultCategory = $DefaultCategory
            Categories = $global:PSWorkItemCategory.GetEnumerator() |
            ForEach-Object { @{Category = $_.Key;ANSI = $_.value}}
        }
        _verbose -message ($strings.SavingPreference -f $FilePath)
        _verbose -message "$($pref | Select-Object Path,DefaultDays,DefaultCategory | Out-String)`nCategories:`n$($pref.Categories.Category | Out-String)"
        Try {
            $pref | ConvertTo-Json | Out-File -FilePath $FilePath -ErrorAction Stop
        }
        Catch {
            Throw $_
        }

        if ($Passthru -AND (Test-Path $FilePath) -AND (-Not $WhatIfPreference)) {
            Get-Item -path $FilePath
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending
    } #end

} #close Update-PSWorkItemPreference