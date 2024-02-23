# PSWorkItem

## about_PSWorkItem

# SHORT DESCRIPTION

This module is a replacement for the MyTasks (https://github.com/jdhitsolutions/MyTasks) module. The original PowerShell module offered simple tasks or to-do management. All data was stored in XML files. This module conceptually is designed the same way but instead uses a SQLite database file. The module commands are wrapped around functions from the MySQLite (https://github.com/jdhitsolutions/MySQLite) module.

# LONG DESCRIPTION

The module is based on three tables in a SQLite database file. The primary `Tasks` table is where active items are stored. When items are queried from this table using `Get-PSWorkItem` they are written to the pipeline as `PSWorkItem` objects. Each task or `PSWorkItem` must have an associated category. These are stored in the `Categories` table.

You __must__ define categories with `Add-PSWorkItemCategory` before you can create a new task. Categories are written to the pipeline as `PSWorkItemCategory` objects, also defined with a PowerShell class.

When a task is complete, you can use `Complete-PSWorkItem` to update the task as completed. This command will copy the task to the `Archive` table, which has the same layout as the `Tasks` table, and then delete it from `Tasks`.

### PSWorkItemPath

The module defines a global variable, `$PSWorkItemPath`, which points to the database file. The default file is `$HOME\PSWorkItem.db`. This variable is used as the default `Path` parameter on all module commands. If you want to change it, do so in your PowerShell profile.

Because everything is stored in a single database file, advanced users could set up multiple PSWorkItem systems. It is up to the user to keep track of database paths.

## Creating a New Database

To get started, run `Initialize-PSWorkItemDatabase`. This will create a new database file and set default categories of Work, Personal, Project, and Other. By default, the new database will be created using the value of `$PSWorkItemPath`.

You can view a database summary with `Get-PSWorkItemDatabase`.

## Categories

To add a new category, you must specify a category name. The description is optional. The category will be defined exactly as you enter it, so watch casing.

Use `Get-PSWorkItemCategory` to view your categories. If you need to update a category, you can re-add it using `-Force`. The category name is case-sensitive.

## Adding a Task

Use `New-PSWorkItem` to define a task. You need to specify a name and category. You must specify a valid, pre-defined category. By default, the task will be configured with a due date of 30 days from now. You can specify a different datetime or specify the number of days from now.

## Viewing Tasks

The primary command in this module, `Get-PSWorkItem`, which has an alias of `gwi`, has several parameter sets to help you select PSWorkItems.

- `Get-PSWorkItem [-All] [-Path <String>]`
- `Get-PSWorkItem [-Category <String>] [-Path <String>]`
- `Get-PSWorkItem [-DaysDue <Int32>] [-Path <String>]`
- `Get-PSWorkItem [-ID <String>] [-Path <String>]`
- `Get-PSWorkItem [[-Name] <String>] [-Path <String>]`

The default behavior is to get tasks due within the next ten days

If you are running the command in the PowerShell console or VSCode, overdue tasks will be highlighted in red. Tasks due within three days will be highlighted in yellow.

Read the examples for `Get-PSWorkItem` for other ways to use this command, including custom format views.

### PSWorkItemCategory

In addition to formatting overdue and imminent due dates, the module also provides a mechanism to add highlighting for specific categories. Importing the module will create a global variable called `PSWorkItemCategory`. The key will be a category name. The value will be a $PSStyle or ANSI escape sequence.

You can modify this hashtable as you would any other hashtable.

```shell
$PSWorkItemCategory.Add("Event","`e[38;5;153m")
```

The entry will have no effect unless the category is defined in the database. The category customizations last for the duration of your PowerShell session or until the module is removed. Add your customizations to your PowerShell profile script or use `Update-PSWorkItemPreference` to save the settings to a JSON file under $HOME.

Note that when you view the hashtable, you won't see any values because the escape sequences are non-printable.

## Updating Tasks

Use `Set-PSWorkItem` or its alias `swi` to update a task based on its ID.

## Completing Tasks

When a task is complete, you can move it to the `Archive` table.

```shell
PS C:\> Complete-PSWorkItem -id 7
```

There are no commands to modify the task after it has been archived, so if you want to update the name, description, or category, do so before marking it as complete.

`Complete-PSWorkItem` has an alias of `cwi`.

### Removing a Task

If you want to delete a task, you can use Remove-PSWorkItem or its alias `rwi`.

```powershell
Remove-PSWorkItem -id 13
```

This command will delete the item from the Tasks database.

Beginning with v1.0.0, you can use Remove-PSWorkItemArchive to remove items from the archive table.

## Reporting

You can use `Get-PSWorkItemReport` to get a summary report of open work items grouped by category. The percentages for each category are rounded. The percentage for Overdue items is based on all open work items.

## TUI-Based Management Console

Version 1.3.0 added a management console based on the Terminal.Gui framework.

Run Open-PSWorkItemConsole or its alias *`wic`*. The form will open with your default database. You can type a new database path or use the Open Database command under Options. The file must end in `.db`. If you select a different database, you can use `Options - Reset Form` to reset to your default database.

If you select an item from the table, it will populate the form fields. You can then update, complete, or remove the item. To create a new item, it is recommended that you first clear the form (`Options - Clear Form`). Enter the PSWorkItem details and click the `Add PSWorkItem` button.

### IMPORTANT

This command relies on a specific version of the Terminal.Gui assembly. You might encounter version conflicts from modules that use older versions of this assembly like `Microsoft.PowerShell.ConsoleGuiTools`. You may need to load this module first in a new PowerShell session.

# User Preferences

The module includes features for the user to save preferences. You might update ANSI sequences for some categories using `$PSWorkItemCategory`. You might have set a different default database path using `$PSWorkItemPath`. Or you might have specified a different value for the number of default days with `$PSWorkItemDefaultDays`. Instead of setting these values in your PowerShell profile, you can export them to a JSON file.

```powershell
Update-PSWorkItemPreference
```

This will create a JSON file in `$HOME` called `.psworkitempref.json`. The settings in this file will be used when importing the module.

You can also specify a default category for `New-PSWorkItem`.

```powershell
Update-PSWorkItemPreference -DefaultCategory Work
```

The next time you import the module, an entry will be made to `$PSDefaultParameterValues`.

```powershell
$global:PSDefaultParameterValues["New-PSWorkItem:Category"] = $importPref.DefaultCategory
```

Use `Get-PSWorkItemPreference` to view.

The categories are only those where you have customized an ANSI sequence. On module import, these categories will be used to populate `$PSWorkItemCategory.` If you make any changes to your preference, re-run `Update-PSWorkItemPreference`.

You might need to manually delete the JSON preferences file if you uninstall the module.

## Database Backup

This module has no specific commands for backing up or restoring a database file. But you can use the `Export-MySQLiteDB` command to export the PSWorkItem database file to a JSON file.

```shell
Export-MySQLiteDB -path $PSWorkItemPath -Destination d:\backups\pwi.json
```

Use `Import-MySQLiteDB` to import the file and rebuild the database file. When restoring a database file, you should restore the file to a new location, verify the database, and then copy the file to `$PSWorkItemPath`.

## Database Sample

A sample database has been created in the module's Samples directory. You can specify the path to the sample database or copy it to `$PSWorkItemPath` to try the module out. Note that it is very likely that many of the tasks will be flagged as overdue by the time you view the database.

If you copy the sample to `$PSWorkItemPath`, delete the file before creating your database file.

## Troubleshooting

Most of the commands in this module create custom objects derived from PowerShell class definitions and data in the SQLite database file. If you need to troubleshoot a problem, you can use `Get-PSWorkItemData` to select all data from one of the three tables.

If you have an enhancement suggestion, please submit it as a GitHub issue at https://github.com/jdhitsolutions/PSWorkItem/issues.

# SEE ALSO

https://github.com/jdhitsolutions/PSWorkItem

# KEYWORDS

- WorkItem
- PSWorkItem
- SQLite
