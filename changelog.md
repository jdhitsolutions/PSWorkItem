# Changelog for PSWorkItem

## [Unreleased]

## [1.3.1] - 2023-09-29

### Changed

- Updated `README.md`.
- Removed minimum version for the MySQLite dependency.

## [1.3.0] - 2023-09-28

### Added

- Added a parameter set to `Set-PSWorkItem` to let the user clear the description field.
- Added an option for the user to set the default number of days for a new PSWorkItem. The module default is 30 days, but the user can modify the global variable. The preference commands and format file have been updated to reflect this change.
- Added parameter validation for `Name` and `Description` parameters to reject values with apostrophes. Apostrophes break SQLite syntax.
- Added command `Open-PSWorkItemConsole` with an alias of `wic`. This will create a terminal user interface for managing PSWorkItems.
- Added script property type extension for `PSWorkItemCategory`  called `ANSIString` to show the ANSI sequence.
- Added command `Get-PSWorkItemPreference`.
- Added localized string data for verbose, warning, and error messaging.
- Added parameter alias `Date` to `DueDate` in `New-PSWorkItem`.
- Updated module to let the user specify a default category for `New-PSWorkItem`. This default must be saved with `Update-PSWorkItemPreference`.

### Changed

- Modified `Complete-PSWorkItem`, `Set-PSWorkItem`, and `Remove-PSWorkItem` to accept pipeline input from `Get-PSWorkItem`.
- Converted the `-Category` parameter in commands to a dynamic parameter. This allows autocompletion of values if the user specifies an alternate database path. __This is a potential breaking change__.
- Modified Path parameter in functions to use the newer PowerShell 7 compatible [ValidateScript()] attribute.
- Raised minimum PowerShell version to 7.3. __This is a potential breaking change__.
- Updated sample PSWorkItem database.
- Modified `Get-PSWorkItemData` to write `System.Data.DataTable` output.
- Moved verbose messaging to a private helper function.
- Modified layout of the default view for `Get-PSWorkItemReport`.
- Updated format file `psWorkItemPreference.format.ps1xml`.
- Help updates.
- Updated `README.md`

## [1.2.0] - 2023-07-26

### Added

- Added missing online help links.

### Fixed

- Fixed casing in the manifest for format files that was causing an error in non-Windows systems.

## [1.1.0] - 2023-06-30

### Added

