
Get-Childitem $psscriptroot\functions\*.ps1 -recurse |
Foreach-Object {
. $_.FullName
}

#define item class
class PSWorkItem {
    #this can be the ROWID of the item in the database
    [int]$ID
    [string]$Name
    [string]$Description
    [datetime]$DueDate
    [int]$Progress
    [datetime]$TaskCreated
    [datetime]$TaskModified
    [boolean]$Completed
    #this will be last resort GUID to ensure uniqueness
    hidden[guid]$TaskID
}

#Add a dynamic type extension to the PSWorkItem class
Add-PSTypeExtension -TypeName PSWorkitem -MemberType ScriptProperty -MemberName OverDue -Value {
    if ($this.DueDate -lt (Get-Date)) {
        return $false
    }
    return $True
}

$PSWorkItemPath = Join-Path -path $HOME -childpath "PSWorkItem.db"

Export-ModuleMember -Variable PSWorkItemPath -Function 'Get-PSWorkItem','Set-PSWorkItem',
'Remove-PSWorkItem','Initialize-PSWorkItemDatabase','Complete-PSWorkItem','Get-PSWorkitemCategory',
'Get-PSWorkItemArchive','New-PSWorkItem','Remove-PSWorkItemCategory'