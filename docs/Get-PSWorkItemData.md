---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/a52cea
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Get-PSWorkItemData

## SYNOPSIS

Get raw database table data.

## SYNTAX

### Default (Default)

```yaml
Get-PSWorkItemData [[-Table] <String>] [-Path <String>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

Most of the time you will use commands like Get-PSWorkItem to get data from the PSWorkItem database. Get-PSWorkItemData can be used to query the database directly and skip creating custom objects. This could be a helpful command for troubleshooting or debugging.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItemData | Out-GridView
```

Get all data from the Tasks table and display using Out-GridView.

### Example 2

```powershell
PS C:\> Get-PSWorkItemData Categories

category    description                          rowid
--------    -----------                          -----
Work                                                 6
Customer                                             7
Other       Miscellaneous catch-all                  8
Personal                                             9
Project     Module or assigned work                 10
Event       Conference, webinar, or other event     12
```

Get all data from the Categories table.

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
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Table

Specify the table name.
The default is Tasks

```yaml
Type: String
DefaultValue: Tasks
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
AcceptedValues:
- Tasks
- Categories
- Archive
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

### System.Data.DataTable

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Get-PSWorkItemDatabase](Get-PSWorkItemDatase.md)
- [Invoke-MySQLiteQuery]()
