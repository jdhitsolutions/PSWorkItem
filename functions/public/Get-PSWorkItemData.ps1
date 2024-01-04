
#Get raw table data
Function Get-PSWorkItemData {
    [cmdletbinding()]
    [OutputType("System.Data.DataTable")]
    Param(
        [Parameter(Position = 0,HelpMessage = "Specify the table name. The default is Tasks")]
        [ValidateSet("Tasks", "Categories", "Archive")]
        [String]$Table = "Tasks",

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
    Begin {
        StartTimer
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
        _verbose -message ($strings.UsingDB -f $path)
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug

        #parameters to splat to Invoke-MySqliteQuery
        $splat = @{
            Query       = ""
            Path        = $Path
            As          = "Datatable"
            ErrorAction = "Stop"
        }
    } #begin

    Process {
        _verbose -message ($strings.GetRaw -f $Table,$Path)
        $splat.query = "Select *,RowID from $Table"
        _verbose -message $splat.Query
        Invoke-MySQLiteQuery @splat
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end

} #close Get-PSWorkItemData