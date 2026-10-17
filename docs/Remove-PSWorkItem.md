---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/123c70
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Remove-PSWorkItem

## SYNOPSIS

Remove a PSWorkItem.

## SYNTAX

### Default (Default)

```yaml
Remove-PSWorkItem [-ID] <Int32> [-Path <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

If you want to delete a PSWorkItem from the database, use Remove-PSWorkItem. You might do this to correct a mistake or to delete a canceled task. To mark a task as complete and retain an archived copy, use Complete-PSWorkItem.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-PSWorkItem -ID 10
```

Remove the PSWorkItem with an ID of 10.

### Example 2

```powershell
PS C:\> Get-PSWorkItem -Category Testing | Remove-PSWorkItem
```

Remove all work items in the Test category.

## PARAMETERS

### -ID

The work item ID.

```yaml
Type: Int32
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
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
  ValueFromPipelineByPropertyName: true
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

### System.Int32

## OUTPUTS

### None

## NOTES

This command should have an alias of rwi.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Complete-PSWorkItem](Complete-PSWorkItem.md)
- [Get-PSWorkItem](Get-PSWorkItem.md)
- [Set-PSWorkItem](Set-PSWorkItem.md)
- [Remove-PSWorkItemArchive](Remove-PSWorkItemArchive.md)
