---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/6e2c1c
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Set-PSWorkItemCategory

## SYNOPSIS

Update an existing PSWorkItem category

## SYNTAX

### Default (Default)

```yaml
Set-PSWorkItemCategory [-Category] <String> [-Description <String>] [-NewName <String>]
 [-Path <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

This command will update an existing PSWorkItem category. The category name is case-sensitive. Use caution when renaming a category that has active tasks using the old category name.

If you want to modify the associated ANSI color, you will need to add or modify an entry in the $PSWorkItemCategory hashtable.

    $PSWorkItemCategory.Add("Event","`e[38;5;225m")

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-PsworkItemCategory -Category work -Description "Uncategorized work activities" -PassThru

Category Description
-------- -----------
Work     Uncategorized work activities
```

## PARAMETERS

### -Category

Specify a case-sensitive category name. There should be tab completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases:
- Name
ParameterSets:
- Name: (All)
  Position: 0sq
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Specify a category comment or description.

```yaml
Type: String
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

### -NewName

Specify a new name for the category. This is case-sensitive. Be careful renaming a category with active tasks using the old category name.

```yaml
Type: String
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

### -PassThru

Write the updated category to the pipeline.

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

The path to the PSWorkItem SQLite database file. It should end in .db

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

Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### PSWorkItemCategory

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Add-PSWorkItemCategory](Add-PSWorkItemCategory.md)
- [Get-PSWorkItemCategory](Get-PSWorkItemCategory.md)
- [Remove-PSWorkItemCategory](Remove-PSWorkItemCategory.md)
- [Get-PSWorkItemPreference](Get-PSWorkItemPreference.md)
- [Update-PSWorkItemPreference](Update-PSWorkItemPreference.md)
