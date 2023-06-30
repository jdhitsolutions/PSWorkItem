Function Set-PSWorkItemCategory {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None', 'PSWorkItemCategory')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'Specify a case-sensitive category name.'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string]$Category,

        [Parameter(
            HelpMessage = 'Specify a category comment or description.'
        )]
        [String]$Description,

        [Parameter(HelpMessage = 'Specify a new name for the category. This is case-sensitive. Be careful renaming a category with active tasks using the old category name.')]
        [ValidateNotNullOrEmpty()]
        [string]$NewName,

        [Parameter(HelpMessage = 'The path to the PSWorkItem SQLite database file. It should end in .db')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('\.db$')]
        [ValidateScript({
                if (Test-Path $_) {
                    Return $True
                }
                else {
                    Throw "Failed to validate $_"
                    Return $False
                }
            })]
        [String]$Path = $PSWorkItemPath,
        [switch]$PassThru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        if ((-Not $PSBoundParameters.ContainsKey('Description')) -AND (-Not $PSBoundParameters.ContainsKey('NewName'))) {
            Write-Warning 'You must specify either a description or a new name'
            Return
        }
        Write-Debug 'Using bound parameters'
        $PSBoundParameters | Out-String | Write-Debug

        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Opening a connection to $Path"
        Try {
            $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
            $conn | Out-String | Write-Debug

        }
        Catch {
            Throw "$($MyInvocation.MyCommand): Failed to open the database $Path"
        }

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection  = $conn
            KeepAlive   = $true
            Query       = ''
            ErrorAction = 'Stop'
        }

        $BaseQuery = 'Update categories set '
    } #begin

    Process {

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $Category"
        if ($conn.state -eq 'open') {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Validating category $category"
            $splat.query = "SELECT * FROM categories WHERE category = '$Category' collate nocase"
            Try {
                $cat = Invoke-MySQLiteQuery @splat
            }
            Catch {
                Write-Warning "Failed to execute query $($splat.query)"
                Close-MySQLiteDB -Connection $conn
                Throw $_
            }
            if ($cat.category -eq $Category) {
                #update the category
                # -Query "Update categories set description = 'work stuff',category='newname' Where category='work' collate nocase"
                $updates = @{
                    Description = $Description
                    Category    = $NewName
                }
                $updates.GetEnumerator() | Where-Object { $_.value } | ForEach-Object -Begin { $set = @() } -Process {
                    $set += "$($_.key) = '$($_.value)'" }-End { $BaseQuery += ($set -join ', ')
                }

                $BaseQuery += " WHERE category = '$category' collate nocase"
                $splat.query = $BaseQuery
                if ($PSCmdlet.ShouldProcess($BaseQuery)) {
                    Invoke-MySQLiteQuery @splat
                    if ($PassThru) {
                        if ($NewName) {
                            Get-PSWorkItemCategory -Category $NewName -Path $Path
                        }
                        else {
                            Get-PSWorkItemCategory -Category $Category -Path $Path
                        }
                    }
                }

            } #If category found
        } #IF connection open
        else {
            Write-Warning "$($MyInvocation.MyCommand): The database connection is not open"
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Closing the connection to $Path"
        if ($conn.state -eq 'open') {
            Close-MySQLiteDB -Connection $conn
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Set-PSWorkItemCategory