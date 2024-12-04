---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version:
schema: 2.0.0
---

# Open-PSWorkItemHelp

## SYNOPSIS

Open the PSWorkItem help document

## SYNTAX

```yaml
Open-PSWorkItemHelp [-AsMarkdown] [<CommonParameters>]
```

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
Parameter Sets: (All)
Aliases: md

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

### System.String

## NOTES

## RELATED LINKS

[PSWorkItem GitHub Repository:](https://github.com/jdhitsolutions/PSWorkItem)
