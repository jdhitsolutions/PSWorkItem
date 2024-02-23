---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3TdOFMX
schema: 2.0.0
---

# Remove-PSWorkItemArchive

## SYNOPSIS

Remove archive PSWorkItems

## SYNTAX

### id (Default)

```yaml
Remove-PSWorkItemArchive [-ID] <Int32> [-Path <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### category

```yaml
Remove-PSWorkItemArchive [-Category] <String> [-Path <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### name

```yaml
Remove-PSWorkItemArchive [[-Name] <String>] [-Path <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Completed work items are moved to the Archive table in the PSWorkItem database. At some point, you may wish to clear out old archived PSWorkItems. There is no technical reason you would need to do this, but if you want to, use Remove-PSWorkItemArchive. You can remove archived PSWorkItems by ID, category, or name.

## EXAMPLES

### Example 1

```shell
PS C:\> Remove-PSWorkItem -id 7 -Verbose
VERBOSE: [12:37:40.2036443 BEGIN  ] Remove-PSWorkItem: Starting
VERBOSE: [12:37:40.2045322 BEGIN  ] Remove-PSWorkItem: PSBoundParameters
VERBOSE:
Key     Value
---     -----
ID          7
Verbose  True


VERBOSE: [12:37:40.2099707 BEGIN  ] Remove-PSWorkItem: Opening a connection to C:\Users\artd\PSWorkItem.db
VERBOSE: [12:37:40.2142745 PROCESS] Remove-PSWorkItem: Removing task 7
VERBOSE: Performing the operation "Remove-PSWorkItem" on target "1a2d1acc-738d-458f-8744-6a6e541a8bc5".
VERBOSE: [12:37:40.2245915 END    ] Remove-PSWorkItem: Closing database connection.
VERBOSE: [12:37:40.2261433 END    ] Remove-PSWorkItem: Ending
```

Delete an archived item by its ID.

### Example 2

```shell
PS C:\> Remove-PSWorkItemArchive -Category work -whatif
What if: Performing the operation "Remove-PSWorkItemArchive" on target "7e87a44f-d0ff-4cbc-ad08-ce3bf834b8e0".
What if: Performing the operation "Remove-PSWorkItemArchive" on target "02290cca-5e59-45f7-a2d9-9f34bf51817e".
What if: Performing the operation "Remove-PSWorkItemArchive" on target "44d12012-915f-481c-9dfc-c31041bb20cc".
What if: Performing the operation "Remove-PSWorkItemArchive" on target "19fea3ee-4a2d-489e-b993-84ce5677ac99".
```

Remove archived items based on a category.

### Example 3

```shell
PS C:\>  Remove-PSWorkItemArchive -name *report
```

Remove archived items where the name end in 'report'.

## PARAMETERS

### -Category

A PSWorkItem category. There should be tab-completion for this parameter. If you will be specifying an alternate database path, specify the path before using this parameter so that correct categories will be detected.

```yaml
Type: String
Parameter Sets: category
Aliases:

Required: True
Position: 0
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

### -ID

The archive work item ID.

```yaml
Type: Int32
Parameter Sets: id
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

The name of the archive work item.
Wildcards are supported.

```yaml
Type: String
Parameter Sets: name
Aliases: task

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
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

## NOTES

## RELATED LINKS

[Remove-PSWorkItem](Remove-PSWorkItem.md)

[Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)
