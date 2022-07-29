# PSWorkItem

## Module Commands

+ Initialize-PSWorkItemDatabase
+ Get-PSWorkItem
+ Set-PSWorkitem
+ New-PSWorkitem
+ Remove-PSWorkItem
+ Complete-PSWorkItem
+ Get-PSWorkItemCategory
+ New-PSWorkItemCategory
+ Remove-PSWorkItemCategory
+ Get-PSWorkItemArchive

## Future Tasks or Commands

+ Backup database file

## Creating a New Database

### Tables: Tasks

$props = [ordered]@{
    taskid = "text"
    taskcreated = "text"
    taskmodified = "text"
    name = "text"
    description = "text"
    duedate = "text"
    category = "text"
    progress = "integer"
    completed = "integer"
}

New-MySQLiteDBTable -Path $Path -TableName tasks -ColumnProperties $props -force

### Tables: Archive

New-MySQLiteDBTable -Path $Path -TableName archive -ColumnProperties $props -force

### Tables: Categories

$props = [ordered]@{
    category = "text"
    comment = "text"
}

New-MySQLiteDBTable -Path $PSWorkItemPath -TableName categories -ColumnProperties $props -force

get-mysQLiteTable -Path $PSWorkItemPath -Detail

Everything is stored in the database in lower case to make it easier to find and test for existing items. Values will be converted to proper and title case when data is treated as a PSWorkItem or PSWorkItemCategory object.