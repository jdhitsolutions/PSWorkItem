---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/2a56e5
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Remove-PSWorkItemCategory

## SYNOPSIS

Remove a PSWorkItem category.

## SYNTAX

### Default (Default)

```yaml
Remove-PSWorkItemCategory [[-Category] <String>] [-Path <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

If you make a mistake entering a category or want to remove one of the default PSWorkItem categories, use Remove-PSWorkItemCategory. If you are specifying an alternate database, specify the path first, then the category parameter, if you want auto-completion.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-PSWorkItemCategory Temp
```

## PARAMETERS

### -Category

Specify the category name. There should be tab completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String[]
DefaultValue: None
SupportsWildcards: false
Aliases:
- Name
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

Shows what would happen if the command runs.
The command is not run.

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

Prompts you for confirmation before running the command.

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

### System.String[]

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Add-PSWorkItemCategory](Add-PSWorkItemCategory.md)
- [Get-PSWorkItemCategory](Get-PSWorkItemCategory.md)
- [Set-PSWorkItemCategory](Set-PSWorkItemCategory.md)
