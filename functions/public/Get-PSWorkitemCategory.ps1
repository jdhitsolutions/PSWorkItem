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

        $splat = @{
            Query     = ""
            Path      = $Path
            As        = "Object"
        }
    } #begin

    Process {
        if ($Category -eq "*") {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Getting all categories"
            $splat.Query = "SELECT * FROM categories"
            $data = Invoke-MySQLiteQuery @splat
        }
        else {
            Foreach ($item in $Category) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Getting category $item"
                #make a case-insensitive query
                $splat.Query = "SELECT * FROM categories WHERE category = '$item' collate nocase"
                $data = Invoke-MySQLiteQuery @splat
            }
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Found $($data.count) categories"
        foreach ($cat in $data) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Creating category object for $($cat.category)"
            [PSWorkItemCategory]::New($cat.category, $cat.description)
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end

}
