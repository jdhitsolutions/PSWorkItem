Function Add-PSWorkItemCategory {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None","PSWorkItemCategory")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Specify the category name",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [alias("Name")]
        [string[]]$Category,

        [Parameter(
            Position = 1,
            HelpMessage = "Specify a category comment or description",
            ValueFromPipelineByPropertyName
        )]
        [String]$Description,

        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            {Test-Path $_},
            ErrorMessage = "Could not validate the database path."
        )]
        [String]$Path = $PSWorkItemPath,

        [Parameter(HelpMessage = "Force overwriting an existing category")]
        [Switch]$Force,

        [Switch]$PassThru
    )
    Begin {
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingDB -f $path)
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug

        _verbose -message $strings.OpenDBConnection
        Try {
            $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
            $conn | Out-String | Write-Debug
        }
        Catch {
            Throw "$($MyInvocation.MyCommand): $($strings.FailToOpen -f $Path)"
        }

        #parameters to splat to Invoke-MySQLiteQuery
        $splat = @{
            Connection  = $conn
            KeepAlive   = $true
            Query       = ""
            ErrorAction = "Stop"
        }
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        if ($conn.state -eq "open") {
            foreach ($item in $category) {
                #test if the category already exists
                $splat.Query = "SELECT * FROM categories WHERE category = '$item' collate nocase"
                $test = Invoke-MySQLiteQuery @splat
                if ($test.category -eq $item -AND (-Not $Force)) {
                    Write-Warning "$($MyInvocation.MyCommand): $($strings.CategoryExists -f $item)"
                    $ok = $false
                }
                elseif ($test.category -eq $item -AND $Force) {
                    _verbose -message ($strings.CategoryExistsOverwrite -f $item)
                    $splat.Query = "DELETE FROM categories WHERE category = '$item' collate nocase"
                    if ($PSCmdlet.ShouldProcess($item, "Remove category")) {
                        Invoke-MySQLiteQuery @splat
                        $ok = $true
                    }
                }
                else {
                    $ok = $True
                }

                Write-Debug "$($MyInvocation.MyCommand): Connection state is $($conn.state)"
                if ($ok) {
                    _verbose -message ($strings.AddCategory -f $Item)
                    $splat.query = "INSERT INTO categories (category,description) VALUES ('$item','$Description')"
                    If ($PSCmdlet.ShouldProcess($item)) {
                        Invoke-MySQLiteQuery @splat
                        if ($PassThru) {
                            $splat.query = "Select * from categories where category = '$item' collate nocase"
                            Invoke-MySQLiteQuery @splat | ForEach-Object {
                                [PSWorkItemCategory]::New($_.category, $_.Description)
                            }
                        } #PassThru
                    } #WhatIf
                } #if OK
            } #foreach item
        } #if $conn
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        _verbose -message ($strings.CloseDBConnection -f $path)
        Close-MySQLiteDB -Connection $conn
        _verbose -message $strings.Ending
    } #end
}
