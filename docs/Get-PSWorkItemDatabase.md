---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3P0DHXH
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

   Path: C:\Users\Jeff\PSWorkItem.db [32KB]

Created              LastModified          Tasks Archived Categories
-------              ------------          ----- -------- ----------
7/29/2023 9:59:59 AM 7/30/2023 11:20:17 AM     6        6          5
```

The default summary.

### Example 2

```powershell
PS C:\> Get-PSWorkItemDatabase | Format-List

Path          : C:\Users\Jeff\PSWorkItem.db
Created       : 7/29/2023 9:59:59 AM
LastModified  : 7/30/2023 11:20:17 AM
Size          : 32768
TaskCount     : 6
CategoryCount : 5
ArchiveCount  : 6
Encoding      : UTF-8
PageCount     : 8
PageSize      : 4096
```

There are additional properties.

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

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSWorkItem](Get-PSWorkItem.md)

[Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)

[Get-PSWorkItemCategory](Get-PSWorkItemCategory.md)

[Initialize-PSWorkItemDatabase](Initialize-PSWorkItemDatabase.md)

[Get-PSWorkItemData](Get-PSWorkItemData.md)
