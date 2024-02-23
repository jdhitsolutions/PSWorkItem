---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3ThCJtF
schema: 2.0.0
---

# Update-PSWorkItemDatabase

## SYNOPSIS

Update the PSWorkItem database

## SYNTAX

```yaml
Update-PSWorkItemDatabase [[-Path] <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Version 1.0.0 of the PSWorkItem module introduced a structural change to the database tables. If you are using a database created in an earlier version, you need to run this command before adding, changing, or completing work items. It is recommended that you backup you database file before running this command.

As an alternative, you could export your work items, delete the database file, initialize a new one, and re-import your work items.

During the upgrade, a new table column called ID is added to the Tasks and Archive database tables. In the Tasks table, the ID column for existing entries will be set to the row id, which should be the task number you are used to seeing. In the archive table, existing entries will get an ID value of 0, since it is impossible to know the original ID number. This database change corrects this problem. Going forward, the PSWorkItem ID will remain the same when you complete it and move the item to the Archive table.

## EXAMPLES

### Example 1

```shell
PS C:\> New-PSWorkItem -Name "DOM1 backup" -DaysDue 3 -Category work
WARNING: Cannot verify the tasks table column ID. Please run Update-PSWorkItemDatabase to update the table then try completing the command again. It is recommended that you backup your database before updating the table.
PS C:\>  Update-PSWorkItemDatabase -verbose
VERBOSE: [12:52:31.6590850 BEGIN  ] Starting Update-PSWorkItemDatabase
VERBOSE: [12:52:31.6605213 BEGIN  ] Running under PowerShell version 7.3.2
VERBOSE: [12:52:31.6619354 BEGIN  ] Opening database connection to C:\Users\artd\PSWorkItem.db
VERBOSE: [12:52:31.6652856 PROCESS] Processing C:\Users\artd\PSWorkItem.db
VERBOSE: [12:52:31.6662476 PROCESS] Testing for column ID
VERBOSE: [12:52:31.6717249 PROCESS] Adding the column ID
VERBOSE: Performing the operation "Adding column ID" on target "table archive".
VERBOSE: [12:52:31.6831185 PROCESS] Testing for column ID
VERBOSE: [12:52:31.6861450 PROCESS] Adding the column ID
VERBOSE: Performing the operation "Adding column ID" on target "table tasks".
VERBOSE: [12:52:31.6956355 PROCESS] Updating table values
VERBOSE: [12:52:31.7008825 PROCESS] UPDATE tasks set id = '68' Where taskid='03cae2d7-2c7e-4db9-b486-8abd06e8b9c3'
VERBOSE: [12:52:31.7099177 PROCESS] UPDATE tasks set id = '19' Where taskid='2196617b-b818-415d-b9cc-52b0c649a77e'
VERBOSE: [12:52:31.7170601 PROCESS] UPDATE tasks set id = '21' Where taskid='47580992-3262-4b6d-8ff2-2e7153f162a8'
VERBOSE: [12:52:31.7259486 PROCESS] UPDATE tasks set id = '72' Where taskid='53055f56-34c0-4065-8bef-011c6364b17b'
VERBOSE: [12:52:31.7353692 PROCESS] UPDATE tasks set id = '66' Where taskid='781d5acd-04ce-41da-99b8-afb7c96a81e1'
VERBOSE: [12:52:31.7451607 PROCESS] UPDATE tasks set id = '67' Where taskid='7c338d54-43f0-4608-93c9-69933ded0972'
VERBOSE: [12:52:31.7546639 PROCESS] UPDATE tasks set id = '69' Where taskid='a0aa0f98-eea0-4469-8107-f808c9bbc5a0'
VERBOSE: [12:52:31.7650915 PROCESS] UPDATE tasks set id = '71' Where taskid='bb3f9bb2-efab-4aa9-810d-088b82eeccc4'
VERBOSE: [12:52:31.7728867 PROCESS] UPDATE tasks set id = '70' Where taskid='c913444e-7e08-4baa-800f-23d961852c7e'
VERBOSE: [12:52:31.7809348 END    ] Closing database connection
VERBOSE: [12:52:31.7820780 END    ] Ending Update-PSWorkItemDatabase
PS C:\> New-PSWorkItem -Name "DOM1 backup" -DaysDue 3 -Category work -PassThru

   Database: C:\Users\artd\PSWorkItem.db

ID Name        Description DueDate               Category Pct
-- ----        ----------- -------               -------- ---
73 DOM1 backup             3/14/2023 12:53:43 PM work       0
```

You can't change the database until you run Update-PSWorkItemDatabase.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### none

### MySQLiteTableDetail

## NOTES

## RELATED LINKS

[Get-PSWorkItemDatabase](Get-PSWorkItemDatabase.md)
