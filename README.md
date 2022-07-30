# PSWorkItem

This module is a replacement for the [MyTasks](https://github.com/jdhitsolutions/MyTasks) module. That module offered simple task or to-do management. All data was stored in XML files. This module conceptually is designed the same way but instead uses a SQLite database file.

## Installation

This module requires PowerShell 7.2 or later and a 64-bit version of PowerShell, which most people are running. You will eventually be able to install this module from the PowerShell Gallery.

```powershell
Install-Module PSWorkItem
```

Installation will also install the required [MySQLite](https://github.com/jdhitsolutions/MySQLite) module.

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

The module is based on three tables in a SQLite database file. The primary Tasks table is where active items are stored.

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

Each task or `PSWorkItem` must have an associated category. These are stored in the Categories table.

```text
ColumnIndex ColumnName  ColumnType
----------- ----------  ----------
0           category    text
1           description text
```

You must define categories with `Add-PSWorkItemCategory` before you can create a new task. Categories are written to the pipeline as `PSWorkItemCategory` objects, also defined with a PowerShell class.

when a task is complete, you can use `Complete-PSWorkItem` to update the task as completed. This command will copy the task to the Archive table, which has the same layout as the Tasks table, and then delete it from Tasks.

### PSWorkItemPath

The module defines a global variable, `$PSWorkItemPath`, which points to the database file. The default file is `$HOME\PSWorkItem.db`. This variable is used as the default `Path` parameter on all module commands. If you want to change it, do so in your PowerShell profile.

Because everything is stored in a single database file, advanced users could setup multiple PSWorkItem systems. It is up to the user to keep track of database paths.

## Creating a New Database

To get started, run `Initialize-PSWorkItemDatabase`. This will create a new database file and set default categories of Work, Personal, Project, and Other. By default, the new database will created at `$PSWorkItemPath`.

You can view a database summary with `Get-PSWorkitemDatabase`.

```powershell
 PS C:\> Get-PSWorkItemDatabase

   Path: C:\Users\Jeff\PSWorkItem.db [32KB]

Created              LastModified         Tasks Archived Categories
-------              ------------         ----- -------- ----------
7/26/2022 9:56:18 AM 7/29/2022 1:11:17 PM     6        6         12
```

## Categories

To add a new category you must specify a category name. The description is optional. The category will be defined exactly as you enter it so watch casing.

```powershell
Add-PSWorkItemCategory -Category "SRV" -Description "server management tasks"
```

Use `Get-PSWorkItemCategory` to view.

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

If you need to update a category, you can re-add it using `-Force`. The category name is case-sensitive.

```powershell
PS C:\> > Add-PSWorkItemCategory -Category Work -Description "business related tasks" -Passthru -Force

Category Description
-------- -----------
Work     business related tasks
```

Or you can use `Remove-PSWorkItemCategory` and start all over.

Commands that have a `Category` parameter should have tab-completion.

## Adding a Task

Use `New-PSWorkItem` to define a task. You need to specify a name and category. You must specify a valid category. By default the task will be configured with a due date of 30 days from now. You can specify a different datetime or specify the number of days from now.

```powershell
New-PSWorkItem -Name "Publish PSWorkitem" -DaysDue 3 -Category Project
```

## Viewing Tasks

The primary command in this module, `Get-PSWorkItem`, which has an alias of `gwi`, has several parameter sets to help you select PSWorkItems.

+ `Get-PSWorkItem [-All] [-Path <String>]`
+ `Get-PSWorkItem [-Category <String>] [-Path <String>]`
+ `Get-PSWorkItem [-DaysDue <Int32>] [-Path <String>]`
+ `Get-PSWorkItem [-ID <String>] [-Path <String>]`
+ `Get-PSWorkItem [[-Name] <String>] [-Path <String>]`

The default behavior is to get tasks due within the next 10 days

![get-psworkitem](images/get-psworkitem.png)

If you are running the command in the PowerShell console or VSCode, overdue tasks will be higlighted in red. Tasks due within 3 days will be highlighted in yellow.

Read the examples for [Get-PSWorkItem](docs/Get-PSWorkItem.md) for other ways to use this command including custom format views.

## Updating Tasks

Use [Set-PSWorkItem](docs/Set-PSWorkItem.md) or its alias `swi` to update a task based on its ID.

```powershell
PS C:\> Set-PSWorkItem -id 7 -Progress 30 -DueDate "8/15/2022 12:00PM" -Passthru

ID Name            Description DueDate               Category Pct
-- ----            ----------- -------               -------- ---
 7 password report             8/15/2022 12:00:00 PM Work      30
```

## Completing Tasks

When a task is complete, you can move it to the Archive table.

```powershell
PS C:\> Complete-PSWorkItem -id 11 -Passthru

ID Name          Description Category Completed
-- ----          ----------- -------- ---------
7  update resume             Work     7/30/2022 1:29:08 PM
```

There are no commands to modify the task after it has been archived so if you want to update the name, description, or category, do so before marking it as complete.

Note that when the task is moved to the Archive table, it will most likely get a new ID.

[Complete-PSWorkItem](docs/Complete-PSWorkItem.md) has an alias of `cwi`.

### Removing a Task

If you want to delete a task, you can use [Remove-PSWorkItem](docs/Remove-PSWorkItem.md) or its alias `rwi`.

```powershell
Remove-PSWorkItem -id 13
```

This will delete the item from the Tasks database.

## Future Tasks or Commands

+ Backup database file
+ Password protection options
