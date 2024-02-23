---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3LEQb8s
schema: 2.0.0
---

# Get-PSWorkItemPreference

## SYNOPSIS

Get saved PSWorkItem preferences

## SYNTAX

```yaml
Get-PSWorkItemPreference [<CommonParameters>]
```

## DESCRIPTION

You can use Update-PSWorkItemPreference to export the $PSWorkitemCategory and your default database to a settings file in $HOME. Use Get-PSWorkItemPreference to view the file.

## EXAMPLES

### Example 1

```shell
PS C:\> Get-PSWorkItemPreference

   Path: C:\Users\Jeff\PSWorkItem.db [Default Days: 7 Default Category: Work]

Category    ANSIString
--------    ----------
Personal    `e[32m
Work        `e[36m
Event       `e[38;5;153m
Training    `e[94m
Project     `e[38;5;215m
Other       `e[38;5;204m
```

The category will be displayed using the ANSI color sequence.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### psWorkItemPreference

## NOTES

## RELATED LINKS

[Update-PSWorkItemPreference](Update-PSWorkItemPreference.md)
