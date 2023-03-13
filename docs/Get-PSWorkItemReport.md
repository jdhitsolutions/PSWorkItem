---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3YB7fQk
schema: 2.0.0
---

# Get-PSWorkItemReport

## SYNOPSIS

Get a summary report of PSWorkItems.

## SYNTAX

```yaml
Get-PSWorkItemReport [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this simple command to get a report of PSWorkItems by category. The percentages for each category are rounded. The percentage of Overdue items is based on all open work items.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItemReport

   Path: C:\Users\Jeff\PSWorkItem.db

Count Category PctTotal
----- -------- --------
3     Personal       50
1     Other          17
1     Event          17
1     Blog           17
2     Overdue        33
```

## PARAMETERS

### -Path

The path to the PSWorkItem SQLite database file.
It should end in .db

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: $PSWorkItemPath
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSWorkItemReport

## NOTES

## RELATED LINKS

[Get-PSWorkItem](Get-PSWorkItem.md)
