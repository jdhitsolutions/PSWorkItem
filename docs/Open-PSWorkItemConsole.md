---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/48zfOB8
schema: 2.0.0
---

# Open-PSWorkItemConsole

## SYNOPSIS

Open the PSWorkItem management console

## SYNTAX

```yaml
Open-PSWorkItemConsole [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION

This command will launch a terminal-based console for managing PSWorkItems. You can select items from the table which will populate the entry forms. You can then modify the work item and click Set-PSWorkItem, or you can mark the item as complete or remove it. To enter a new PSWorkItem, use Options - Clear Form. Enter your new item, selecting a category from the list, and click the Add New PSWorkItem button. You cannot set a progress value when creating a new work item.

You can also enter a different database path by entering the path in the Database field, or using Options - Open database. Use the Reset Form option to reset the form with your default settings.

## EXAMPLES

### Example 1

```powershell
PS C:\> Open-PSWorkItemConsole
```

Open the management console using the default $PSWorkItemPath variable. You can also use the wic alias.

### Example 2

```powershell
PS C:\ OpenPSWorkItemConsole c:\work\personal.db
```

Open the management console using an alternate database.

## PARAMETERS

### -Path

The path to the PSWorkItem SQLite database file. It must end in .db

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

### None

## OUTPUTS

### None

## NOTES

You cannot specify a completion date using this tool. You must manage categories using the module commands.

If you have difficulty seeing the cursor in text fields, and you are running in Windows Terminal, you might try changing the cursor in your Windows Terminal profile setting.

IMPORTANT: This command relies on a specific version of Terminal.Gui assembly. You might encounter version conflicts from modules that use older versions of this assembly like Microsoft.PowerShell.ConsoleGuiTools. You may need to load this module first in a new PowerShell session.

## RELATED LINKS

[Get-PSWorkItem](Get-PSWorkItem.md)

[Set-PSWorkItem](Set-PSWorkItem.md)

[Remove-PSWorkItem](Remove-PSWorkItem.md)

[Complete-PSWorkItem](Complete-PSWorkItem.md)