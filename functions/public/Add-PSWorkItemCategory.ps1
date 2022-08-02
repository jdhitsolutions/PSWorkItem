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
        [string]$Description,

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
        [string]$Path = $PSWorkItemPath,

        [Parameter(HelpMessage = "Force overwriting an existing category")]
        [switch]$Force,

        [switch]$Passthru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting"
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug

        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Opening a connection to $Path"
        Try {
            $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
            $conn | Out-String | Write-Debug

        }
        Catch {
            Throw "$($myinvocation.mycommand): Failed to open the database $Path"
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
        if ($conn.state -eq "open") {
            foreach ($item in $category) {
                #test if the category already exists
                $splat.Query = "SELECT * FROM categories WHERE category = '$item'"
                $test = Invoke-MySQLiteQuery @splat
                if ($test.category -eq $item -AND (-Not $Force)) {
                    Write-Warning "$($myinvocation.mycommand): The category $Category already exists"
                    $ok = $false
                }
                elseif ($test.category -eq $item -AND $Force) {
                    Write-Verbose "$($myinvocation.mycommand): The category $Category already exists and will be overwritten"
                    $splat.Query = "DELETE FROM categories WHERE category = '$item'"
                    if ($Pscmdlet.ShouldProcess($item, "Remove category")) {
                        Invoke-MySQLiteQuery @splat
                        $ok = $true
                    }
                }
                else {
                    $ok = $True
                }

                Write-Debug "$($myinvocation.mycommand): Connection state is $($conn.state)"
                if ($ok) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Adding category $Item"
                    $splat.query = "INSERT INTO categories (category,description) VALUES ('$item','$Description')"
                    If ($pscmdlet.ShouldProcess($item)) {
                        Invoke-MySQLiteQuery @splat
                        if ($Passthru) {
                            $splat.query = "Select * from categories where category = '$item'"
                            Invoke-MySQLiteQuery @splat | ForEach-Object {
                                [PSWorkItemCategory]::New($_.category, $_.Description)
                            }
                        } #passthru
                    } #Whatif
                } #if OK

            } #foreach item
        } #if $conn
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Closing the connection to $Path"
        Close-MySQLiteDB -Connection $conn
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end
}
