---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3JjqVlD
schema: 2.0.0
---

# Add-PSWorkItemCategory

## SYNOPSIS

Add a new PSWorkItem category

## SYNTAX

```yaml
Add-PSWorkItemCategory [-Category] <String[]> [[-Description] <String>]
[-Path <String>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

When you setup a new PSWorkItem database, it will define the default categories of Personal, Work, Project, and Other. You may want to add categories. The category must be defined before you can use it. The category will not be added if it already exists unless you use -Force. Or if you need to update a category description you can re-add it with -Force. If the category name needs to be edited, remove the category and re-add it.

## EXAMPLES

### Example 1

```powershell
PS C:\> Add-PSWorkItemCategory -Name Blog -Description "blog management and content" -PassThru

Category Description
-------- -----------
Blog     blog management and content
```

## PARAMETERS

### -Category

Specify the category name.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

Specify a category comment or description.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force

Force overwriting an existing category.

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

### -PassThru

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

The path to the PSWorkItem SQLite database file.
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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

### System.String

## OUTPUTS


### None

### PSWorkItemCategory

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSWorkItemCategory](Get-PSWorkItemCategory.md)

[Set-PSWorkItemCategory](Set-PSWorkItemCategory.md)

[Remove-PSWorkItemCategory](Remove-PSWorkItemCategory.md)
