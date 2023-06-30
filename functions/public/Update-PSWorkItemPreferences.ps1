Function Update-PSWorkItemPreferences {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('System.IO.FileInfo','None')]
    Param(
        [Parameter(
            HelpMessage = "Update PSWorkitem user preferences settings file."
        )]
        [ValidateNotNullOrEmpty()]
        [Switch]$Passthru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        $FilePath = Join-Path -Path $HOME -ChildPath ".psworkitempref.json"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating PSWorkItem user preferences"
        $pref = [PSCustomObject]@{
            Path = $PSWorkItemPath
            Categories = $PSWorkItemCategory.GetEnumerator() |
            ForEach-Object { @{Category = $_.Key;ANSI = $_.value}}
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Saving preferences to $FilePath"
        Try {
            $pref | ConvertTo-Json | Out-File -FilePath $FilePath -ErrorAction Stop
        }
        Catch {
            Throw $_
        }

        if ($PAssthru -AND (Test-Path $FilePath) -AND (-Not $WhatIfPreference)) {
            Get-Item -path $FilePath
        }

    } #process

    End {

        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Update-PSWorkItemPreferences