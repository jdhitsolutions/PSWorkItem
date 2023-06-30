# used for culture debugging
# write-host "Importing with culture $(Get-Culture)"

Get-ChildItem $PSScriptRoot\functions\*.ps1 -Recurse |
ForEach-Object {
    . $_.FullName
}

#region class definitions
<#
classes for PSWorkItem and PSWorkItemArchive
#>
#define base PSWorkItem class
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

class PSWorkItemCategory {
    [String]$Category
    [String]$Description

    #constructor
    PSWorkItemCategory([String]$Category, [String]$Description) {
        $this.Category = $Category
        $this.Description = $Description
    }
}

class PSWorkItemDatabase {
    [String]$Path
    [DateTime]$Created
    [DateTime]$LastModified
    [int32]$Size
    [int32]$TaskCount
    [int32]$CategoryCount
    [int32]$ArchiveCount
    [String]$Encoding
    [int32]$PageCount
    [int32]$PageSize
}

#endregion

#region settings and configuration

#a global hashtable used for formatting PSWorkItems
$global:PSWorkItemCategory = @{
    "Work"     = $PSStyle.Foreground.Cyan
    "Personal" = $PSStyle.Foreground.Green
}

#import and use the preference file if found
$PreferencePath = Join-Path -Path $HOME -ChildPath ".psworkitempref.json"
If (Test-Path $PreferencePath) {
    $importPref = Get-Content $PreferencePath | ConvertFrom-Json
    $global:PSWorkItemPath = $importPref.Path
    $importPref.categories.foreach({$PSWorkItemCategory[$_.category]=$_.ansi})
}
else {
    #make this variable global instead of exporting so that I don't have to use Export-ModuleMember 7/28/2022 JDH
    $global:PSWorkItemPath = Join-Path -Path $HOME -ChildPath "PSWorkItem.db"
}

<#
Default categories when creating a new database file.
This will be a module-scoped variable, not exposed to the user
#>

$PSWorkItemDefaultCategories = "Work", "Personal", "Project", "Other"

Register-ArgumentCompleter -CommandName New-PSWorkItem, Get-PSWorkItem, Set-PSWorkItem, Get-PSWorkItemArchive,Remove-PSWorkItemArchive -ParameterName Category -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    #PowerShell code to populate $WordToComplete
    Get-PSWorkItemCategory | Where-Object { $_.category -Like "$wordToComplete*" } |
    Select-Object -Property Category, @{Name = "Description"; Expression = {
            $_.description -match "\w+" ? $_.description : "no description" }
    } |
    ForEach-Object {
        # completion text,ListItem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_.category, $_.category, 'ParameterValue', $_.description)
    }
}

#endregion