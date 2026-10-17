---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/0a919f
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Get-PSWorkItemReport

## SYNOPSIS

Get a summary report of PSWorkItems.

## SYNTAX

### Default (Default)

```yaml
Get-PSWorkItemReport [[-Path] <String>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

Use this simple command to get a report of PSWorkItems by category. The percentages for each category are rounded. The percentage of Overdue items is based on all open work items.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItemReport

   Path: C:\Users\Jeff\PSWorkItem.db

Category Count PctTotal
-------- ----- --------
Personal     5       38
Event        3       23
Project      2       15
Work         1        8
Other        1        8
Blog         1        8
Overdue      4       31
```

The Overdue data should be shown in red.

## PARAMETERS

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
  Position: 0
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

### None

## OUTPUTS

### PSWorkItemReport

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Get-PSWorkItem](Get-PSWorkItem.md)
