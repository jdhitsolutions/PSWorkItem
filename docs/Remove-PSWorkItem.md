---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3PONYY7
schema: 2.0.0
---

# Remove-PSWorkItem

## SYNOPSIS

Remove a PSWorkItem.

## SYNTAX

```yaml
Remove-PSWorkItem [-ID] <Int32> [-Path <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

If you want to delete a PSWorkItem from the database, use Remove-PSWorkItem. You might do this to correct a mistake or to delete a cancelled task. To mark a task as complete and retain an archived copy, use Complete-PSWorkItem.

## EXAMPLES

### Example 1

```shell
PS C:\> Remove-PSWorkItem -ID 10
```

Remove the PSWorkItem with an ID of 10.

### Example 2

```shell
PS C:\> Get-PSWorkItem -Category Testing | Remove-PSWorkItem
```

Remove all work items in the Test category.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the command.

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

### -ID

The work item ID.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the command runs.
The command is not run.

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

This command supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### None

## NOTES

This command should have an alias of rwi.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Complete-PSWorkItem](Complete-PSWorkItem.md)

[Get-PSWorkItem](Get-PSWorkItem.md)

[Set-PSWorkItem](Set-PSWorkItem.md)

[Remove-PSWorkItemArchive](Remove-PSWorkItemArchive.md)
