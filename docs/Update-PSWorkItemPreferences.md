---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3KbxxUX
schema: 2.0.0
---

# Update-PSWorkItemPreferences

## SYNOPSIS

Update or create a preference file

## SYNTAX

```yaml
Update-PSWorkItemPreferences [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to export your preferences for the PSWorkitem module to file. This file will be used when importing the module to set the database path and customized highlighting sequences for $PSWorkItemCategory. The file will be stored in $HOME.

## EXAMPLES

### Example 1

```powershell
PS C:\> Update-PSWorkItemPreferences
```

This assumes you've customized category settings or the database path.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.IO.FileInfo

### None

## NOTES

## RELATED LINKS

[Get-PSWorkItemCategory](Get-PSWorkitemCategory.md)
