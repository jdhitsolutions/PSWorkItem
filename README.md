# PSWorkItem

[![PSGallery Version](https://img.shields.io/powershellgallery/v/PSWorkItem.png?style=for-the-badge&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/PSWorkItem/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/PSWorkItem.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/PSWorkItem/)

This module is a replacement for the [MyTasks](https://github.com/jdhitsolutions/MyTasks) module. The origial PowerShell module offered simple task or to-do management. All data was stored in XML files. This module conceptually is designed the same way but instead uses a SQLite database file. The module commands are wrapped around functions from the MySQLite module.

## Installation

This module requires PowerShell 7.2 or later and a 64-bit version of PowerShell, which most people are running. __The module requires a Windows platform.__ You can install this module from the PowerShell Gallery.

```powershell
Install-Module PSWorkItem [-scope CurrentUser]
```

Module installation will also install the required [MySQLite](https://github.com/jdhitsolutions/MySQLite) module.

## Module Commands and Design

+ [Add-PSWorkItemCategory](Add-PSWorkItemCategory.md)
+ [Complete-PSWorkItem](Complete-PSWorkItem.md)
+ [Get-PSWorkItem](Get-PSWorkItem.md)
+ [Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)
+ [Get-PSWorkItemCategory](Get-PSWorkItemCategory.md)
+ [Get-PSWorkItemDatabase](Get-PSWorkItemDatabase.md)
+ [Initialize-PSWorkItemDatabase](Initialize-PSWorkItemDatabase.md)
+ [Remove-PSWorkItem](Remove-PSWorkItem.md)
+ [Remove-PSWorkItemCategory](Remove-PSWorkItemCategory.md)
+ [New-PSWorkItem](New-PSWorkItem.md)
+ [Set-PSWorkItem](Set-PSWorkItem.md)

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

```powershell
class PSWorkItem {
    #this can be the ROWID of the item in the database
    [int]$ID
    [string]$Name
    [string]$Category
    [string]$Description
    [DateTime]$DueDate = (Get-Date).AddDays(30)
    [int]$Progress = 0
    [DateTime]$TaskCreated = (Get-Date)
    [DateTime]$TaskModified = (Get-Date)
    [boolean]$Completed
    [string]$Path
    #this will be last resort GUID to ensure uniqueness
    hidden[guid]$TaskID = (New-Guid).Guid

    PSWorkItem ([string]$Name, [string]$Category) {
        $this.Name = $Name
        $this.Category = $Category
    }
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
    [string]$Category
    [string]$Description

    PSWorkItemCategory([string]$Category, [string]$Description) {
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

You can view a database summary with `Get-PSWorkitemDatabase`.

```powershell
 PS C:\> Get-PSWorkItemDatabase

   Path: C:\Users\Jeff\PSWorkItem.db [32KB]

Created              LastModified         Tasks Archived Categories
-------              ------------         ----- -------- ----------
7/26/2022 9:56:18 AM 7/29/2022 1:11:17 PM     6        6         12
```

## Categories

To add a new category, you must specify a category name. The description is optional. The category will be defined exactly as you enter it, so watch casing.

```powershell
Add-PSWorkItemCategory -Category "SRV" -Description "server management tasks"
```

Use `Get-PSWorkItemCategory` to view your categories.

```powershell
PS C:\>  Get-PSWorkItemCategory

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
PS C:\> Add-PSWorkItemCategory -Category Work -Description "business related tasks" -Passthru -Force

Category Description
-------- -----------
Work     business related tasks
```

Or you can use `Remove-PSWorkItemCategory` and start all over.

Commands that have a `Category` parameter should have tab completion.

## Adding a Task

Use `New-PSWorkItem` to define a task. You need to specify a name and category. You must specify a valid, pre-defined category. By default, the task will be configured with a due date of 30 days from now. You can specify a different datetime or specify the number of days from now.

```powershell
New-PSWorkItem -Name "Publish PSWorkitem" -DaysDue 3 -Category Project
```

Because you have to specify a task, you might want to set a default category.

```powershell
$PSDefaultParameterValues.Add("New-PSWorkItem:Category","Work")
```

## Viewing Tasks

The primary command in this module, `Get-PSWorkItem`, which has an alias of `gwi`, has several parameter sets to help you select PSWorkItems.

+ `Get-PSWorkItem [-All] [-Path <String>]`
+ `Get-PSWorkItem [-Category <String>] [-Path <String>]`
+ `Get-PSWorkItem [-DaysDue <Int32>] [-Path <String>]`
+ `Get-PSWorkItem [-ID <String>] [-Path <String>]`
+ `Get-PSWorkItem [[-Name] <String>] [-Path <String>]`

The default behavior is to get tasks due within the next ten days

![Get-PSWorkItem](images/get-psworkitem.png)

If you are running the command in the PowerShell console or VSCode, overdue tasks will be highlighted in red. Tasks due within three days will be highlighted in yellow.

Read the examples for [Get-PSWorkItem](docs/Get-PSWorkItem.md) for other ways to use this command including custom format views.

### PSWorkItemCategory

In addition to formatting overdue and imminent due dates, the module also provides a mechanism to add highlighting of specific categories. Importing the module will create a global variable called `PSWorkItemCategory`. The key will be a category name. The value will be a $PSStyle or ANSI escape sequence. These are the module defaults.

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

The entry will have no effect unless the category is defined in the database.

> Note that when you view the hashtable, you won't see any values because they escape sequences are non-printable.

![colorized categories](images/psworkitemcategory.png)

Category highlighting is only available in the default view.

## Updating Tasks

Use [Set-PSWorkItem](docs/Set-PSWorkItem.md) or its alias `swi` to update a task based on its ID.

```powershell
PS C:\> Set-PSWorkItem -id 7 -Progress 30 -DueDate "8/15/2022 12:00PM" -Passthru

  Database: C:\Users\Jeff\PSWorkItem.db

ID Name            Description DueDate               Category Pct
-- ----            ----------- -------               -------- ---
 7 password report             8/15/2022 12:00:00 PM Work      30
```

## Completing Tasks

When a task is complete, you can move it to the `Archive` table.

```powershell
PS C:\> Complete-PSWorkItem -id 11 -Passthru

    Database: C:\Users\Jeff\PSWorkItem.db
ID Name          Description Category Completed
-- ----          ----------- -------- ---------
7  update resume             Work     7/30/2022 1:29:08 PM
```

There are no commands to modify the task after it has been archived, so if you want to update the name, description, or category, do so before marking it as complete.

Note that when you move a task to the `Archive` table, it will most likely get a new ID.

[Complete-PSWorkItem](docs/Complete-PSWorkItem.md) has an alias of `cwi`.

### Removing a Task

If you want to delete a task, you can use [Remove-PSWorkItem](docs/Remove-PSWorkItem.md) or its alias `rwi`.

```powershell
Remove-PSWorkItem -id 13
```

This command will delete the item from the Tasks database.

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

+ Password protection options
+ A WPF and/or TUI form for entering new work items
+ A WPF and/or TUI form for displaying and managing work items.

If you have an enhancement suggestion, please submit it as an Issue.
