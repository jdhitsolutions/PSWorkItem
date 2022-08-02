# Changelog for PSWorkItem

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
