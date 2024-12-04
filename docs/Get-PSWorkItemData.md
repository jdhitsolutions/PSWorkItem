---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3LiiFn4
schema: 2.0.0
---

# Get-PSWorkItemData

## SYNOPSIS

Get raw database table data.

## SYNTAX

```yaml
Get-PSWorkItemData [[-Table] <String>] [-Path <String>] [<CommonParameters>]
```

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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PSWorkItemPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -Table

Specify the table name.
The default is Tasks

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Tasks, Categories, Archive

Required: False
Position: 0
Default value: Tasks
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Data.DataTable

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSWorkItemDatabase](Get-PSWorkItemDatase.md)

[Invoke-MySQLiteQuery](https://bit.ly/3B6YcOW)
