---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/f446f5
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Update-PSWorkItemPreference

## SYNOPSIS

Update or create a preference file

## SYNTAX

### Default (Default)

```yaml
Update-PSWorkItemPreference [-DefaultCategory <String>] [-Passthru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- none

## DESCRIPTION

Use this command to export your preferences for the PSWorkitem module to a JSON file. This file, .psworkitempref.json, will be used when importing the module to set the database path and customized highlighting sequences for $PSWorkItemCategory. The file will be stored in $HOME.

If you define a default category and later want to remove it, you can re-run this command without specifying a category. It is recommended that you restart PowerShell and re-import the module to reset PSDefaultParameterValues.

You may need to manually delete the preferences JSON file if you uninstall the module.

## EXAMPLES

### Example 1

```powershell
PS C:\> Update-PSWorkItemPreference
```

This assumes you've customized category settings or the database path.

### Example 2

```powershell
PS C:\> Update-PSWorkItemPreference -DefaultCategory Work
```

## PARAMETERS

### -DefaultCategory

Specify the default category for new PSWorkItems. This must be a valid category in the PSWorkItems database.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

### -Passthru

Show the completed file.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases:
- wi
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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases:
- cf
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

### System.IO.FileInfo

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Get-PSWorkItemCategory](Get-PSWorkitemCategory.md)
- [Get-PSWorkItemPreference](Get-PSWorkItemPreference.md)
