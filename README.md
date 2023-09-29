# PSWorkItem

[![PSGallery Version](https://img.shields.io/powershellgallery/v/PSWorkItem.png?style=for-the-badge&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/PSWorkItem/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/PSWorkItem.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/PSWorkItem/)

This module is a replacement for the [MyTasks](https://github.com/jdhitsolutions/MyTasks) module. The original PowerShell module offered simple task or to-do management. All data was stored in XML files. This module conceptually is designed the same way but instead uses a SQLite database file. The module commands are wrapped around functions from the MySQLite module.

## Installation

This module requires __PowerShell 7.3__ or later and a 64-bit version of PowerShell, which I assume most people are running. __The module requires a Windows platform__ until the dependency SQLite module [supports non-Windows systems](https://github.com/jdhitsolutions/MySQLite/issues/21).

Install the PSWorkItem module from the PowerShell Gallery.

```powershell
Install-Module PSWorkItem [-scope CurrentUser]
```

:heavy_exclamation_mark: Module installation will also install the required [MySQLite](https://github.com/jdhitsolutions/MySQLite) module from the PowerShell Gallery.

## PSWorkItem Database Change

**If you were using a version of this module prior to v1.0.0, this note applies to you.**

>Version 1.0.0 of the PSWorkItem module introduced a structural change to the database tables. If you are using a database created in an earlier version, you need to run [Update-PSWorkItemDatabase](docs/Update-PSWorkItemDatabase.md) before adding, changing, or completing work items. You should back up your database file before running this command.
> Alternatively, you could export your work items, delete the database file, initialize a new one, and re-import your work items.
>During the upgrade, a new table column called ID is added to the Tasks and Archive database tables. In the Tasks table, the ID column for existing entries will be set to the row id, which should be the task number you are used to seeing. In the archive table, existing entries will get an ID value of 0 since knowing the original ID number is impossible. This database change corrects this problem. Going forward, the PSWorkItem ID will remain the same when you complete it and move the item to the Archive table.

## Module Commands and Design

- [Add-PSWorkItemCategory](docs/Add-PSWorkItemCategory.md)
- [Complete-PSWorkItem](docs/Complete-PSWorkItem.md)
- [Get-PSWorkItem](docs/Get-PSWorkItem.md)
- [Get-PSWorkItemArchive](docs/Get-PSWorkItemArchive.md)
- [Get-PSWorkItemCategory](docs/Get-PSWorkItemCategory.md)
- [Get-PSWorkItemData](docs/Get-PSWorkItemData.md)
- [Get-PSWorkItemDatabase](docs/Get-PSWorkItemDatabase.md)
- [Get-PSWorkItemPreference](docs/Get-PSWorkItemPreference.md)
- [Get-PSWorkItemReport](docs/Get-PSWorkItemReport.md)
- [Initialize-PSWorkItemDatabase](docs/Initialize-PSWorkItemDatabase.md)
- [New-PSWorkItem](docs/New-PSWorkItem.md)
- [Remove-PSWorkItem](docs/Remove-PSWorkItem.md)
- [Remove-PSWorkItemArchive](docs/Remove-PSWorkItemArchive.md)
- [Remove-PSWorkItemCategory](docs/Remove-PSWorkItemCategory.md)
- [Set-PSWorkItem](docs/Set-PSWorkItem.md)
- [Set-PSWorkItemCategory](docs/Set-PSWorkItemCategory.md)
- [Update-PSWorkItemDatabase](docs/Update-PSWorkItemDatabase.md)
- [Update-PSWorkItemPreference](docs/Update-PSWorkItemPreference.md)

The module is based on three tables in a SQLite database file. The primary `Tasks` table is where active items are stored.

```text
ColumnIndex ColumnName   ColumnType
----------- ----------   ----------
0           taskid       text
1           taskcreated  text
2           taskmodified text
3           name         text
4           description  text
5           duedate      text
6           category     text
7           progress     integer
8           completed    integer
```

When items are queried from this table using `Get-PSWorkItem` they are written to the pipeline as a `PSWorkItem` object. This is a class-based object defined in the root module.

> These definitions were revised for v1.0.0.

```powershell
class PSWorkItemBase {
    [int]$ID
    [String]$Name
    [String]$Category
    [String]$Description
    [DateTime]$TaskCreated = (Get-Date)
    [DateTime]$TaskModified = (Get-Date)
    [boolean]$Completed
    [String]$Path
    #this will be last resort GUID to ensure uniqueness
    hidden[guid]$TaskID = (New-Guid).Guid

}
class PSWorkItem:PSWorkItemBase {
    [DateTime]$DueDate = (Get-Date).AddDays(30)
    [int]$Progress = 0

    PSWorkItem ([String]$Name, [String]$Category) {
        $this.Name = $Name
        $this.Category = $Category
    }
    PSWorkItem() {
        $this
    }
}

Class PSWorkItemArchive:PSWorkItemBase {
    [DateTime]$DueDate
    [int]$Progress
}
```

Each task or `PSWorkItem` must have an associated category. These are stored in the `Categories` table.

```text
ColumnIndex ColumnName  ColumnType
----------- ----------  ----------
0           category    text
1           description text
```

You __must__ define categories with `Add-PSWorkItemCategory` before you can create a new task. Categories are written to the pipeline as `PSWorkItemCategory` objects, also defined with a PowerShell class.

```powershell
class PSWorkItemCategory {
    [String]$Category
    [String]$Description

    PSWorkItemCategory([String]$Category, [String]$Description) {
        $this.Category = $Category
        $this.Description = $Description
    }
}
```

When a task is complete, you can use `Complete-PSWorkItem` to update the task as completed. This command will copy the task to the `Archive` table, which has the same layout as the `Tasks` table, and then delete it from `Tasks`.

### PSWorkItemPath

The module defines a global variable, `$PSWorkItemPath`, which points to the database file. The default file is `$HOME\PSWorkItem.db`. This variable is used as the default `Path` parameter on all module commands. If you want to change it, do so in your PowerShell profile.

Because everything is stored in a single database file, advanced users could set up multiple PSWorkItem systems. It is up to the user to keep track of database paths.

## Creating a New Database

To get started, run `Initialize-PSWorkItemDatabase`. This will create a new database file and set default categories of Work, Personal, Project, and Other. By default, the new database will be created using the value of `$PSWorkItemPath`.

You can view a database summary with `Get-PSWorkItemDatabase`.

```powershell
PS C:\> Get-PSWorkItemDatabase

   Path: C:\Users\Jeff\PSWorkItem.db [44KB]

Created              LastModified         Tasks Archived Categories
-------              ------------         ----- -------- ----------
7/30/2022 1:55:02 PM 9/12/2023 1:05:26 PM    13       35         12
```

## Categories

To add a new category, you must specify a category name. The description is optional. The category will be defined exactly as you enter it, so watch casing.

```powershell
Add-PSWorkItemCategory -Category "SRV" -Description "server management tasks"
```

Use `Get-PSWorkItemCategory` to view your categories.

```powershell
PS C:\> Get-PSWorkItemCategory

Category Description
-------- -----------
Work
Personal
Project
Other
Blog     blog management and content
SRV      server management tasks
```

If you need to update a category, you can re-add it using `-Force`.

> The category name is case-sensitive.

```powershell
PS C:\> Add-PSWorkItemCategory -Category Work -Description "business-related tasks" -PassThru -Force

Category Description
-------- -----------
Work     business-related tasks
```

Or you can use `Remove-PSWorkItemCategory` and start all over.

Commands that have a `Category` parameter should have tab completion.

## Adding a Task

Use `New-PSWorkItem` to define a task. You need to specify a name and category. You must specify a valid, pre-defined category. By default, the task will be configured with a due date of 30 days from now. You can specify a different datetime or specify the number of days from now.

```powershell
New-PSWorkItem -Name "Publish PSWorkItem" -DaysDue 3 -Category Project
```

Because you have to specify a task, you might want to set a default category.

```powershell
$PSDefaultParameterValues.Add("New-PSWorkItem:Category","Work")
```

## Viewing Tasks

The primary command in this module, `Get-PSWorkItem`, which has an alias of `gwi`, has several parameter sets to help you select PSWorkItems.

- `Get-PSWorkItem [-All] [-Path <String>]`
- `Get-PSWorkItem [-Category <String>] [-Path <String>]`
- `Get-PSWorkItem [-DaysDue <Int32>] [-Path <String>]`
- `Get-PSWorkItem [-ID <String>] [-Path <String>]`
- `Get-PSWorkItem [[-Name] <String>] [-Path <String>]`

The default behavior is to get tasks due within the next ten days

![Get-PSWorkItem](images/get-PSWorkItem.png)

If you are running the command in the PowerShell console or VSCode, overdue tasks will be highlighted in red. Tasks due within three days will be highlighted in yellow.

Read the examples for [Get-PSWorkItem](docs/Get-PSWorkItem.md) for other ways to use this command, including custom format views.

### PSWorkItemCategory

In addition to formatting overdue and imminent due dates, the module also provides a mechanism to add highlighting for specific categories. Importing the module will create a global variable called `PSWorkItemCategory`. The key will be a category name. The value will be a $PSStyle or ANSI escape sequence. These are the module defaults.

```powershell
$global:PSWorkItemCategory = @{
    "Work"     = $PSStyle.Foreground.Cyan
    "Personal" = $PSStyle.Foreground.Green
}
```

You can modify this hashtable as you would any other hashtable.

```powershell
$PSWorkItemCategory.Add("Event","`e[38;5;153m")
```

The entry will have no effect unless the category is defined in the database. The category customizations last for the duration of your PowerShell session or until the module is removed. Add your customizations to your PowerShell profile script or use `Update-PSWorkItemPreference` to save the settings to a JSON file under $HOME.

> Note that when you view the hashtable, you won't see any values because the escape sequences are non-printable.

![colorized categories](images/PSWorkItemcategory.png)

Category highlighting is only available in the default view.

## Updating Tasks

Use [Set-PSWorkItem](docs/Set-PSWorkItem.md) or its alias `swi` to update a task based on its ID.

```powershell
PS C:\> Set-PSWorkItem -id 7 -Progress 30 -DueDate "8/15/2022 12:00PM" -PassThru

  Database: C:\Users\Jeff\PSWorkItem.db

ID Name            Description DueDate               Category Pct
-- ----            ----------- -------               -------- ---
 7 password report             8/15/2022 12:00:00 PM Work      30
```

## Completing Tasks

When a task is complete, you can move it to the `Archive` table.

```powershell
PS C:\> Complete-PSWorkItem -id 7 -PassThru

    Database: C:\Users\Jeff\PSWorkItem.db
ID Name          Description Category Completed
-- ----          ----------- -------- ---------
7  update resume             Work     3/11/2023 1:29:08 PM
```

There are no commands to modify the task after it has been archived, so if you want to update the name, description, or category, do so before marking it as complete.

[Complete-PSWorkItem](docs/Complete-PSWorkItem.md) has an alias of `cwi`.

### Removing a Task

If you want to delete a task, you can use [Remove-PSWorkItem](docs/Remove-PSWorkItem.md) or its alias `rwi`.

```powershell
Remove-PSWorkItem -id 13
```

This command will delete the item from the Tasks database.

Beginning with v1.0.0, you can use [Remove-PSWorkItemArchive](docs/Remove-PSWorkItemArchive.md) to remove items from the archive table.

## Reporting

You can use [Get-PSWorkItemReport](docs/Get-PSWorkItemReport.md) to get a summary report of open work items grouped by category.

```powershell
PS C:\>  Get-PSWorkItemReport

   Path: C:\Users\Jeff\PSWorkItem.db

Category Count PctTotal
-------- ----- --------
Personal     5       38
Event        3       23
Project      2       15
Work         1        8
Other        1        8
Blog         1        8
Overdue      4       31
```

The percentages for each category are rounded. The percentage for Overdue items is based on all open work items.

## TUI-Based Management Console

Version 1.3.0 added a management console based on the [Terminal.Gui](https://github.com/gui-cs/Terminal.Gui) framework.

![console management](images/psworkitemconsole.png)

Run [`Open-PSWorkItemConsole`](docs\Open-PSWorkItemConsole.md) or its alias *`wic`*. The form will open with your default database. You can type a new database path or use the Open Database command under Options. The file must end in `.db`. If you select a different database, you can use `Options - Reset Form` to reset to your default database.

If you select an item from the table, it will populate the form fields. You can then update, complete, or remove the item. To create a new item, it is recommended that you first clear the form (`Options - Clear Form`). Enter the PSWorkItem details and click the `Add PSWorkItem` button.

__IMPORTANT__ This command relies on a specific version of the Terminal.Gui assembly. You might encounter version conflicts from modules that use older versions of this assembly like `Microsoft.PowerShell.ConsoleGuiTools`. You may need to load this module first in a new PowerShell session.

## User Preferences

The module includes features for the user to save preferences. You might update ANSI sequences for some categories using `$PSWorkItemCategory`. You might have set a different default database path using `$PSWorkItemPath`. Or you might have specified a different value for the number of default days with `$PSWorkItemDefaultDays`. Instead of setting these values in your PowerShell profile, you can export them to a JSON file.

```powershell
Update-PSWorkItemPreference
```

This will create a JSON file in `$HOME` called `.psworkitempref.json`. The settings in this file will be used when importing the module.

You can also specify a default category for `New-PSWorkItem`.

```powershell
Update-PSWorkItemPreference -DefaultCategory Work
```

The next time you import the module, an entry will be made to $PSDefaultParameterValues.

```powershell
$global:PSDefaultParameterValues["New-PSWorkItem:Category"] = $importPref.DefaultCategory
```

Use `Get-PSWorkItemPreference` to view.

```powershell
PS C:\> Get-PSWorkItemPreference

   Path: C:\Users\Jeff\PSWorkItem.db [Default Days: 7 Default Category: Work]

Category    ANSIString
--------    ----------
Other       `e[38;5;204m
Project     `e[38;5;215m
Event       `e[38;5;153m
Training    `e[94m
Work        `e[36m
Personal    `e[32m
```

The categories are only those where you have customized an ANSI sequence. On module import, these categories will be used to populate `$PSWorkItemCategory.` If you make any changes to your preference, re-run `Update-PSWorkItemPreference`.

> It is possible you will need to manually delete the JSON preferences file if you uninstall the module.

## Database Backup

This module has no specific commands for backing up or restoring a database file. But you can use the `Export-MySQLiteDB` command to export the PSWorkItem database file to a JSON file.

```powershell
Export-MySQLiteDB -path $PSWorkItemPath -Destination d:\backups\pwi.json
```

Use `Import-MySQLiteDB` to import the file and rebuild the database file. When restoring a database file, you should restore the file to a new location, verify the database, then copy the file to `$PSWorkItemPath`.

## Database Sample

A sample database has been created in the module's Samples directory. You can specify the path to the sample database or copy it to `$PSWorkItemPath` to try the module out. Note that it is very likely that many of the tasks will be flagged as overdue by the time you view the database.

If you copy the sample to `$PSWorkItemPath`, delete the file before creating your database file.

## Troubleshooting

Most of the commands in this module create custom objects derived from PowerShell [class definitions](PSWorkItem.psm1) and data in the SQLite database file. If you need to troubleshoot a problem, you can use `Get-PSWorkItemData` to select all data from one of the three tables.

```powershell
PS C:\> Get-PSWorkItemData

taskid       : 2196617b-b818-415d-b9cc-52b0c649a77e
taskcreated  : 07/28/2022 16:56:25
taskmodified : 07/30/2022 14:01:09
name         : Update PSWorkItem module
description  : v0.6.0
duedate      : 12/31/2022 12:00:00
category     : Other
progress     : 10
completed    : 0
rowid        : 19
...
```

## Future Tasks or Commands

- Password protection options.
- A TUI form for managing categories

If you have an enhancement suggestion, please submit it as an [Issue](https://github.com/jdhitsolutions/PSWorkItem/issues).
