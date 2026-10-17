---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/bc9c68
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Get-PSWorkItemArchive

## SYNOPSIS

Get archived PSWorkItems.

## SYNTAX

### name (Default)

```yaml
Get-PSWorkItemArchive [[-Name] <String>] [-Path <String>] [<CommonParameters>]
```

### id

```yaml
Get-PSWorkItemArchive [-ID <String>] [-Path <String>] [<CommonParameters>]
```

### category

```yaml
Get-PSWorkItemArchive [-Category <String>] [-Path <String>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

Completed PSWorkItems are moved to the Archive table. Use this command to view completed items.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItemArchive

    Database: C:\Users\Jeff\PSWorkItem.db

ID Name               Description                          Category Completed
-- ----               -----------                          -------- ---------
1  upgrade prep                                            Temp     7/29/2023 10:35:42 AM
2  Order dog food                                          Personal 7/30/2023 10:09:09 AM
3  Update-PSScripting update scripting and toolmaking book Project  7/30/2023 10:13:45 AM
4  car inspection                                          Personal 7/30/2023 10:35:03 AM
6  Clean database                                          Other    7/30/2023 10:40:48 AM
5  weekly report                                           work     8/1/2023 8:30:00 AM
```

Get all archived PSWorkItems.

### Example 2

```powershell
PS C:\> Get-PSWorkItemArchive -Category Personal

    Database: C:\Users\Jeff\PSWorkItem.db

ID Name           Description Category Completed
-- ----           ----------- -------- ---------
2  Order dog food             Personal 7/30/2023 10:09:09 AM
4  car inspection             Personal 7/30/2023 10:35:03 AM
```

Get archived PSWorkItems by category.

## PARAMETERS

### -Category

Get all open PSWorkItems by category. There should be tab completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: category
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

The task ID. This value will most likely be different than the original ID.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: id
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

The name of the work item.
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSWorkItemArchive

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Complete-PSWorkItem](Complete-PSWorkItem.md)
- [Get-PSWorkItem](Get-PSWorkItem.md)
