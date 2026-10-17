---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/1d4cfe
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Open-PSWorkItemHelp

## SYNOPSIS

Open the PSWorkItem help document

## SYNTAX

### Default (Default)

```yaml
Open-PSWorkItemHelp [-AsMarkdown] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

Use this command to open the PDF help document for the PSWorkItem module with the associated application for PDF files. As an alternative you can view the documentation as a markdown document.

## EXAMPLES

### Example 1

```powershell
PS C:\> Open-PSWorkItemHelp
```

The file should open in the default application for PDF files.

### Example 2

```powershell
PS C:\> Open-PSWorkItemHelp -AsMarkdown | more
```

View the help file a markdown document.

## PARAMETERS

### -AsMarkdown

Open the README help file as a Markdown document.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases:
- md
ParameterSets:
- Name: (All)
  Position: Named
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

### None

## OUTPUTS

### None

### System.String

## NOTES

## RELATED LINKS

- [PSWorkItem GitHub Repository:](https://github.com/jdhitsolutions/PSWorkItem)
