---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/78f3a1
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Remove-PSWorkItemArchive

## SYNOPSIS

Remove archive PSWorkItems

## SYNTAX

### id (Default)

```yaml
Remove-PSWorkItemArchive [-ID] <Int32> [-Path <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### category

```yaml
Remove-PSWorkItemArchive [-Category] <String> [-Path <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### name

```yaml
Remove-PSWorkItemArchive [[-Name] <String>] [-Path <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- `rwi`

## DESCRIPTION

Completed work items are moved to the Archive table in the PSWorkItem database. At some point, you may wish to clear out old archived PSWorkItems. There is no technical reason you would need to do this, but if you want to, use Remove-PSWorkItemArchive. You can remove archived PSWorkItems by ID, category, or name.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-PSWorkItem -id 7 -Verbose
VERBOSE: [12:37:40.2036443 BEGIN  ] Remove-PSWorkItem: Starting
VERBOSE: [12:37:40.2045322 BEGIN  ] Remove-PSWorkItem: PSBoundParameters
VERBOSE:
Key     Value
---     -----
ID          7
Verbose  True


VERBOSE: [12:37:40.2099707 BEGIN  ] Remove-PSWorkItem: Opening a connection to C:\Users\artd\PSWorkItem.db
VERBOSE: [12:37:40.2142745 PROCESS] Remove-PSWorkItem: Removing task 7
VERBOSE: Performing the operation "Remove-PSWorkItem" on target "1a2d1acc-738d-458f-8744-6a6e541a8bc5".
VERBOSE: [12:37:40.2245915 END    ] Remove-PSWorkItem: Closing database connection.
VERBOSE: [12:37:40.2261433 END    ] Remove-PSWorkItem: Ending
```

Delete an archived item by its ID.

### Example 2

```powershell
PS C:\> Remove-PSWorkItemArchive -Category work -WhatIf
What if: Performing the operation "Remove-PSWorkItemArchive" on target "7e87a44f-d0ff-4cbc-ad08-ce3bf834b8e0".
What if: Performing the operation "Remove-PSWorkItemArchive" on target "02290cca-5e59-45f7-a2d9-9f34bf51817e".
What if: Performing the operation "Remove-PSWorkItemArchive" on target "44d12012-915f-481c-9dfc-c31041bb20cc".
What if: Performing the operation "Remove-PSWorkItemArchive" on target "19fea3ee-4a2d-489e-b993-84ce5677ac99".
```

Remove archived items based on a category.

### Example 3

```powershell
PS C:\>  Remove-PSWorkItemArchive -name *report
```

Remove archived items where the name ends in 'report'.

## PARAMETERS

### -Category

A PSWorkItem category. There should be tab completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: category
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ID

The archive work item ID.

```yaml
Type: Int32
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: id
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the archive work item.
Wildcards are supported.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: true
Aliases:
- task
ParameterSets:
- Name: name
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

The path to the PSWorkItem SQLite database file.
It should end in .db

```yaml
Type: String
DefaultValue: $PSWorkItemPath
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Remove-PSWorkItem](Remove-PSWorkItem.md)
- [Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)
