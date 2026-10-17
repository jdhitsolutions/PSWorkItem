---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/b784f7
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# New-PSWorkItem

## SYNOPSIS

Create a new PSWorkItem.

## SYNTAX

### date (Default)

```yaml
New-PSWorkItem [-Name] <String> [[-Description] <String>] [[-Category] <String>]
 [-DueDate <DateTime>] [-Path <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### days

```yaml
New-PSWorkItem [-Name] <String> [[-Description] <String>] [[-Category] <String>] [-DaysDue <Int32>]
 [-Path <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- `nwi`

## DESCRIPTION

Use this command to add a new PSWorkItem to the database. It is assumed you have already defined your task categories. The default is to create a new PSWorkItem with a due date 30 days from now. You can specify any due date or the number of days from now.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PSWorkItem -Name "Blog updates" -Description "update pages" -DueDate "7/15/2026 5:00PM" -Category Blog -PassThru
```

Create a new PSWorkItem with a due date 30 days from now. You should be able to use tab completion for the Category parameter.

### Example 2

```powershell
PS C:\> New-PSWorkItem -Name "Publish PSWorkItem" -DaysDue 3 -Category Project
```

Create a new PSWorkItem due in 3 days.

### Example 3

```powershell
PS C:\> New-PSWorkItem -Name "Job Interview Prep" -Category Hidden
```

Create a hidden work item.

## PARAMETERS

### -Category

Select a valid category. The category must be pre-defined. There should be tab completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

If you would like to set a default category you can manually add an entry to $PSDefaultParameterValues. Or use Update-PSWorkItemPreference with a default category and re-import the module into your PowerShell session.

Beginning with module version 1.13.0 you can set the category to Hidden. This will have the effect of hiding the PSWorkItem from the default Get-PSWorkItem output.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DaysDue

Specify the number of days before the task is due to be completed. Enter a value between 1 and 365.

```yaml
Type: Int32
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: days
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Add a comment or task description. Do not include apostrophes.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases:
- comment
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DueDate

When is this task due?
The default is the value of adding the number of days in $PSWorkItemDefaultDays to the current date. The module default is 30 days.

```yaml
Type: DateTime
DefaultValue: $PSWorkItemDefaultDays from now
SupportsWildcards: false
Aliases:
- Date
ParameterSets:
- Name: date
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the work item. Do not include apostrophes.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases:
- task
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
It should end in .db.

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

### System.String

## OUTPUTS

### None

### PSWorkItem

## NOTES

This command has an alias of nwi.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Get-PSWorkItem](Get-PSWorkItem.md)
- [Set-PSWorkItem](Set-PSWorkItem.md)
- [Complete-PSWorkItem](Complete-PSWorkItem.md)
- [Remove-PSWorkItem](Remove-PSWorkItem.md)
- [Open-PSWorkItemConsole](Open-PSWorkItemConsole.md)
