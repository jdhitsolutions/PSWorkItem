---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3KbxxUX
schema: 2.0.0
---

# Update-PSWorkItemPreference

## SYNOPSIS

Update or create a preference file

## SYNTAX

```yaml
Update-PSWorkItemPreference [-DefaultCategory <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

Show the completed file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultCategory

Specify the default category for new PSWorkItems. This must be a valid category in the PSWorkItems database.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### System.IO.FileInfo

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSWorkItemCategory](Get-PSWorkitemCategory.md)

[Get-PSWorkItemPreference](Get-PSWorkItemPreference.md)
