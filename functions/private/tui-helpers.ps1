#helper functions for Open-PSWorkItemConsole

Function ConvertTo-DataTable {
    [cmdletbinding()]
    [OutputType('System.Data.DataTable')]
    [alias('alias')]
    Param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        $data = [System.Collections.Generic.List[object]]::New()
        $Table = [System.Data.DataTable]::New('PSData')
    } #begin

    Process {
        $Data.Add($InputObject)
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Building a table of $($data.count) items"
        #define columns
        foreach ($item in $data[0].PSObject.Properties) {
            Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Defining column $($item.name)"
            [void]$table.Columns.Add($item.Name, $item.TypeNameOfValue)
        }
        #add rows
        for ($i = 0; $i -lt $Data.count; $i++) {
            $row = $table.NewRow()
            foreach ($item in $Data[$i].PSObject.Properties) {
                $row.Item($item.name) = $item.Value
            }
            [void]$table.Rows.Add($row)
        }
        #This is a trick to return the table object
        #as the output and not the rows
        , $table
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close ConvertTo-DataTable

Function ClearForm {
    #clear entry forms but leave category and path
    Param()

    $txtTaskName.Text = ''
    $txtDescription.Text = ''
    $chkWhatIf.Checked = $False
    $txtProgress.Text = ''
    $dropCategory.SelectedItem = 0
    $txtDays.Text = 30
    $txtDueDate.Text = ''
    $radioGrp.SelectedItem = 0
    $lblOverDue.Visible = $False
    $StatusBar.Items[0].Title = Get-Date -Format g
    $StatusBar.Items[3].Title = 'Ready'
    $txtTaskName.SetFocus()
    [Terminal.Gui.Application]::Refresh()
}

Function ResetForm {
    Param( )
    $txtTaskName.Text = ''
    $txtDescription.Text = ''
    $chkWhatIf.Checked = $False
    $txtProgress.Text = ''
    $dropCategory.SelectedItem = 0
    $txtDays.Text = 30
    $txtDueDate.Text = ''
    $radioGrp.SelectedItem = 0
    $lblOverDue.Visible = $False
    $StatusBar.Items[3].Title = Get-Date -Format g
    $StatusBar.Items[3].Title = 'Ready'
    $chkFilterTable.Checked = $False
    $txtTaskName.SetFocus()
    $txtPath.Text = $PSWorkItemPath

    RefreshCategoryList
    RefreshTable
    [Terminal.Gui.Application]::Refresh()
}

Function ShowHelp {
    Param()
    $title = 'Open-PSWorkItemConsole'
    $help = (Get-Help Open-PSWorkItemConsole).Description.Text | Out-String

    $dialog = [Terminal.Gui.Dialog]@{
        Title ='Help Open-PSWorkItemConsole'
        TextAlignment = "Left"
        Width = 75
        Height = 20
        Text = $help
    }
    $ok = [Terminal.Gui.Button]@{
        Text="OK"
    }
    $ok.Add_Clicked({$dialog.RequestStop()})
    $dialog.AddButton($ok)

    [Terminal.Gui.Application]::Run($dialog)
}
Function RefreshTable {
    Param(
        [string]$FilterCategory = '*'
    )
    $TableView.RemoveAll()
    $TableView.Clear()
    $Data = Get-PSWorkItem -Path $txtPath.Text.ToString() -All | Where-Object { $_.Category -Like $FilterCategory } |
    Select-Object ID, Name, Description, DueDate, Progress, Category, OverDue |
    ConvertTo-DataTable
    $TableView.Table = $Data
    $TableView.Style.ColumnStyles.Add(
        $TableView.Table.Columns['ID'],
        [Terminal.Gui.TableView+ColumnStyle]@{
            Alignment = 'Right'
            MinWidth  = 4
        }
    )

    $TableView.Style.ColumnStyles.Add(
        $TableView.Table.Columns['Progress'],
        [Terminal.Gui.TableView+ColumnStyle]@{
            Alignment = 'Right'
        }
    )

    $TableView.Style.ColumnStyles.Add(
        $TableView.Table.Columns['DueDate'],
        [Terminal.Gui.TableView+ColumnStyle]@{
            Alignment = 'Justified'
            MinWidth  = 22
        }
    )

    $TableView.SetNeedsDisplay()
}

Function RefreshCategoryList {
    Param()

    $src = (Get-PSWorkItemCategory -Path $txtPath.Text.ToString()).Category | Sort-Object
    $dropCategory.SetSource($src)
    #create a lookup list
    $script:CatList = [System.Collections.Generic.List[string]]::New()
    $script:CatList.AddRange([string[]]$src)
    $lblReport.Text = (Get-PSWorkItemReport -Path $txtPath.Text.ToString() | Format-Table Category, Count, PctTotal | Out-String).Trim()

}

Function ShowWhatIf {
    Param(
        [ValidateSet('New', 'Set', 'Complete', 'Remove')]
        [string]$Command,
        [string]$ID
    )

    Switch ($command) {
        'New' {
            $cmd = 'New-PSWorkItem'
            $cat = $script:CatList[$dropCategory.SelectedItem]
            if ($txtDays.Enabled) {
                #calculate Date
                $due = (Get-Date).AddDays( $txtDays.Text.ToString())
            }
            else {
                $due = $txtDueDate.Text.ToString()
            }
            $msg = @"
$cmd

PSWorkItem: {0} [{1}]
Description: {3}
Due: {4}
Using database: {2}
"@ -f $txtTaskName.Text.ToString(), $cat, $txtPath.Text.ToString(), $txtDescription.Text.ToString(), $due
        }
        'Set' {
            $cmd = 'Set-PSWorkItem'
            $cat = $script:CatList[$dropCategory.SelectedItem]
            if ($txtDays.Enabled) {
                #calculate Date
                $due = (Get-Date).AddDays( $txtDays.Text.ToString())
            }
            else {
                $due = $txtDueDate.Text.ToString()
            }
            $msg = @"
$cmd

ID : $ID
PSWorkItem: {0} [{1}]
Description: {3}
Progress: {5}
Due: {4}
Using database: {2}
"@ -f $txtTaskName.Text.ToString(), $cat, $txtPath.Text.ToString(), $txtDescription.Text.ToString(), $due, $txtProgress.Text.ToString()
        }
        'Complete' {
            $cmd = 'Complete-PSWorkItem'
            $msg = @"
$cmd

PSWorkItem    : {0} [ID {1}]
Using database: {2}
"@ -f $txtTaskName.Text.ToString(), $ID, $txtPath.Text.ToString()
        }
        'Remove' {
            $cmd = 'Remove-PSWorkItem'
            $msg = @"
$cmd

PSWorkItem    : {0} [ID {1}]
Using database: {2}
"@ -f $txtTaskName.Text.ToString(), $ID, $txtPath.Text.ToString()
        }
    } #switch

    [Terminal.Gui.MessageBox]::Query('WhatIf Operation', $msg, @('Ok'))

}

Function OpenDatabase {
    Param()

    $Dialog = [Terminal.Gui.OpenDialog]::new('Open PSWorkItem Database', '')
    $Dialog.CanChooseDirectories = $false
    $Dialog.CanChooseFiles = $true
    $Dialog.AllowsMultipleSelection = $false

    $Dialog.DirectoryPath = $HOME
    $Dialog.AllowedFileTypes = @('.db')
    [Terminal.Gui.Application]::Run($Dialog)
    If (-Not $Dialog.Canceled -AND $dialog.FilePath.ToString()) {
        $txtPath.Text = $dialog.FilePath.ToString()
        RefreshCategoryList
        RefreshTable
    }
}
Function ShowAbout {
    Param()
    $TerminalGuiVersion = [System.Reflection.Assembly]::GetAssembly([Terminal.Gui.Application]).GetName().version
    $NStackVersion = [System.Reflection.Assembly]::GetAssembly([NStack.UString]).GetName().version
    $SQLiteVersion = [System.Reflection.Assembly]::GetAssembly([System.Data.Sqlite.SqLiteConnection]).GetName().version

    $about = @"

PSWorkItem $scriptVer
PSVersion $($PSVersionTable.PSVersion)
Terminal.Gui $TerminalGuiVersion
NStack $NStackVersion
System.Data.SQLite $SQLiteVersion
"@

[Terminal.Gui.MessageBox]::Query('About Open-PSWorkItemConsole', $About, @('Ok'))

}

Function UpdateStatusTime {
    Param()
    $StatusBar.Items[0].Title = Get-Date -Format g
    [Terminal.Gui.Application]::Refresh()
    #need to return a Boolean result
    Return $True
}

Function Populate {
    Param()
     <# sample
        $TableView.table.rows[$TableView.SelectedRow]

        ID          : 21
        Name        : Blog updates
        Description : update pages
        DueDate     : 1/15/2023 5:00:00 PM
        Progress    : 0
        Category    : Blog
        #>
        $item = $TableView.table.rows[$TableView.SelectedRow]
        if ($item.Overdue) {
            $lblOverDue.Visible = $True
        }
        else {
            $lblOverDue.Visible = $False
        }
        If ($item.Description -match "\w+") {
            $chkClearDescription.Visible = $True
        }
        else {
            $chkClearDescription.Visible = $False
        }
        $txtTaskName.Text = $item.Name
        $txtDueDate.Text = '{0:g}' -f $item.DueDate
        $radioGrp.SelectedItem = 1
        $txtDays.Enabled = $False
        $txtDescription.Text = $item.Description
        $dropCategory.SelectedItem = $script:CatList.FindIndex({ $args -eq $item.Category })
        $txtProgress.Text = $item.Progress

}