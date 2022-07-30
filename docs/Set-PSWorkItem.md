---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version:
schema: 2.0.0
---

# Set-PSWorkItem

## SYNOPSIS

Modify an existing PSWorkItem

## SYNTAX

```yaml
Set-PSWorkItem [-ID] <Int32> [-Name <String>] [-Description <String>] [-DueDate <DateTime>] [-Category <String>] [-Progress <Int32>] [-Path <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

When you need to update a task, use Set-PSWorkItem. You need to use the PSWorkItem ID to identify the item to be updated. You can then update the Name, Description, DueDate, Category, and Progress.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-PSWorkItem -id 3 -progress 10
```

Set the progress on a PSWorkItem.

### Example 2

```powershell
PS C:\> Get-PSWorkItem -Category blog | Set-PSworIitem -Category Other -Passthru

ID Name              Description         DueDate             Category Pct
-- ----              -----------         -------             -------- ---
 9 Clean database                        8/2/2022 9:34:35 AM Other      0
 5 revise blog pages essentials and tips 8/7/2022 5:00:00 PM Other      0
 ```

 Modify multiple PSWorkItems at the same time.

## PARAMETERS

### -Category

Specify an updated category. There should be tab-completion for this parameter.

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

### -Description

Specify an updated description.

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

### -DueDate

Specify an updated due date.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID

The work item ID. This is how you identify the PSWorkItem you want to update.

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

### -Name

The updated name of the PSWorkItem.

```yaml
Type: String
Parameter Sets: (All)
Aliases: task

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

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

### -Path

The path to the PSWorkitem SQLite database file.
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

### -Progress

Specify a percentage complete.

```yaml
Type: Int32
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

### System.Int32

## OUTPUTS

### None

### PSWorkItem

## NOTES

This command has an alias of swi.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Complete-PSWorkItem](Complete-PSWorkItem.md)

[Get-PSWorkItem](Get-PSWorkItem.md)

[Remove-PSWorkItem](Remove-PSWorkItem.md)

[New-PSWorkItem](New-PSWorkItem.md)
