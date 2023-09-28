Function Open-PSWorkItemConsole {
    [cmdletbinding()]
    [Alias('wic')]
    [OutputType('None')]
    Param(
        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            {Test-Path $_},
            ErrorMessage = "Could not validate the database path."
        )]
        [String]$Path = $PSWorkItemPath
    )

    If ($host.name -ne 'ConsoleHost') {
        Write-Warning ($strings.InvalidHost -f $Host.Name)
        Return
    }

    #region initialize

    $scriptVer = (Get-Module PSWorkItem).version
    [Terminal.Gui.Application]::Init()
    [Terminal.Gui.Application]::QuitKey = 27

    $window = [Terminal.Gui.Window]@{
        Title = 'PSWorkItem Console'
    }

    #initialize an array to hold TUI controls
    $controls = @()

    #endregion

    #region status bar
    $StatusBar = [Terminal.Gui.StatusBar]::New(
        @(
            [Terminal.Gui.StatusItem]::New('Unknown', $(Get-Date -Format g), {}),
            [Terminal.Gui.StatusItem]::New('Unknown', 'ESC to quit or cancel', {}),
            [Terminal.Gui.StatusItem]::New('Unknown', "v$scriptVer", {}),
            [Terminal.Gui.StatusItem]::New('Unknown', 'Ready', {})
        )
    )

    [Terminal.Gui.Application]::Top.add($StatusBar)

    #endregion

    #region menu bar
    $MenuItem0 = [Terminal.Gui.MenuItem]::New('Clear Form', '', { ClearForm })
    $MenuItem0.ShortCut = [int][Terminal.Gui.Key]'CtrlMask' -bor [int][char]'X'

    $MenuItem1 = [Terminal.Gui.MenuItem]::New('Reset Form', '', { ResetForm })
    $MenuItem1.ShortCut = [int][Terminal.Gui.Key]'CtrlMask' -bor [int][char]'R'

    $MenuItem2 = [Terminal.Gui.MenuItem]::New('_Quit', '', { [Terminal.Gui.Application]::RequestStop() })
    $MenuItem2.ShortCut = [int][Terminal.Gui.Key]'CtrlMask' -bor [int][char]'Q'

    $MenuItem3 = [Terminal.Gui.MenuItem]::New('Open _Database', '', { OpenDatabase })
    $MenuItem3.ShortCut = [int][Terminal.Gui.Key]'CtrlMask' -bor [int][char]'D'
    $MenuBarItem0 = [Terminal.Gui.MenuBarItem]::New('_Options', @($MenuItem3, $MenuItem0, $MenuItem1, $MenuItem2))

    $MenuItem3 = [Terminal.Gui.MenuItem]::New('A_bout', '', { ShowAbout })
    $MenuItem4 = [Terminal.Gui.MenuItem]::New('Documentation', '', { ShowHelp })
    $MenuItem4.Shortcut = 'F1'
    $MenuItem5 = [Terminal.Gui.MenuItem]::New('Open Project Repository', '', { Start-Process 'https://github.com/jdhitsolutions/PSWorkItem' })
    $MenuItem6 = [Terminal.Gui.MenuItem]::New('File GitHub Issue', '', { Start-Process 'https://github.com/jdhitsolutions/PSWorkItem/issues/new/choose' })

    $MenuBarItem1 = [Terminal.Gui.MenuBarItem]::New('_Help', @($MenuItem4, $MenuItem5, $MenuItem6, $MenuItem3))

    $MenuBar = [Terminal.Gui.MenuBar]::New(@($MenuBarItem0, $MenuBarItem1))

    $Window.Add($MenuBar)

    #endregion

    #region main form
    $controls += $lblDescription = [Terminal.Gui.Label]@{
        Text    = 'Description:'
        X       = 1
        Y       = 4
        TabStop = $False
    }

    $controls += $txtDescription = [Terminal.Gui.TextField]@{
        X       = $lblDescription.Frame.Width + 2
        Width   = 40
        Y       = 4
        TabStop = $True
    }

    $controls += $chkClearDescription = [Terminal.Gui.CheckBox]@{
        Text    = "C_lear"
        X       = $txtDescription.X + $txtDescription.Frame.Width + 2
        Y       = 4
        TabStop = $False
        Visible = $False
    }

    $controls += $lblPath = [Terminal.Gui.Label]@{
        Text    = 'Database:'
        X       = 1
        Y       = 11
        TabStop = $false
    }

    $controls += $txtPath = [Terminal.Gui.TextField]@{
        X       = $lblDescription.Frame.Width + 2
        Width   = 40
        Y       = 11
        Text    = $Path
        TabStop = $True
    }

    $controls += $txtPath.Add_TextChanged({
        #don't refresh until the user finishes typing the path
        if ($txtPath.Text.ToString() -match '\.db$') {
            $chkFilterTable.Checked = $False
            ClearForm
            RefreshTable
            RefreshCategoryList
        }
    })

    $controls += $lblTaskName = [Terminal.Gui.Label]@{
        Text    = '*Name:'
        X       = 1
        Y       = 2
        TabStop = $False
    }

    $controls += $txtTaskName = [Terminal.Gui.TextField]@{
        X        = $lblDescription.Frame.Width + 2
        Width    = 31
        Y        = 2
        TabIndex = 0
        TabStop  = $True
    }

    $OverDueColor = [Terminal.Gui.ColorScheme]::new()
    $OverDueColor.Normal = [Terminal.Gui.Attribute]::new('BrightRed', 'Blue')
    $controls += $lblOverDue = [Terminal.Gui.Label]@{
        X           = $txtTaskName.Frame.Right + 2
        Width       = 10
        Y           = 2
        ColorScheme = $OverDueColor
        Text        = 'OverDue'
        Visible     = $False
        TabStop     = $False
        CanFocus    = $False
    }

    $controls += $lblCategory = [Terminal.Gui.Label]@{
        Text     = 'Category:'
        X        = $txtDescription.Frame.Right + 4
        Y        = $lblTaskName.Y
        TabStop  = $false
        CanFocus = $False
    }

    $controls += $dropCategory = [Terminal.Gui.ListView]@{
        Width                   = 15
        Height                  = 8
        X                       = $lblCategory.Frame.Right + 2
        Y                       = $lblCategory.Y
        TabIndex                = 1
        TabStop                 = $True
        AllowsMultipleSelection = $False
        CanFocus                = $True
    }

    $dropCategory.Add_SelectedItemChanged({
        if ($chkFilterTable.Checked) {
            RefreshTable -FilterCategory $script:CatList[$dropCategory.SelectedItem]
        }
    })

    $cs = [Terminal.Gui.ColorScheme]::new()
    $cs.Normal = [Terminal.Gui.Attribute]::new('White', 'Blue')

    $controls += $lblReport = [Terminal.Gui.Label]@{
        Width         = 29
        Height        = $dropCategory.Height
        TextAlignment = 'Center'
        X             = $dropCategory.Frame.right + 2
        Y             = $dropCategory.Y
        ColorScheme   = $cs
        Border        = [Terminal.Gui.Border]@{
            BorderStyle = 'Rounded'
            BorderBrush = 'Gray'
        }
        Text          = (Get-PSWorkItemReport -Path $txtPath.Text.ToString() | Format-Table Category, Count, PctTotal | Out-String).Trim()
        TabStop       = $False
        CanFocus      = $False
    }

    $controls += $chkWhatIf = [Terminal.Gui.CheckBox]@{
        Text = 'WhatIf'
        X    = 2
        Y    = 9
    }

    $controls += $radioGrp = [Terminal.Gui.RadioGroup]@{
        X            = 2
        Y            = $txtDescription.Y + 2
        Text         = 'Due Date'
        RadioLabels  = @('_Days Due', 'D_ue Date')
        SelectedItem = 0
        DisplayMode  = 'Vertical'
        TabStop      = $True
    }

    $radioGrp.Add_SelectedItemChanged({
        if ($radioGrp.SelectedItem -eq 0) {
            $txtDays.Enabled = $True
            $txtDueDate.Enabled = $False
        }
        else {
            $txtDays.Enabled = $False
            $txtDueDate.Enabled = $True
        }
    })

    $controls += $txtDays = [Terminal.Gui.TextField]@{
        Width   = 4
        Text    = 30
        Y       = $txtDescription.Y + 2
        X       = $radioGrp.Frame.Width + 2
        TabStop = $True
    }

    $controls += $txtDueDate = [Terminal.Gui.TextField]@{
        Width   = 20
        Y       = $txtDescription.Y + 3
        X       = $radioGrp.Frame.Width + 2
        Enabled = $False
        TabStop = $True
    }

    $controls += $lblProgress = [Terminal.Gui.Label]@{
        Text     = 'Progress:'
        X        = $txtDueDate.Frame.Right + 4
        Y        = $txtDays.Y
        TabStop  = $false
        CanFocus = $False
    }

    $controls += $txtProgress = [Terminal.Gui.TextField]@{
        Width   = 5
        Y       = $txtDays.Y
        X       = $lblProgress.Frame.Right + 2
        TabStop = $False
    }

    $controls += $chkFilterTable = [Terminal.Gui.CheckBox]@{
        X       = $TxtPath.X + $txtPath.Frame.Width+ 2
        Y       = $txtPath.Y
        Text    = 'Filter table'
        TabStop = $False
    }

    $chkFilterTable.Add_Toggled({
        if ($chkFilterTable.Checked) {
            RefreshTable -FilterCategory $script:CatList[$dropCategory.SelectedItem]
        }
        else {
            RefreshTable
        }
    })

    #endregion

    #region buttons
    $controls += $btnAdd = [Terminal.Gui.Button]@{
        X       = 1
        Y       = $txtPath.Y + 2
        Text    = '_Add New PSWorkItem'
        TabStop = $True
    }

    $btnAdd.Add_Clicked({
            if ($txtTaskName.Text.ToString() -match '\w+') {
                if ($chkWhatIf.Checked) {
                    ShowWhatIf -Command New
                    Return
                }
                $r = @{
                    Name        = $txtTaskName.Text.ToString()
                    Category    = $script:CatList[$dropCategory.SelectedItem]
                    Path        = $txtPath.Text.ToString()
                    ErrorAction = 'Stop'
                }
                if ($txtDescription.text.ToString() -match '\w+') {
                    $r.Add('Description', $txtDescription.text.ToString())
                }

                if ($txtDays.Enabled) {
                    $r.Add('DaysDue', $txtDays.Text.ToString())
                }
                else {
                    $r.Add('DueDate', $txtDueDate.Text.ToString())
                }

                $StatusBar.Items[3].Title = "Creating PSWorkItem $($txtTaskName.Text.ToString()) in $($r.Path)"
                $StatusBar.SetChildNeedsDisplay()
                [Terminal.Gui.Application]::Refresh()
                Start-Sleep -Milliseconds 1000
                Try {
                    New-PSWorkItem @r
                    ClearForm
                    RefreshTable
                    [Terminal.Gui.Application]::Refresh()
                }
                Catch {
                    [Terminal.Gui.MessageBox]::ErrorQuery('Error', $_.Exception.Message)
                }
            }
            else {
                $StatusBar.Items[3].Title = 'Oops! You forgot to specify a name for your PSWorkItem.'
                $StatusBar.SetChildNeedsDisplay()
                [Terminal.Gui.Application]::Refresh()
                Start-Sleep -Milliseconds 2000
                $StatusBar.Items[3].Title = 'Ready'
                [Terminal.Gui.Application]::Refresh()
            }
        })

    $controls += $btnSet = [Terminal.Gui.Button]@{
        X    = $btnAdd.Frame.Width + 2
        Y    = $txtPath.Y + 2
        Text = '_Set PSWorkItem'
    }

    $btnSet.Add_Clicked({
        if ($txtTaskName.Text.ToString() -match '\w+') {
            if ($chkWhatIf.Checked -AND $chkClearDescription.Checked) {
                #save the current description
                $SavedDescription = $txtDescription.Text.ToString()
                #clear the field for the ShowWhatIt function
                $txtDescription.Text=''
                [Terminal.Gui.Application]::Refresh()
                ShowWhatIf -command Set -id $TableView.table.rows[$TableView.SelectedRow].ID
                #reset the text field
                $txtDescription.Text = $SavedDescription
                [Terminal.Gui.Application]::Refresh()
                Return
            }
            elseif ($chkWhatIf.Checked) {
                ShowWhatIf -command Set -id $TableView.table.rows[$TableView.SelectedRow].ID
                Return
            }

            if ($chkClearDescription.Checked) {
                $r = @{
                    ID                   = $TableView.table.rows[$TableView.SelectedRow].ID
                    Path                 = $txtPath.Text.ToString()
                    ClearDescription     = $True
                    ErrorAction          = 'Stop'
                }
            }
            else {
                $r = @{
                    ID          = $TableView.table.rows[$TableView.SelectedRow].ID
                    Name        = $txtTaskName.Text.ToString()
                    Category    = $script:CatList[$dropCategory.SelectedItem]
                    Path        = $txtPath.Text.ToString()
                    ErrorAction = 'Stop'
                }
                if ($txtDescription.text.ToString() -match '\w+') {
                    $r.Add('Description', $txtDescription.text.ToString())
                }
                if ($txtProgress.text.ToString() -match '\d') {
                    $r.Add('Progress', $txtProgress.text.ToString())
                }
                if ($txtDays.Enabled) {
                    #calculate Date
                    $due = (Get-Date).AddDays( $txtDays.Text.ToString())
                    $r.Add('DueDate', $due)
                }
                else {
                    $r.Add('DueDate', $txtDueDate.Text.ToString())
                }
            } #else normal set
            $StatusBar.Items[3].Title = "Updating PSWorkItem $($r.ID) in $($r.Path)"
            $StatusBar.SetChildNeedsDisplay()
            [Terminal.Gui.Application]::Refresh()
            Start-Sleep -Milliseconds 1000
            Try {
                Set-PSWorkItem @r
                Populate
                RefreshTable
                $StatusBar.Items[3].Title = "Ready"
                $StatusBar.SetChildNeedsDisplay()
                [Terminal.Gui.Application]::Refresh()
            }
            Catch {
                [Terminal.Gui.MessageBox]::ErrorQuery('Error', $_.Exception.Message)
            }
        }
        else {
            $StatusBar.Items[3].Title = 'Oops! You forgot to specify a name for your PSWorkItem'
            $StatusBar.SetChildNeedsDisplay()
            [Terminal.Gui.Application]::Refresh()
            Start-Sleep -Milliseconds 2000
            $StatusBar.Items[3].Title = 'Ready'
            [Terminal.Gui.Application]::Refresh()
        }
    })

    $controls += $btnComplete = [Terminal.Gui.Button]@{
        X       = $btnSet.Frame.Width + 25
        Y       = $txtPath.Y + 2
        Text    = '_Complete PSWorkItem'
        TabStop = $True
    }

    $btnComplete.Add_Clicked({
        if ($txtTaskName.Text.ToString() -match '\w+') {
            if ($chkWhatIf.Checked) {
                ShowWhatIf -Command Complete -id $TableView.table.rows[$TableView.SelectedRow].ID
                Return
            }
            $r = @{
                ID          = $TableView.table.rows[$TableView.SelectedRow].ID
                Path        = $txtPath.Text.ToString()
                ErrorAction = 'Stop'
            }

            $StatusBar.Items[3].Title = "Completing PSWorkItem $($r.ID) in $($r.Path)"
            $StatusBar.SetChildNeedsDisplay()
            [Terminal.Gui.Application]::Refresh()
            Start-Sleep -Milliseconds 1000

            Try {
                Complete-PSWorkItem @r
                ClearForm
                RefreshTable
                [Terminal.Gui.Application]::Refresh()
            }
            Catch {
                [Terminal.Gui.MessageBox]::ErrorQuery('Error', $_.Exception.Message)
            }
        }
        else {
            $StatusBar.Items[3].Title = 'No PSWorkItem selected'
            $StatusBar.SetChildNeedsDisplay()
            [Terminal.Gui.Application]::Refresh()
            Start-Sleep -Milliseconds 2000
            $StatusBar.Items[3].Title = 'Ready'
            [Terminal.Gui.Application]::Refresh()
        }
    })

    $controls += $btnRemove = [Terminal.Gui.Button]@{
        X       = $btnComplete.Frame.Width + 44
        Y       = $txtPath.Y + 2
        Text    = '_Remove PSWorkItem'
        TabStop = $True
    }

    $btnRemove.Add_Clicked({
        if ($txtTaskName.Text.ToString() -match '\w+') {
            if ($chkWhatIf.Checked) {
                ShowWhatIf -Command Remove -id $TableView.table.rows[$TableView.SelectedRow].ID
                Return
            }
            $r = @{
                ID          = $TableView.table.rows[$TableView.SelectedRow].ID
                Path        = $txtPath.Text.ToString()
                ErrorAction = 'Stop'
            }
            if ($chkWhatIf.Checked) {
                $r.Add('WhatIf', $True)
            }

            $StatusBar.Items[3].Title = "Removing PSWorkItem $($r.ID) in $($r.Path)"
            $StatusBar.SetChildNeedsDisplay()
            [Terminal.Gui.Application]::Refresh()
            Start-Sleep -Milliseconds 1000

            Try {
                Remove-PSWorkItem @r
            }
            Catch {
                [Terminal.Gui.MessageBox]::ErrorQuery('Error', $_.Exception.Message)
            }
            ClearForm
            RefreshTable
            [Terminal.Gui.Application]::Refresh()
        }
        else {
            $StatusBar.Items[3].Title = 'No PSWorkItem selected'
            $StatusBar.SetChildNeedsDisplay()
            [Terminal.Gui.Application]::Refresh()
            Start-Sleep -Milliseconds 2000
            $StatusBar.Items[3].Title = 'Ready'
            [Terminal.Gui.Application]::Refresh()
        }
    })

    #endregion

    #region table view
    #add a table showing work items
    $controls += $TableView = [Terminal.Gui.TableView]@{
        X             = 0
        Y             = $btnAdd.Y + 2
        Width         = [Terminal.Gui.Dim]::Fill()
        Height        = [Terminal.Gui.Dim]::Fill()
        AutoSize      = $False
        TabStop       = $False
        MultiSelect   = $False
        FullRowSelect = $True
        TextAlignment = 'Center'
    }
    #Keep table headers always in view
    $TableView.Style.AlwaysShowHeaders = $True
    $TableView.Style.ShowHorizontalHeaderOverline = $False
    $TableView.Style.ShowHorizontalHeaderUnderline = $True
    $TableView.Style.ShowVerticalHeaderLines = $False

    #event handler
    $TableView.Add_SelectedCellChanged({Populate})

    $window.Add($TableView)

    #endregion

    #region execute
    #add the controls to the main window
    $controls.foreach({ $window.Add($_) })

    [Terminal.Gui.Application]::Top.Add($window)
    #set tab order
    $txtTaskName.TabIndex = 0
    $dropCategory.TabIndex = 1
    $txtDescription.TabIndex = 2
    $txtDays.TabIndex = 3
    $radioGrp.TabIndex = 4
    $txtDueDate.TabIndex = 5
    $chkWhatIf.TabIndex = 6
    $btnAdd.TabIndex = 7
    $btnSet.TabIndex = 8
    $btnComplete.TabIndex = 9
    $btnRemove.TabIndex = 10

    #refresh data
    RefreshTable
    RefreshCategoryList
    $txtTaskName.SetFocus()
    #set a timer to update the status bar every 15 seconds
    $TimerToken = [Terminal.Gui.Application]::MainLoop.AddTimeout((New-TimeSpan -Seconds 15), { UpdateStatusTime })

    [Terminal.Gui.Application]::Run()
    [Terminal.Gui.Application]::ShutDown()

    #endregion

} #end function