
Get-Childitem $psscriptroot\functions\*.ps1 -recurse |
Foreach-Object {
. $_.FullName
}

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
    #this will be last resort GUID to ensure uniqueness
    hidden[guid]$TaskID = (New-Guid).Guid

    PSWorkItem ([string]$Name,[string]$Category) {
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
Update-TypeData -TypeName PSWorkitem -MemberType ScriptProperty -MemberName OverDue -Value {$this.DueDate  -le (Get-Date)} -Force
Update-TypeData -TypeName PSWorkItem -MemberType ScriptProperty -MemberName "TimeRemaining" -Value {New-Timespan -end $this.DueDate -start (Get-Date)} -force
Update-TypeData -TypeName PSWorkItemArchive -MemberType AliasProperty -MemberName "CompletedDate" -Value 'TaskModified' -force

#make this variable global instead of exporting so that I don't have to use Export-ModuleMember 7/28/2022 JDH
$global:PSWorkItemPath = Join-Path -path $HOME -childpath "PSWorkItem.db"

#this will be a module-scoped variable
$PSWorkItemDefaultCategories = "Work","Personal","Project","Other"

Register-ArgumentCompleter -CommandName New-PSWorkItem,Get-PSWorkItem,Set-PSWorkItem,Get-PSWorkItemArchive -ParameterName Category -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    #PowerShell code to populate $wordtoComplete
    Get-PSWorkItemCategory | Where-Object {$_.category -Like "$wordToComplete*"} |
    Select-Object -Property Category,@{Name="Description";Expression={
    $_.description -match "\w+" ? $_.description : "no description"}} |
    ForEach-Object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_.category, $_.category, 'ParameterValue', $_.description)
    }
}

<#

Export-ModuleMember -Variable PSWorkItemPath -alias 'gwi','nwi','swi' -Function 'Get-PSWorkItem','Set-PSWorkItem',
'Remove-PSWorkItem','Initialize-PSWorkItemDatabase','Complete-PSWorkItem','Get-PSWorkitemCategory',
'Get-PSWorkItemArchive','New-PSWorkItem','Remove-PSWorkItemCategory','Add-PSWorkItemCategory',
'Get-PSWorkItemDatabase'

#>