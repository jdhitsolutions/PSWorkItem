#
# Module manifest for module 'PSWorkItem'
#

@{
    RootModule             = 'PSWorkItem.psm1'
    ModuleVersion          = '1.0.1'
    CompatiblePSEditions   = 'Core'
    GUID                   = '4d3ff215-69ea-4fe6-8ad6-97ffc3a15bfb'
    Author                 = 'Jeff Hicks'
    CompanyName            = 'JDH Information Technology Solutions, Inc.'
    Copyright              = '(c) JDH Information Technology Solutions, Inc. All rights reserved.'
    Description            = 'A PowerShell 7 module for managing work and personal tasks or to-do items. This module uses a SQLite database to store task and category information. The module is not a full-featured project management solution, but should be fine for personal needs. The module requires a 64-bit Windows platform.'
    PowerShellVersion      = '7.2'
    DotNetFrameworkVersion = '4.6'
    ProcessorArchitecture  = 'Amd64'
    RequiredModules        = @(@{ModuleName = "mySQLite"; ModuleVersion = "0.9.2" })
    TypesToProcess = @(
        'types\psworkitem.types.ps1xml',
        'types\psworkitemarchive.types.ps1xml'
    )
    FormatsToProcess       = @(
        'formats\psworkitemdatabase.format.ps1xml',
        'formats\psworkItem.format.ps1xml',
        '.\formats\psworkitemreport.format.ps1xml'
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
        'Update-PSWorkItemDatabase'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @('gwi', 'nwi', 'swi', 'rwi', 'cwi')
    PrivateData            = @{
        PSData = @{
            Tags                       = @('database', 'sqlite', 'to-do', 'project-management', 'tasks')
            LicenseUri                 = 'https://github.com/jdhitsolutions/PSWorkItem/blob/main/License.txt'
            ProjectUri                 = 'https://github.com/jdhitsolutions/PSWorkItem'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            ExternalModuleDependencies = "MySQLite"
        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfoURI = ''
    # DefaultCommandPrefix = ''

}

