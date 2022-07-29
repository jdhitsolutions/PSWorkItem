---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version:
schema: 2.0.0
---

# Get-PSWorkItemArchive

## SYNOPSIS

Get archived PSWorkItems.

## SYNTAX

### name (Default)

```
Get-PSWorkItemArchive [[-Name] <String>] [-Path <String>] [<CommonParameters>]
```

### id
```
Get-PSWorkItemArchive [-ID <String>] [-Path <String>] [<CommonParameters>]
```

### category
```
Get-PSWorkItemArchive [-Category <String>] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1

```powershell
PS C:\>
```

## PARAMETERS

### -Category
Get all open tasks by category

```yaml
Type: String
Parameter Sets: category
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
The task ID.

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the work item.
Wilcards are supported.

```yaml
Type: String
Parameter Sets: name
Aliases: task

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

