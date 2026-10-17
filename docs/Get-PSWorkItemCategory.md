---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/35ca69
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Get-PSWorkItemCategory

## SYNOPSIS

Get defined PSWorkItem categories.

## SYNTAX

### Default (Default)

```yaml
Get-PSWorkItemCategory [[-Category] <String>] [-Path <String>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

When you create a PSWorkItem, you need to tag it with a category. The category must be defined before you can use it. Get-PSWorkItemCategory will display information about your categories.

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
```

Get all defined categories. Categories should be formatted with the corresponding highlight color in the console.

### Example 2

```powershell
PS C:\> Get-PSWorkItemCategory -Name blog

Category Description
-------- -----------
Blog     Blog management or content
```

Get information about a single category. This is a dynamic parameter based on the database path which requires it to be a named parameter.

### Example 3

```powershell
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

Specify the category name. There should be tab completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String[]
DefaultValue: '*'
SupportsWildcards: false
Aliases:
- Name
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

The path to the PSWorkItem SQLite database file.
It should end in .db

```yaml
Type: String
DefaultValue: $PSWorkItemPath
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### PSWorkItemCategory

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Add-PSWorkItemCategory](Add-PSWorkItemCategory.md)
- [Remove-PSWorkItemCategory](Remove-PSWorkItemCategory.md)
- [Update-PSWorkItemPreferences](Update-PSWorkItemPreferences.md)
