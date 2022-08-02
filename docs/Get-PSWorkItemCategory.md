---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3JlrafZ
schema: 2.0.0
---

# Get-PSWorkItemCategory

## SYNOPSIS

Get defined PSWorkitem categories.

## SYNTAX

```yaml
Get-PSWorkItemCategory [[-Category] <String[]>] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION

When you create a PSWorkItem, you need to tag it with a category. The category must be defined before you can use it. Get-PSWorkItem category will display information about your categories.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItemCategory

Category    Description
--------    -----------
Work        Anything client-oriented
Customer    Anything client-oriented
Other       Miscellaneous catch-all
Personal    Personal or family tasks
Project     Module or assigned work
Business    Corporate-related tasks
Event       Conference, webinar, or other event
Testing     Sample category for testing
Training    Anything related to a training event
Blog        Blog management or content
```

Get all defined categories.

### Example 2

```powershell
PS C:\> Get-PSWorkItemCategory blog

Category Description
-------- -----------
Blog     Blog management or content
```

Get information about a single category.

## PARAMETERS

### -Category

Specify the category name.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### System.String[]

## OUTPUTS

### PSWorkItemCategory

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Add-PSWorkItemCategory](Add-PSWorkItemCategory.md)

[Remove-PSWorkItemCategory](Remove-PSWorkItemCategory.md)
