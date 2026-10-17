---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/4a956a
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Complete-PSWorkItem

## SYNOPSIS

Mark a PSWorkItem as complete.

## SYNTAX

### Default (Default)

```yaml
Complete-PSWorkItem [-ID] <Int32> [-Path <String>] [-CompletionDate <DateTime>] [-PassThru]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- `cwi`

## DESCRIPTION

When you are ready to mark a task as complete, use this command. Complete-PSWorkItem will set the progress to 100, mark the item as completed, copy it to the Archive table, and delete it from the tasks table. There are no commands to modify the task after it has been marked as completed so if you need to update the category, name, or description, do so before completing it.

## EXAMPLES

### Example 1

```powershell
PS C:\> Complete-PSWorkItem -id 9 -PassThru

    Database: C:\Users\Jeff\PSWorkItem.db
ID Name           Description Category Completed
-- ----           ----------- -------- ---------
6  Clean database             Other    7/30/2025 10:40:48 AM
```

Mark a PSWorkItem as completed and move it to the Archive table. The PSWorkItem will most likely get a new ID. The item will be deleted from the Tasks table.

### Example 2

```powershell
PS C:\> Get-PSWorkItem -category Alpha | Complete-WorkItem
```

Complete all work items from the Alpha category.

## PARAMETERS

### -CompletionDate

Specify the completion date. The default is now.

```yaml
Type: DateTime
DefaultValue: None
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

### -ID

The PSWorkItem ID. The task will get a new ID in the Archive table.

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

### -PassThru

```yaml
Type: SwitchParameter
DefaultValue: None
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

### PSWorkItemArchive

## NOTES

This command has an alias of cwi.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)
- [Remove-PSWorkItem](Remove-PSWorkItem.md)
- [Set-PSWorkItem](Set-PSWorkItem.md)