- Added a format file for PSWorkItemCategory to display categories using the designated color scheme. [Issue #10](https://github.com/jdhitsolutions/PSWorkItem/issues/10)
- Added command `Update-PSWorkItemPreferences` to store user preferences in a JSON file stored in `$HOME`. If the file is found, settings will be imported.
- Added command `Set-PSWorkItemCategory` [Issue 11](https://github.com/jdhitsolutions/PSWorkItem/issues/11)

### Changed

- Updated README.

## [1.0.1] - 2023-03-13

### Changed

- Minor help corrections.
- Added missing online help links.

### Fixed

- Fixed warning message in `Get-PSWorkItemArchive`

## [1.0.0] - 2023-03-12

This is a major update with significant changes. If this is your first time installing the module, no further action is required. If you are upgrading from a previous version of this module, you will need to run `Update-PSWorkItemDatabase`. See the [README](README.md) file for more information.

### Added

- Added command `Update-PSWorkItemDatabase` to add the new `ID` column to the `tasks` and `archive` tables.
- Added command `Get-PSWorkItemReport`.
- Added command `Remove-PSWorkItemArchive`.
- Added format file `psWorkitemreport.format.ps1xml`.
- Added property set `ProgressSet` for the `PSWorkItem` type.
- Added property type extension `Age` for `PSWorkItem` to show the age of the item since it was created.
- Added a table format view called `Age` for PSWorkItems.

### Changed

- Modified module to add an `ID` property that will be the same in both the `Tasks` and `Archive` tables. Commands have been modified to use the `RowID` for the `ID` property for the first task. After that, the next ID will be one more than the highest ID found in the tasks or archive table. _This is a major breaking change_. [Issue #7](https://github.com/jdhitsolutions/PSWorkItem/issues/7)
- Modified the class definitions into distinct items so that the `PSWorkItemArchive` doesn't inherit properties like `Overdue` that don't belong. _This is a potential breaking change_. [Issue #8](https://github.com/jdhitsolutions/PSWorkItem/issues/8)
- updated the sample PSWorkItem database.
- General code cleanup.
- help updates.
- Updated `README.md`.

### Removed

- Removed `readme.txt` from the Types folder

### Fixed

- Fixed bug in `Complete-PSWorkItem` when using `-PassThru`

## [0.9.0] - 2023-01-02

### Added

- Added aliases of `due` and `deadline` for `DueDate` for the `PSWorkItem` type.
- Moved type extensions to external ps1xml files.

### Changed

- Updated README.md.
- Migrated CHANGELOG to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.

### Fixed

- Merged [PR #6](https://github.com/jdhitsolutions/PSWorkItem/pull/6) to fix [Issue #5](https://github.com/jdhitsolutions/PSWorkItem/issues/5)

## [0.8.0] - 2022-12-13

### Added

- Add database path as a property to workitem and archived workitem objects.

### Changed

- Update default format view to group by database path.
- Help updates.

### Fixed

- Merged [PR#4](https://github.com/jdhitsolutions/PSWorkItem/pull/4) that resolves [Issue #3](https://github.com/jdhitsolutions/PSWorkItem/issues/3) Thank you @jbelina.

## [0.7.0] - 2022-09-16

### Fixed

- Fixed bug in `Get-PSWorkItemArchive` that was referencing a hardcoded variable and not the parameter.
- Fixed bug in `Get-PSWorkItem` when filtering by number of days dues.

### Updated

- Updated missing online help links.
- Updated commands to better handle dates and respect culture. There is a PowerShell issue where using `Get-Date` in as a sub-expression fails to respect culture. An expression like `"Today is (Get-Date)"` may not respect non-US cultures. Using the -f operator does: `"Today is "0}" -f (Get-Date)`. Modified my queries using datetime values accordingly. If you have a database created under a previous version of the module, it is recommended that you use `Set-PSWorkItem` to touch every item.
- Updated WhatIf message in `New-PSWorkItem` to include more detail.

## [0.6.0] - 2022-08-26

### Added

- Added `Get-PSWorkItemData` to get raw table data.

### Changed

- Module manifest cleanup.
- Modified `New-PSWorkItem` and `Get-PSWorkItem` to better handle dates, especially when running commands under different cultures. _These are potential breaking changes._
- Updated `README.md`.

## [0.5.0] - 2022-08-03

### Changed

- Fixed module manifest. [Issue #1](https://github.com/jdhitsolutions/PSWorkItem/issues/1)
- Updated `README.md`.

### Added

- Added a feature to highlight tasks based on category. The module defines a global variable, `$PSWorkItemCategory`, which is a hashtable. The key is the category and the value is the `$PSStyle` or ANSI sequence. The default format view is configured to use these settings.

## [0.4.0] - 2022-08-02

### Added

- Added online help links.
- Defined a module dependency on version 0.9.2 or later of the MySQLite module.
- Created a sample database file.

### Changed

- Updated `README`.
- Help updates.
- Updated module manifest.
- Made `Category` and `Description` positional parameters in `New-PSWorkItem`.
- Published to the PowerShell Gallery.

## [0.3.0] - 2022-07-30

### Added

- Added format file `PSWorkItem.format.ps1xml`.
- Added `Get-PSWorkItem`,`New-PSWorkItem`,`Set-PSWorkItem`,'`Complete-PSWorkItem` and `Remove-PSWorkItem`.
- Added `ID` parameter to `Get-PSWorkItem`.
- Added `Complete-PSWorkItem`.
- Added alias `gwi` to `Get-PSWorkItem`.
- Added type `PSWorkItemArchive` and format view.
- Added an option to set an new tasks due date by the number of days.
- Added a table view called `Category` for PSWorkItems.
- Added alias `nwi` to `New-PSWorkItem`.
- Added type extension `TimeRemaining` for `PSWorkItem` and added a supporting table view called `countdown`.

### Changed

- Changed `Comment` column in `Categories` table to `Description`.
- Refined auto-completer for `New-PSWorkItem`.
- Modified `New-PSWorkItem` to accept most parameters from the pipeline by property name. This should facilitate importing data from external sources.

### Fixed

- Fixed typo in tasks table.
- Made database queries case-insensitive.
- Made `$PSWorkItemPath` a global variable instead of exporting it. This removes the need to use `Export-ModuleMember`. The manifest should be sufficient.
- Updated Category argument completer to display "no description" if nothing is defined for the description property.

### Removed

- Removed `Connection` parameter from all commands. The expected database usage is not enough to warrant setting up and managing connections. Some commands will internally use connections where they can be better managed.

## [0.2.0] - 2022-07-25

### Added

- Added `Add-PSWorkItemCategory`,`Get-PSWorkItemCategory`, and `Remove-PSWorkItemCategory`.
- Added `Get-PSWorkingItemDatabase`.
- Added class definition for `PSWorkItemDatabase`.
- Added format file `PSWorkItemdatabase.format.ps1xml`.

### Changed

- Updated `Initialize-PSWorkItemDatabase` to add default categories.
- Improved verbose messaging.

## [0.1.0] - 2022-07-22

- Initial files
- Created Module outline

[Unreleased]: https://github.com/jdhitsolutions/PSWorkItem/compare/v1.3.1..HEAD
[1.3.1]: https://github.com/jdhitsolutions/PSWorkItem/compare/v1.3.0..v1.3.1
[1.3.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v1.2.0..v1.3.0
[1.2.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v1.1.0..v1.2.0
[1.1.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v1.0.1..v1.1.0
[1.0.1]: https://github.com/jdhitsolutions/PSWorkItem/compare/v1.0.0..v1.0.1
[1.0.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v0.9.0..v1.0.0
[0.9.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v0.8.0..v0.9.0
[0.8.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v0.7.0..v0.8.0
[0.7.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v0.6.0..v0.7.0
[0.6.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v0.5.0..v0.6.0
[0.5.0]: https://github.com/jdhitsolutions/PSWorkItem/compare/v0.4.0..v0.5.0
[0.4.0]: https://github.com/jdhitsolutions/PSWorkItem/commit/303837de0fc6ca807e121c3d6fad5b851b25cf7f
[0.3.0]: https://github.com/jdhitsolutions/PSWorkItem/commit/e4a290dd256dc6d86d6b6893113668985c8add61
[0.2.0]: https://github.com/jdhitsolutions/PSWorkItem/commit/1ea8c57448e4e687d1f81fa4f4515c4dbfea4048
[0.1.0]: https://github.com/jdhitsolutions/PSWorkItem/commit/fdb4255d4b5f605e03deab409829c13ed5166945