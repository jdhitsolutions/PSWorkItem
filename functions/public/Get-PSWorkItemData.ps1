
#Get raw table data
Function Get-PSWorkItemData {
    [cmdletbinding()]
    [OutputType("PSCustomObject")]
    Param(
        [Parameter(Position = 0,HelpMessage = "Specify the table name. The default is Tasks")]
        [ValidateSet("Tasks", "Categories", "Archive")]
        [String]$Table = "Tasks",

        [Parameter(HelpMessage = "The path to the PSWorkItem SQLite database file. It should end in .db")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\.db$")]
        [ValidateScript({
            if (Test-Path $_) {
                Return $True
            }
            else {
                Throw "Failed to validate $_"
                Return $False
            }
        })]
        [String]$Path = $PSWorkItemPath
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting"
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug

        #parameters to splat to Invoke-MySqliteQuery
        $splat = @{
            Query       = ""
            Path        = $Path
            As          = "Object"
            ErrorAction = "Stop"
        }
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand):Getting raw table data for $Table from $Path "
        $splat.query = "Select *,RowID from $Table"
        Invoke-MySQLiteQuery @splat
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending"
    } #end

} #close Get-PSWorkItemData