---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3PIdz4O
schema: 2.0.0
---

# Initialize-PSWorkItemDatabase

## SYNOPSIS

Create a new PSWorkItem database file.

## SYNTAX

```yaml
Initialize-PSWorkItemDatabase [[-Path] <String>] [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

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
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Force overwriting an existing file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The path to the PSWorkItem SQLite database file.
It should end in .db

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: $PSWorkItemPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the command runs.
The command is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This command supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSWorkItemDatabase](Get-PSWorkItemDatabase.md)

[Add-PSWorkItemCategory](Add-PSWorkItemCategory.md)

[Remove-PSWorkItemCategory](Remove-PSWorkItemCategory.md)
