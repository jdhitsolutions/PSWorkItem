---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3cT3ljn
schema: 2.0.0
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

## DESCRIPTION

Completed PSWorkItems are moved to the Archive table. Using this command to view completed tasks.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItemArchive

    Database: C:\Users\Jeff\PSWorkItem.db

ID Name               Description                          Category Completed
-- ----               -----------                          -------- ---------
1  upgrade prep                                            Temp     7/29/2022 10:35:42 AM
2  Order dog food                                          Personal 7/30/2022 10:09:09 AM
3  Update-PSScripting update scripting and toolmaking book Project  7/30/2022 10:13:45 AM
4  car inspection                                          Personal 7/30/2022 10:35:03 AM
6  Clean database                                          Other    7/30/2022 10:40:48 AM
5  weekly report                                           work     8/1/2022 8:30:00 AM
```

Get all archived PSWorkItems.

### Example 2

```powershell
PS C:\> Get-PSWorkItemArchive -Category Personal

    Database: C:\Users\Jeff\PSWorkItem.db

ID Name           Description Category Completed
-- ----           ----------- -------- ---------
2  Order dog food             Personal 7/30/2022 10:09:09 AM
4  car inspection             Personal 7/30/2022 10:35:03 AM
```

Get archived PSWorkItems by category.

## PARAMETERS

### -Category

Get all open tasks by category. There should be tab-completion for this parameter.

```yaml
Type: String
Parameter Sets: category
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID

The task ID. This value will most likely be different than the original ID.

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

The name of the work item.
Wilcards are supported.

```yaml
Type: String
Parameter Sets: name
Aliases: task

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path

The path to the PSWorkitem SQLite database file.
It should end in .db

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PSWorkItemPath
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This command supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSWorkItemArchive

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Complete-PSWorkItem](Complete-PSWorkItem.md)

[Get-PSWorkItem](Get-PSWorkItem.md)
