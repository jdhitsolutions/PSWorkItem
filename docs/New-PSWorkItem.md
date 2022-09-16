---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3vnOvI3
schema: 2.0.0
---

# New-PSWorkItem

## SYNOPSIS

Create a new PSWorkItem.

## SYNTAX

### date (Default)

```yaml
New-PSWorkItem [-Name] <String> [-Category] <String> [-Description <String>] [-DueDate <DateTime>] [-Path <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### days

```yaml
New-PSWorkItem [-Name] <String> [-Category] <String> [-Description <String>] [-DaysDue <Int32>] [-Path <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to add a new PSWorkItem to the database. It is assumed you have already defined your task categories. The default is to create a new PSWorkItem with a due date 30 days from now. You can specify any due date or the number of days from now.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PSWorkItem -Name "Blog updates" -Description "update pages" -DueDate "8/15/2022 5:00PM" -Category Blog -passthru
```

Create a new PSWorkitem with a due date 30 days from now. You should be able to use tab completion for the Category parameter.

### Example 2

```powershell
PS C:\> New-PSWorkItem -Name "Publish PSWorkitem" -DaysDue 3 -Category Project
```

Create a new PSWorkItem due in 3 days.

## PARAMETERS

### -Category

Select a valid catetory. The category must be pre-defined. There should be tab-completion for this parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

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

### -Description

Add a comment or task description.

```yaml
Type: String
Parameter Sets: (All)
Aliases: comment

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DueDate

When is this task due?
The default is 30 days.

```yaml
Type: DateTime
Parameter Sets: date
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

The name of the work item.

```yaml
Type: String
Parameter Sets: (All)
Aliases: task

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
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
It should end in .db.

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

### -DaysDue

Specify the number of days before the task is due to be completed. Enter a value between 1 and 365.

```yaml
Type: Int32
Parameter Sets: days
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This command supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### None

### PSWorkItem

## NOTES

This command has an alias of nwi.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSWorkItem](Get-PSWorkItem.md)

[Set-PSWorkItem](Set-PSWorkItem.md)

[Complete-PSWorkItem](Complete-PSWorkItem.md)

[Remove-PSWorkItem](Remove-PSWorkItem.md)
