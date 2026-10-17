---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/506c18
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Initialize-PSWorkItemDatabase

## SYNOPSIS

Create a new PSWorkItem database file.

## SYNTAX

### Default (Default)

```yaml
Initialize-PSWorkItemDatabase [[-Path] <String>] [-PassThru] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

Before you can define any PSWorkItems or categories, you need to set up the SQLite database file. By default, the file will be created using the $PSWorkItem path which points to PSWorkItem.db in $HOME. If you want to use a different location, you should change the variable before creating to make it easier to use the commands in this module. Advanced users may want to set up multiple database files in which case, they will need to keep track of paths.

If the file already exists, the command will not complete unless you use the -Force parameter.

The set up will also define the default categories of Work, Personal, Project, and Other.

## EXAMPLES

### Example 1

```powershell
PS C:\> Initialize-PSWorkItemDatabase
```

Create a new database file.

### Example 2

```powershell
PS C:\> Initialize-PSWorkItemDatabase -PassThru

   Database: C:\Users\jeff\PSWorkItem.db Table:Metadata

ColumnIndex ColumnName   ColumnType
----------- ----------   ----------
0           Author       TEXT
1           Created      TEXT
2           Computername TEXT
3           Comment      TEXT

   Database: C:\Users\jeff\PSWorkItem.db Table:tasks

ColumnIndex ColumnName   ColumnType
----------- ----------   ----------
0           taskid       text
1           taskcreated  text
2           taskmodified text
3           name         text
4           description  text
5           duedate      text
6           category     text
7           progress     integer
8           completed    integer

   Database: C:\Users\jeff\PSWorkItem.db Table:archive

ColumnIndex ColumnName   ColumnType
----------- ----------   ----------
0           taskid       text
1           taskcreated  text
2           taskmodified text
3           name         text
4           description  text
5           duedate      text
6           category     text
7           progress     integer
8           completed    integer

   Database: C:\Users\jeff\PSWorkItem.db Table:categories

ColumnIndex ColumnName  ColumnType
----------- ----------  ----------
0           category    text
1           description text
```

The PassThru output shows the new table definitions.

## PARAMETERS

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

### -Force

Force overwriting an existing file.

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
  Position: 0
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Get-PSWorkItemDatabase](Get-PSWorkItemDatabase.md)
- [Add-PSWorkItemCategory](Add-PSWorkItemCategory.md)
- [Remove-PSWorkItemCategory](Remove-PSWorkItemCategory.md)
