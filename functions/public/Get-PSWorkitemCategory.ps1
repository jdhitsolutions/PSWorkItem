Function Get-PSWorkItemCategory {
    [cmdletbinding()]
    [OutputType("PSWorkItemCategory")]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "Specify the category name",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [alias("Name")]
        [string[]]$Category = "*",

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
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        # Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): $($strings.Starting)"
        #_verbose -block begin -message $strings.testing
        _verbose -message $strings.Starting
        _verbose -message ($strings.UsingDB -f $path)
        # Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting"
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug

        $splat = @{
            Query     = ""
            Path      = $Path
            As        = "Object"
        }
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        if ($Category -eq "*") {
            #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Getting all categories"
            _verbose -message $strings.GetAllCategories
            $splat.Query = "SELECT * FROM categories"
            $data = Invoke-MySQLiteQuery @splat
        }
        else {
            Foreach ($item in $Category) {
                #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Getting category $item"
                _verbose -message ($strings.GetCategory -f $item)
                #make a case-insensitive query
                $splat.Query = "SELECT * FROM categories WHERE category = '$item' collate nocase"
                $data = Invoke-MySQLiteQuery @splat
            }
        }
        #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Found $($data.count) categories"
        _verbose -message ($strings.FoundCategories -f $data.count)
        foreach ($cat in $data) {
            #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Creating category object for $($cat.category)"
            _verbose -message ($strings.CreateCategory -f $cat.category)
            [PSWorkItemCategory]::New($cat.category, $cat.description)
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        _verbose -message $strings.Ending
        #Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending"
    } #end
}
