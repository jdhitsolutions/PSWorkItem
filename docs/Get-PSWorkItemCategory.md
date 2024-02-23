---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3JlrafZ
schema: 2.0.0
---

# Get-PSWorkItemCategory

## SYNOPSIS

Get defined PSWorkItem categories.

## SYNTAX

```yaml
Get-PSWorkItemCategory [[-Category] <String>] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION

When you create a PSWorkItem, you need to tag it with a category. The category must be defined before you can use it. Get-PSWorkItemCategory will display information about your categories.

## EXAMPLES

### Example 1

```shell
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
```

Get all defined categories.

### Example 2

```shell
PS C:\> Get-PSWorkItemCategory blog

Category Description
-------- -----------
Blog     Blog management or content
```

Get information about a single category.

### Example 3

```shell
PS C:\> Get-PSWorkItemCategory | Select-Object Category,ANSIString

Category    ANSIString
--------    ----------
Work        `e[36m
Customer
Other       `e[38;5;204m
Personal    `e[32m
Project     `e[38;5;215m
Business
Event       `e[38;5;153m
Testing
Training    `e[94m
```

Display categories with their ANSI escape sequences.

## PARAMETERS

### -Category

Specify the category name. There should be tab-completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: *
Accept pipeline input: True (ByPropertyName, ByValue)
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

[Update-PSWorkItemPreferences](Update-PSWorkItemPreferences.md)
