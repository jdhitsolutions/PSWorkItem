# Changelog for PSWorkItem

## 0.7.0

+ Updated commands to better handle dates and respect culture. There is a PowerShell issue where using `Get-Date` in as a sub-expression fails to respect culture. An expression like `"Today is (Get-Date)"` may not respect non-US cultures. Using the -f operator does: `"Today is "0}" -f (Get-Date)`. Modified my queries using datetime values accordingly. If you have a database created under a previous version of the module, it is recommended that you use `Set-PSWorkItem` to touch every item.
+ Fixed bug in `Get-PSWorkItemArchive` that was referencing a hardcoded variable and not the parameter.
+ Fixed bug in `Get-PSWorkItem` when filtering by number of days dues.
+ Updated missing online help links.
+ Updated WhatIf message in `New-PSWorkItem` to include more detail.

## 0.6.0

+ Added `Get-PSWorkItemData` to get raw table data.
+ Module manifest cleanup.
+ Modified `New-PSWorkItem` and `Get-PSWorkItem` to better handle dates, especially when running commands under different cultures. _These are potential breaking changes._
+ Updated `README.md`.

## 0.5.0

+ Fixed module manifest. [Issue #1](https://github.com/jdhitsolutions/PSWorkItem/issues/1)
+ Added a feature to highlight tasks based on category. The module defines a global variable, `$PSWorkItemCategory`, which is a hashtable. The key is the category and the value is the `$PSStyle` or ANSI sequence. The default format view is configured to use these settings.
+ Updated `README.md`.

## 0.4.0

+ Updated `README`.
+ Added online help links.
+ Help updates.
+ Updated module manifest.
+ Made `Category` and `Description` positional parameters in `New-PSWorkItem`.
+ Defined a module dependency on version 0.9.2 or later of the MySQLite module.
+ Created a sample database file.
+ Published to the PowerShell Gallery.

## 0.3.0

+ Added format file `psworkitem.format.ps1xml`.
+ Changed `Comment` column in `Categories` table to `Description`.
+ Refined auto-completer for `New-PSWorkItem`.
+ Fixed typo in tasks table.
+ Added `Get-PSWorkItem`,`New-PSWorkItem`,`Set-PSWorkItem`,'`Complete-PSWorkItem` and `Remove-PSWorkItem`.
+ Made database queries case-insensitive.
+ Removed `Connection` parameter from all commands. The expected database usage is not enough to warrant setting up and managing connections. Some commands will internally use connections where they can be better managed.
+ Added `ID` parameter to `Get-PSWorkItem`.
+ Added `Complete-PSWorkItem`.
+ Modified `New-PSWorkItem` to accept most parameters from the pipeline by property name. This should facilitate importing data from external sources.
+ Made `$PSWorkItemPath` a global variable instead of exporting it. This removes the need to use `Export-ModuleMember`. The manifest should be sufficient.
+ Added alias `gwi` to `Get-PSWorkItem`.
+ Added alias `nwi` to `New-PSWorkItem`.
+ Updated Category argument completer to display "no description" if nothing is defined for the description property.
+ Added type extension `TimeRemaining` for `PSWorkItem` and added a supporting table view called `countdown`.
+ Added type `PSWorkItemArchive` and format view.
+ Added an option to set an new tasks due date by the number of days.
+ Added a table view called `Category` for PSWorkItems.

## 0.2.0

+ Added `Add-PSWorkitemCategory`,`Get-PSWorkItemCategory`, and `Remove-PSWorkItemCategory`.
+ Added `Get-PSWorkingItemDatabase`.
+ Added class definition for `PSWorkItemDatabase`.
+ Added format file `psworkitemdatabase.format.ps1xml`.
+ Updated `Initialize-PSWorkItemDatabase` to add default categories.
+ Improved verbose messaging.

## 0.1.0

+ Initial files
+ Created Module outline
