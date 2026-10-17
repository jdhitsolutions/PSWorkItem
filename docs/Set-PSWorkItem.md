---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/b1aaf4
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Set-PSWorkItem

## SYNOPSIS

Modify an existing PSWorkItem

## SYNTAX

### set (Default)

```yaml
Set-PSWorkItem [-ID] <Int32> [-Name <String>] [-Description <String>] [-DueDate <DateTime>]
 [-Category <String>] [-Progress <Int32>] [-Path <String>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### clear

```yaml
Set-PSWorkItem [-ID] <Int32> [-Path <String>] [-PassThru] [-ClearDescription] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- `swi`

## DESCRIPTION

When you need to update a task, use Set-PSWorkItem. You need to use the PSWorkItem ID to identify the item to be updated. You can then update the Name, Description, DueDate, Category, and Progress.

If you want to clear the Description, use the -ClearDescription parameter. All other properties will remain untouched.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-PSWorkItem -id 3 -progress 10
```

Set the progress on a PSWorkItem.

### Example 2

```powershell
PS C:\> Get-PSWorkItem -Category blog | Set-PSWorkItem -Category Other -PassThru

    Database: C:\Users\Jeff\PSWorkItem.db

ID Name              Description         DueDate             Category Pct
-- ----              -----------         -------             -------- ---
 9 Clean database                        8/2/2025 9:34:35 AM Other      0
 5 revise blog pages essentials and tips 8/7/2025 5:00:00 PM Other      0
```

Modify multiple PSWorkItems at the same time.

### Example 3

```powershell
PS C:\ Set-PSWorkItem -id 5 -ClearDescription
```

Clear the description property for the PSWorkItem with the ID of 5.

## PARAMETERS

### -Category

Specify an updated category. The category must be pre-defined. There should be tab completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: set
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ClearDescription

Clear the description field. All other fields will remain untouched.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: clear
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Specify an updated description. Do not include apostrophes.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: set
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DueDate

Specify an updated due date.

```yaml
Type: DateTime
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: set
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

The work item ID. This is how you identify the PSWorkItem you want to update.

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

### -Name

The updated name of the PSWorkItem. Do not include apostrophes.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases:
- task
ParameterSets:
- Name: set
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
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

### -Progress

Specify a percentage complete.

```yaml
Type: Int32
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: set
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

### System.Int32

## OUTPUTS

### None

### PSWorkItem

## NOTES

This command has an alias of swi.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Complete-PSWorkItem](Complete-PSWorkItem.md)
- [Get-PSWorkItem](Get-PSWorkItem.md)
- [Remove-PSWorkItem](Remove-PSWorkItem.md)
- [New-PSWorkItem](New-PSWorkItem.md)
