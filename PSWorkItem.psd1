#
# Module manifest for module 'PSWorkItem'
#

@{
    RootModule             = 'PSWorkItem.psm1'
    ModuleVersion          = '1.12.0'
    CompatiblePSEditions   = 'Core'
    GUID                   = '4d3ff215-69ea-4fe6-8ad6-97ffc3a15bfb'
    Author                 = 'Jeff Hicks'
    CompanyName            = 'JDH Information Technology Solutions, Inc.'
    Copyright              = '(c) 2022-2025 JDH Information Technology Solutions, Inc. All rights reserved.'
    Description            = 'A PowerShell 7 module for managing work and personal tasks or to-do items. This module uses a SQLite database to store task and category information. The module is not a full-featured project management solution, but should be fine for personal needs. The module requires a 64-bit Windows or Linux platform.'
    PowerShellVersion      = '7.3'
    DotNetFrameworkVersion = '4.6'
    ProcessorArchitecture  = ''
    RequiredModules        = 'mySQLite'
    TypesToProcess = @(
        'types\psworkitem.types.ps1xml',
        'types\psworkitemarchive.types.ps1xml'
    )
    FormatsToProcess       = @(
        'formats\psworkitemdatabase.format.ps1xml',
        'formats\psworkitem.format.ps1xml',
        'formats\psworkitemreport.format.ps1xml',
        'formats\psworkitemcategory.format.ps1xml',
        'formats\psWorkItemPreference.format.ps1xml'
    )
    FunctionsToExport      = @(
        'Get-PSWorkItem',
        'Set-PSWorkItem',
        'Remove-PSWorkItem',
        'Initialize-PSWorkItemDatabase',
        'Complete-PSWorkItem',
        'Get-PSWorkItemCategory',
        'Add-PSWorkItemCategory',
        'Get-PSWorkItemArchive',
        'New-PSWorkItem',
        'Remove-PSWorkItemCategory',
        'Remove-PSWorkItemArchive',
        'Get-PSWorkItemDatabase',
        'Get-PSWorkItemData',
        'Get-PSWorkItemReport',
        'Get-PSWorkItemPreference',
        'Update-PSWorkItemDatabase',
        'Update-PSWorkItemPreference',
        'Set-PSWorkItemCategory',
        'Open-PSWorkItemConsole',
        'Open-PSWorkItemHelp'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @('gwi', 'nwi', 'swi', 'rwi', 'cwi','wic')
    PrivateData            = @{
        PSData = @{
            Tags           = @('database','sqlite','reminder','to-do','project-management','tasks')
            LicenseUri     = 'https://github.com/jdhitsolutions/PSWorkItem/blob/main/License.txt'
            ProjectUri     = 'https://github.com/jdhitsolutions/PSWorkItem'
            # IconUri = ''
            ReleaseNotes = @"
## [1.12.0] - 2025-06-16

### Changed

- Updated the Terminal.Gui assembly to v1.19.0. The file version will show as 1.0.0.0.
- Update `README.md`.
- Updated links to online help.

### Removed

- Removed processor architecture from the module manifest.
"@
            RequireLicenseAcceptance = $false
            ExternalModuleDependencies = 'mySQLite'
        }
    }
}

