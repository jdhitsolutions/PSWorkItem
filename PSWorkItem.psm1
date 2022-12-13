
# used for culture debugging
# write-host "Importing with culture $(Get-Culture)"

Get-ChildItem $psscriptroot\functions\*.ps1 -Recurse |
ForEach-Object {
    . $_.FullName
}

#region class definitions
#define item class
class PSWorkItem {
    #this can be the ROWID of the item in the database
    [int]$ID
    [string]$Name
    [string]$Category
    [string]$Description
    [datetime]$DueDate = (Get-Date).AddDays(30)
    [int]$Progress = 0
    [datetime]$TaskCreated = (Get-Date)
    [datetime]$TaskModified = (Get-Date)
    [boolean]$Completed
    [string]$Path
    #this will be last resort GUID to ensure uniqueness
    hidden[guid]$TaskID = (New-Guid).Guid

    PSWorkItem ([string]$Name, [string]$Category) {
        $this.Name = $Name
        $this.Category = $Category
    }
}

class PSWorkItemCategory {
    [string]$Category
    [string]$Description

    #constructor
    PSWorkItemCategory([string]$Category, [string]$Description) {
        $this.Category = $Category
        $this.Description = $Description
    }
}

class PSWorkItemDatabase {
    [string]$Path
    [datetime]$Created
    [datetime]$LastModified
    [int32]$Size
    [int32]$TaskCount
    [int32]$CategoryCount
    [int32]$ArchiveCount
    [string]$Encoding
    [int32]$PageCount
    [int32]$PageSize
}

#Add a dynamic type extension to the PSWorkItem class
Update-TypeData -TypeName PSWorkitem -MemberType ScriptProperty -MemberName OverDue -Value { $this.DueDate -le (Get-Date) } -Force
Update-TypeData -TypeName PSWorkItem -MemberType ScriptProperty -MemberName "TimeRemaining" -Value { New-TimeSpan -End $this.DueDate -Start (Get-Date) } -Force
Update-TypeData -TypeName PSWorkItemArchive -MemberType AliasProperty -MemberName "CompletedDate" -Value 'TaskModified' -Force

#endregion

#make this variable global instead of exporting so that I don't have to use Export-ModuleMember 7/28/2022 JDH
$global:PSWorkItemPath = Join-Path -Path $HOME -ChildPath "PSWorkItem.db"


<#
Default categories when creating a new database file.
This will be a module-scoped variable
#>

$PSWorkItemDefaultCategories = "Work", "Personal", "Project", "Other"

#a global hashtable used for formatting PSWorkItems
$global:PSWorkItemCategory = @{
    "Work"     = $PSStyle.Foreground.Cyan
    "Personal" = $PSStyle.Foreground.Green
}

Register-ArgumentCompleter -CommandName New-PSWorkItem, Get-PSWorkItem, Set-PSWorkItem, Get-PSWorkItemArchive -ParameterName Category -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    #PowerShell code to populate $wordtoComplete
    Get-PSWorkItemCategory | Where-Object { $_.category -Like "$wordToComplete*" } |
    Select-Object -Property Category, @{Name = "Description"; Expression = {
            $_.description -match "\w+" ? $_.description : "no description" }
    } |
    ForEach-Object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_.category, $_.category, 'ParameterValue', $_.description)
    }
}
