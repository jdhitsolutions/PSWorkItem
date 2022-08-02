#private helper functions

function _newWorkItem {
    [cmdletbinding()]
    Param([object]$data)

    $item = [psworkitem]::new($data.name,$data.category)
    $item.ID = $data.RowID
    $item.Description = $data.description
    $item.DueDate = $data.duedate
    $item.progress = $data.progress
    $item.taskcreated = $data.TaskCreated
    $item.taskmodified = $data.TaskModified
    $item.Completed = $data.completed
    $item.taskId = $data.TaskId

    $item
}

<#
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
#>