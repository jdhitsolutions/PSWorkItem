---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/782c6a
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Get-PSWorkItemPreference

## SYNOPSIS

Get saved PSWorkItem preferences

## SYNTAX

### Default (Default)

```yaml
Get-PSWorkItemPreference [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

You can use Update-PSWorkItemPreference to export the $PSWorkitemCategory and your default database to a settings file in $HOME. Use Get-PSWorkItemPreference to view the file.

## EXAMPLES

### Example 1

```powershell
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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### psWorkItemPreference

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Update-PSWorkItemPreference](Update-PSWorkItemPreference.md)
