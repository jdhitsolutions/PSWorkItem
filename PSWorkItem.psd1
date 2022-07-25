#
# Module manifest for module 'PSWorkItem'
#

@{
    RootModule             = 'PSWorkItem.psm1'
    ModuleVersion          = '0.2.0'
    CompatiblePSEditions   = 'Core'
    GUID                   = '4d3ff215-69ea-4fe6-8ad6-97ffc3a15bfb'
    Author                 = 'Jeff Hicks'
    CompanyName            = 'JDH Information Technology Solutions, Inc.'
    Copyright              = '(c) JDH Information Technology Solutions, Inc. All rights reserved.'
    Description            = 'A PowerShell 7 module for managing work and personal tasks or to-do items. This module uses a SQLite database to store task and category information. The module is not a full-featured project management solution, but should be find for personal needs. The module requires a 64-bit Windows platform.'
    PowerShellVersion      = '7.2'
    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    DotNetFrameworkVersion = '4.6'
    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture  = 'Amd64'
    RequiredModules        = @("mySQLite")
    # TypesToProcess = @()
    # FormatsToProcess = @()
    FunctionsToExport      = 'Get-PSWorkItem','Set-PSWorkItem','Remove-PSWorkItem',
    'Initialize-PSWorkItemDatabase','Complete-PSWorkItem','Get-PSWorkitemCategory',
    'Add-PSWorkitemCategory','Get-PSWorkItemArchive','New-PSWorkItem','Remove-PSWorkItemCategory'
    CmdletsToExport        = ''
    VariablesToExport      = 'PSWorkItemPath'
    AliasesToExport        = ''
    PrivateData            = @{
        PSData = @{
             Tags = @('database','sqlite','to-do','project-management','tasks')
            # LicenseUri = ''
            # ProjectUri = ''
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            ExternalModuleDependencies = @("mySQLite")

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfoURI = ''
    # DefaultCommandPrefix = ''

}

