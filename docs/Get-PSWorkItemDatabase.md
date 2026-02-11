---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://jdhitsolutions.com/yourls/e0ad43
schema: 2.0.0
---

# Get-PSWorkItemDatabase

## SYNOPSIS

Get information about the PSWorkItem database

## SYNTAX

```yaml
Get-PSWorkItemDatabase [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to get a summary of the PSWorkItem database file. You can not modify the database file by modifying any properties of the PSWorkItemDatabase object.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItemDatabase

   Path: C:\Users\Jeff\PSWorkItem.db [76KB]

Created              LastModified          Tasks Archived Categories
-------              ------------          ----- -------- ----------
7/26/2022 9:56:18 AM 11/7/2025 11:53:09 AM    20      192         10
```

The default summary.

### Example 2

```powershell
PS C:\> Get-PSWorkItemDatabase | Format-List

Path          : C:\Users\Jeff\PSWorkItem.db
Created       : 7/26/2022 9:56:18 AM
LastModified  : 11/7/2025 11:53:09 AM
Size          : 77824
TaskCount     : 20
CategoryCount : 10
ArchiveCount  : 192
Encoding      : UTF-8
PageCount     : 19
PageSize      : 4096
SQLiteVersion : 3.42.0
CreatedBy     : THINKX1-JH\Jeff
Modified      : 00:11:54.9521283
```

There are additional properties. The ModifiedAge property is a TimeSpan object that shows how long ago the database was last modified.

## PARAMETERS

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

### CommonParameters

This command supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSWorkItemDatabase

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-PSWorkItem](Get-PSWorkItem.md)

[Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)

[Get-PSWorkItemCategory](Get-PSWorkItemCategory.md)

[Initialize-PSWorkItemDatabase](Initialize-PSWorkItemDatabase.md)

[Get-PSWorkItemData](Get-PSWorkItemData.md)
