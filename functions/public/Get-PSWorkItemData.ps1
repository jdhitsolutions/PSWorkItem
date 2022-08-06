
#Get raw table data
Function Get-PSWorkItemData {
    [cmdletbinding()]
    [OutputType("PSCustomObject")]
    Param(
        [Parameter(Position = 0,HelpMessage = "Specify the table name. The default is Tasks")]
        [ValidateSet("Tasks", "Categories", "Archive")]
        [string]$Table = "Tasks",

        [Parameter(HelpMessage = "The path to the PSWorkitem SQLite database file. It should end in .db")]
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
        [string]$Path = $PSWorkItemPath
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting"
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
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand):Getting raw table data for $Table from $Path "
        $splat.query = "Select *,RowID from $Table"
        Invoke-MySQLiteQuery @splat
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end

} #close Get-PSWorkItemData