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
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
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
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function ResetForm {
    [CmdletBinding()]
    Param( )
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
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
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function ShowHelp {
    [CmdletBinding()]
    Param()

    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"

    $title = 'Open-PSWorkItemConsole'
    $getHelp = Get-Help Open-PSWorkItemConsole
    #(Get-Help Open-PSWorkItemConsole).Description.Text | Out-String
    #$(($getHelp.Description.Text | Out-String).Trim())
    #$(($getHelp.AlertSet.Alert | Out-String).Trim())
    $help = @"

  This command will launch a terminal-based console for managing
  PSWorkItems. You can select items from the table which will
  populate the entry forms. You can then modify the work item and
  click Set-PSWorkItem, or you can mark the item as complete or
  remove it. To enter a new PSWorkItem, use Options - Clear Form.
  Enter your new item, selecting a category from the list, and
  click the Add New PSWorkItem button. You cannot set a progress
  value when creating a new work item. Use the category menu options
  to add, set, or remove a category.

  You can right-click a task in the table to show detailed information.

  You can also enter a different database path by entering the path in
  the Database field, or using Options - Open database. Use the
  Reset Form option to reset the form with your default settings.

  You cannot specify a PSWorkItem completion date using this tool.

  If you have difficulty seeing the cursor in text fields, and you are
  running in Windows Terminal, you might try changing the cursor in
  your Windows Terminal profile setting. The TUI color scheme is
  also influenced by the Windows Terminal color scheme. You may also
  have to adjust the zoom level in Windows Terminal to see the entire
  form.

"@
    $dialog = [Terminal.Gui.Dialog]@{
        Title         = 'Help Open-PSWorkItemConsole'
        TextAlignment = 'Left'
        Width         = 75
        Height        = 30
        Text          = $help
    }
    $ok = [Terminal.Gui.Button]@{
        Text = 'OK'
    }
    $ok.Add_Clicked({ $dialog.RequestStop() })
    $dialog.AddButton($ok)
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Invoking dialog"
    [Terminal.Gui.Application]::Run($dialog)
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function RefreshTable {
    [CmdletBinding()]
    Param(
        [string]$FilterCategory = '*'
    )
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
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
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function RefreshCategoryList {
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
    $src = (Get-PSWorkItemCategory -Path $txtPath.Text.ToString()).Category | Sort-Object
    $src | Write-Verbose
    $dropCategory.Clear()
    $dropCategory.SetSource($src)
    $dropCategory.SetNeedsDisplay()
    [Terminal.Gui.Application]::Refresh()
    $dropCategory.SelectedItem = 0
    #create a lookup list
    $script:CatList = [System.Collections.Generic.List[string]]::New()
    $script:CatList.AddRange([string[]]$src)
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function UpdateReport {
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
    $lblReport.Text = (Get-PSWorkItemReport -Path $txtPath.Text.ToString() |
    Format-Table Category, Count, PctTotal | Out-String).Trim()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function ShowWhatIf {
    Param(
        [ValidateSet('New', 'Set', 'Complete', 'Remove')]
        [string]$Command,
        [string]$ID
    )
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
    Switch ($command) {
        'New' {
            $cmd = 'New-PSWorkItem'
            $cat = $dropCategory.Source.ToList()[$dropCategory.SelectedItem]
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
            $cat = $dropCategory.Source.ToList()[$dropCategory.SelectedItem]
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

    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Show message box"
    [Terminal.Gui.MessageBox]::Query('WhatIf Operation', $msg, @('Ok'))
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function OpenDatabase {
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
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
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
}

Function ShowAbout {
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
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
Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Show message box"
    [Terminal.Gui.MessageBox]::Query('About Open-PSWorkItemConsole', $About, @('Ok'))
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function UpdateStatusTime {
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
    $StatusBar.Items[0].Title = Get-Date -Format g

    [Terminal.Gui.Application]::Refresh()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
    #need to return a Boolean result
    Return $True
}

Function Populate {
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
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
    If ($item.Description -match '\w+') {
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
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function AddCategory {
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
    $cs = [Terminal.Gui.ColorScheme]::New()
    $cs.Normal = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::Black, [Terminal.Gui.Color]::Gray)
    $cs.Focus = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::White, [Terminal.Gui.Color]::DarkGray)
    $cs.HotNormal = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::BrightBlue, [Terminal.Gui.Color]::Gray)
    $subWin = [Terminal.Gui.Dialog]@{
        Title       = 'Add Category'
        X           = [Terminal.Gui.Pos]::Center()
        Y           = [Terminal.Gui.Pos]::Center()
        Width       = 50
        Height      = 10
        ColorScheme = $cs
    }

    $lblCategory = [Terminal.Gui.Label]@{
        X       = 1
        Y       = 1
        Width   = 10
        Height  = 1
        Text    = 'New Category'
        TabStop = $False
    }

    $txtCategory = [Terminal.Gui.TextField]@{
        X      = $lblCategory.Frame.Width + 3
        Y      = 1
        Width  = 30
        Height = 1
    }
    $lblDescription = [Terminal.Gui.Label]@{
        X       = 1
        Y       = 3
        Width   = 10
        Height  = 1
        Text    = 'Description'
        TabStop = $False
    }
    $txtDescription = [Terminal.Gui.TextField]@{
        X      = $txtCategory.X
        Y      = 3
        Width  = 30
        Height = 1
    }

    $chkWhatIf = [Terminal.Gui.CheckBox]@{
        X      = 1
        Y      = 5
        Width  = 10
        Height = 1
        Text   = 'WhatIf'
    }
    $chkForce = [Terminal.Gui.CheckBox]@{
        X      = 1
        Y      = 6
        Width  = 10
        Height = 1
        Text   = 'Force'
    }
    $btnOk = [Terminal.Gui.Button]@{
        X      = 13
        Y      = 6
        Width  = 10
        Height = 1
        Text   = 'Ok'
    }
    $btnOK.Add_Clicked({
            if ($txtCategory.Text.ToString() -match '\w+') {
                if ($chkWhatIf.Checked) {
                    $msg = @"

Category = $($txtCategory.Text.ToString())
Description = $($txtDescription.Text.ToString())
Force = $($chkForce.Checked)
Path = $($txtPath.Text.ToString())
"@
                    [Terminal.Gui.MessageBox]::Query('Add-PSWorkitemCategory -WhatIf', $msg, @('Ok'))
                }
                else {
                    $splat = @{
                        Category        = $txtCategory.Text.ToString()
                        Path            = $txtPath.Text.ToString()
                        ErrorAction     = 'Stop'
                        WarningVariable = 'warn'
                    }
                    if ($chkForce.Checked) {
                        $splat['Force'] = $True
                    }
                    if ($txtDescription.Text.ToString() -match '\w+') {
                        $splat['Description'] = $txtDescription.Text.ToString()
                    }
                    Try {
                        Add-PSWorkItemCategory @splat
                        if ($warn) {
                            [Terminal.Gui.MessageBox]::ErrorQuery('Warning', $warn.message)
                        }
                        else {
                            RefreshCategoryList
                            UpdateStatusTime
                            $subWin.RequestStop()
                        }
                    }
                    Catch {
                        [Terminal.Gui.MessageBox]::ErrorQuery('Error', $_.Exception.Message)
                    }
                }
            }
            else {
                [Terminal.Gui.MessageBox]::ErrorQuery('Add-PSWorkitemCategory', 'A category name is required', @('Ok'))
            }

        })
    $btnCancel = [Terminal.Gui.Button]@{
        X      = 23
        Y      = 6
        Width  = 10
        Height = 1
        Text   = 'Cancel'
    }
    $btnCancel.Add_Clicked({
            UpdateStatusTime
            $subWin.RequestStop()
        })

    $subWin.Add($chkWhatIf)
    $subWin.Add($chkForce)
    $subWin.Add($lblDescription)
    $subWin.Add($txtDescription)
    $subWin.Add($lblCategory)
    $subWin.Add($txtCategory)
    $subWin.Add($btnCancel)
    $subWin.Add($btnOk)
    #set tab order
    $txtCategory.TabIndex = 0
    $txtDescription.TabIndex = 1
    $chkWhatIf.TabIndex = 2
    $chkForce.TabIndex = 3
    $btnOk.TabIndex = 4
    $btnCancel.TabIndex = 5
    $txtCategory.SetFocus()

    [Terminal.Gui.Application]::Run($subWin)
    [Terminal.Gui.Application]::Refresh()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function RemoveCategory {
    [CmdletBinding()]
    Param()

    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"
    $cs = [Terminal.Gui.ColorScheme]::New()
    $cs.Normal = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::Black, [Terminal.Gui.Color]::Gray)
    $cs.Focus = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::White, [Terminal.Gui.Color]::DarkGray)
    $cs.HotNormal = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::BrightBlue, [Terminal.Gui.Color]::Gray)
    $subWin = [Terminal.Gui.Dialog]@{
        Title       = 'Remove Category'
        X           = [Terminal.Gui.Pos]::Center()
        Y           = [Terminal.Gui.Pos]::Center()
        Width       = 50
        Height      = 10
        ColorScheme = $cs
    }

    $lblCategory = [Terminal.Gui.Label]@{
        X       = 1
        Y       = 1
        Width   = 10
        Height  = 1
        Text    = 'Category'
        TabStop = $False
    }

    $subDropCategory = [Terminal.Gui.ListView]@{
        Width                   = 25
        Height                  = 1
        X                       = $lblCategory.Frame.Width + 3
        Y                       = $lblCategory.Y
        TabIndex                = 1
        TabStop                 = $True
        AllowsMultipleSelection = $False
        CanFocus                = $True
    }

    $chkWhatIf = [Terminal.Gui.CheckBox]@{
        X      = 1
        Y      = 3
        Width  = 10
        Height = 1
        Text   = 'WhatIf'
    }
    $btnOk = [Terminal.Gui.Button]@{
        X      = 13
        Y      = 4
        Width  = 10
        Height = 1
        Text   = 'Ok'
    }
    $btnOK.Add_Clicked({
        if ($subDropCategory.Source.ToList()[$subDropCategory.SelectedItem] -match '\w+') {

            if ($chkWhatIf.Checked) {
                $msg = @"

Category = $($subDropCategory.Source.ToList()[$subDropCategory.SelectedItem])

Path = $($txtPath.Text.ToString())
"@
                [Terminal.Gui.MessageBox]::Query('Remove-PSWorkitemCategory -WhatIf', $msg, @('Ok'))
            }
            else {
                $splat = @{
                    Category        = $subDropCategory.Source.ToList()[$subDropCategory.SelectedItem]
                    Path            = $txtPath.Text.ToString()
                    ErrorAction     = 'Stop'
                    WarningVariable = 'warn'
                }

                Try {
                    Remove-PSWorkItemCategory @splat
                    if ($warn) {
                        [Terminal.Gui.MessageBox]::ErrorQuery('Warning', $warn.message)
                    }
                    else {
                        Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Removed category successfully"
                        #refresh the main form list
                        RefreshCategoryList
                        UpdateStatusTime
                        $subWin.RequestStop()
                    }

                }
                Catch {
                    [Terminal.Gui.MessageBox]::ErrorQuery('Error', $_.Exception.Message)
                }
            }
        }
        else {
            [Terminal.Gui.MessageBox]::ErrorQuery('Remove-PSWorkitemCategory', 'A category name is required', @('Ok'))
        }
    })
    $btnCancel = [Terminal.Gui.Button]@{
        X      = 23
        Y      = 4
        Width  = 10
        Height = 1
        Text   = 'Cancel'
    }
    $btnCancel.Add_Clicked({
            UpdateStatusTime
            $subWin.RequestStop()
        })

    $subWin.Add($chkWhatIf)
    $subWin.Add($lblCategory)
    $subWin.Add($subDropCategory)
    $subWin.Add($btnCancel)
    $subWin.Add($btnOk)
    #set tab order
    $subDropCategory.TabIndex = 0
    $chkWhatIf.TabIndex = 1
    $btnOk.TabIndex = 2
    $btnCancel.TabIndex = 3
    $dropCategory.SetFocus()
    #populate drop down list
    $src = (Get-PSWorkItemCategory -Path $txtPath.Text.ToString()).Category | Sort-Object
    $subDropCategory.SetSource($src)
    $subDropCategory.SetNeedsDisplay()
    $subDropCategory.SelectedItem = 0

    [Terminal.Gui.Application]::Run($subWin)

    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function SetCategory {
    [CmdletBinding()]
    Param()

    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"

    #cache current categories
    $catHash = Get-PSWorkItemCategory -Path $txtPath.Text.ToString() | Group-Object -Property Category -AsHashTable -AsString

    $cs = [Terminal.Gui.ColorScheme]::New()
    $cs.Normal = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::Black, [Terminal.Gui.Color]::Gray)
    $cs.Focus = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::White, [Terminal.Gui.Color]::DarkGray)
    $cs.HotNormal = [Terminal.Gui.Attribute]::New([Terminal.Gui.Color]::BrightBlue, [Terminal.Gui.Color]::Gray)
    $subWin = [Terminal.Gui.Dialog]@{
        Title       = 'Set Category'
        X           = [Terminal.Gui.Pos]::Center()
        Y           = [Terminal.Gui.Pos]::Center()
        Width       = 50
        Height      = 10
        ColorScheme = $cs
    }

    $lblCategory = [Terminal.Gui.Label]@{
        X       = 1
        Y       = 1
        Width   = 10
        Height  = 1
        Text    = 'Category'
        TabStop = $False
    }

    $subDropCategory = [Terminal.Gui.ListView]@{
        Width                   = 25
        Height                  = 1
        X                       = $lblCategory.Frame.Width + 3
        Y                       = $lblCategory.Y
        TabIndex                = 1
        TabStop                 = $True
        AllowsMultipleSelection = $False
        CanFocus                = $True
    }

    $subDropCategory.Add_SelectedItemChanged({
        $cat = $subDropCategory.Source.ToList()[$subDropCategory.SelectedItem]
        $txtDescription.Text = $catHash[$cat].Description
    })

    $lblDescription = [Terminal.Gui.Label]@{
        X       = 1
        Y       = 3
        Width   = 10
        Height  = 1
        Text    = 'Description'
        TabStop = $False
    }
    $txtDescription = [Terminal.Gui.TextField]@{
        X      = $lblDescription.Frame.Width +2
        Y      = 3
        Width  = 30
        Height = 1
    }

    $lblNewName = [Terminal.Gui.Label]@{
        X       = 1
        Y       = 5
        Width   = 10
        Height  = 1
        Text    = 'New name'
        TabStop = $False
    }
    $txtNewName = [Terminal.Gui.TextField]@{
        X      = $lblNewName.Frame.Width +3
        Y      = 5
        Width  = 30
        Height = 1
    }

    $chkWhatIf = [Terminal.Gui.CheckBox]@{
        X      = 1
        Y      = 7
        Width  = 10
        Height = 1
        Text   = 'WhatIf'
    }
    $btnOk = [Terminal.Gui.Button]@{
        X      = 13
        Y      = $chkWhatIf.Y
        Width  = 10
        Height = 1
        Text   = 'Ok'
    }
    $btnOK.Add_Clicked({
        if ($subDropCategory.Source.ToList()[$subDropCategory.SelectedItem] -match '\w+') {
            if ($chkWhatIf.Checked) {
                $msg = @"

Category = $($subDropCategory.Source.ToList()[$subDropCategory.SelectedItem])
Description = $($txtDescription.Text.ToString())
New Name = $($txtNewName.Text.ToString())
Path = $($txtPath.Text.ToString())
"@
                [Terminal.Gui.MessageBox]::Query('Set-PSWorkItemCategory -WhatIf', $msg, @('Ok'))
            }
            else {
                $splat = @{
                    Category        = $subDropCategory.Source.ToList()[$subDropCategory.SelectedItem]
                    Path            = $txtPath.Text.ToString()
                    ErrorAction     = 'Stop'
                    WarningVariable = 'warn'
                }
                if ($txtNewName.Text.ToString() -match "\w+") {
                    $splat.Add("NewName",$txtNewName.Text.ToString())
                }
                if ($txtDescription.Text.ToString() -match "\w+") {
                    $splat.Add("Description",$txtDescription.Text.ToString())
                }

                Try {
                $splat | out-string | out-file c:\temp\v.txt
                    Set-PSWorkItemCategory @splat -verbose 4>>c:\temp\v.txt
                    if ($warn) {
                        [Terminal.Gui.MessageBox]::ErrorQuery('Warning', $warn.message)
                    }
                    else {
                        Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Changed category successfully"
                        #refresh the main form list
                        RefreshCategoryList
                        UpdateStatusTime
                        $subWin.RequestStop()
                    }
                }
                Catch {
                    [Terminal.Gui.MessageBox]::ErrorQuery('Error', $_.Exception.Message)
                }
            }
        }
        else {
            [Terminal.Gui.MessageBox]::ErrorQuery('Remove-PSWorkitemCategory', 'A category name is required', @('Ok'))
        }
    })
    $btnCancel = [Terminal.Gui.Button]@{
        X      = 23
        Y      = $btnOk.Y
        Width  = 10
        Height = 1
        Text   = 'Cancel'
    }
    $btnCancel.Add_Clicked({
            UpdateStatusTime
            $subWin.RequestStop()
        })

    $subWin.Add($chkWhatIf)
    $subWin.Add($lblDescription)
    $subWin.Add($txtDescription)
    $subWin.Add($lblCategory)
    $subWin.Add($subDropCategory)
    $subWin.Add($lblNewName)
    $subWin.add($txtNewName)
    $subWin.Add($btnCancel)
    $subWin.Add($btnOk)
    #set tab order
    $subDropCategory.TabIndex = 0
    $txtDescription.TabIndex = 1
    $txtNewName.TabIndex = 2
    $chkWhatIf.TabIndex = 3
    $btnOk.TabIndex = 4
    $btnCancel.TabIndex = 5
    $dropCategory.SetFocus()
    #populate drop down list
    $src = (Get-PSWorkItemCategory -Path $txtPath.Text.ToString()).Category | Sort-Object
    $subDropCategory.SetSource($src)
    $subDropCategory.SetNeedsDisplay()
    $subDropCategory.SelectedItem = 0

    [Terminal.Gui.Application]::Run($subWin)

    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}

Function ShowDatabaseDetail {
    [CmdletBinding()]
    Param()
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Starting $($MyInvocation.MyCommand)"

    $info = Get-PSWorkItemDatabase -Path $txtPath.Text.ToString() | Format-List | Out-String

    $dialog = [Terminal.Gui.Dialog]@{
        Title         = 'PSWorkItem Database Details'
        TextAlignment = 'Left'
        Width         = 50
        Height        = 20
        Text          = $info
    }
    $ok = [Terminal.Gui.Button]@{
        Text = 'OK'
    }
    $ok.Add_Clicked({ $dialog.RequestStop() })
    $dialog.AddButton($ok)
    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Invoking dialog"
    [Terminal.Gui.Application]::Run($dialog)

    Write-Verbose "[$((Get-Date).TimeOfDay) PRIVATE] Ending $($MyInvocation.MyCommand)"
}