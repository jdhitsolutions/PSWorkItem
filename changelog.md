# Changelog for PSWorkItem

The format of this file is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Added aliases of `due` and `deadline` for `DueDate` for the `psworkitem` type.
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

- Added format file `psworkitem.format.ps1xml`.
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

- Added `Add-PSWorkitemCategory`,`Get-PSWorkItemCategory`, and `Remove-PSWorkItemCategory`.
- Added `Get-PSWorkingItemDatabase`.
- Added class definition for `PSWorkItemDatabase`.
- Added format file `psworkitemdatabase.format.ps1xml`.

### Changed

- Updated `Initialize-PSWorkItemDatabase` to add default categories.
- Improved verbose messaging.

## [0.1.0] - 2022-07-22

- Initial files
- Created Module outline

[Unreleased]: https://github.com/jdhitsolutions/PSWorkItem/compare/v0.8.0..HEAD
[0.8.0]:  https://github.com/jdhitsolutions/PSWorkItem/tree/v0.8.0
[0.7.0]:  https://github.com/jdhitsolutions/PSWorkItem/compare/v0.6.0..v0.7.0
[0.6.0]:  https://github.com/jdhitsolutions/PSWorkItem/compare/v0.5.0..v0.6.0
[0.5.0]:  https://github.com/jdhitsolutions/PSWorkItem/compare/v0.4.0..v0.5.0
[0.4.0]:  https://github.com/jdhitsolutions/PSWorkItem/commit/303837de0fc6ca807e121c3d6fad5b851b25cf7f
[0.3.0]: https://github.com/jdhitsolutions/PSWorkItem/commit/e4a290dd256dc6d86d6b6893113668985c8add61
[0.2.0]: https://github.com/jdhitsolutions/PSWorkItem/commit/1ea8c57448e4e687d1f81fa4f4515c4dbfea4048
[0.1.0]: https://github.com/jdhitsolutions/PSWorkItem/commit/fdb4255d4b5f605e03deab409829c13ed5166945