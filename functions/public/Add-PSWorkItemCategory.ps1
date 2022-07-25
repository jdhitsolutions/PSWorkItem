Function Add-PSWorkItemCategory {
    [cmdletbinding(SupportsShouldProcess,DefaultParameterSetName = "file")]
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
        [alias("description")]
        [string]$Comment,

        [Parameter(HelpMessage = "The path to the PSWorkitem SQLite database file. It should end in .db",ParameterSetName="file")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\.db$")]
        [ValidateScript({
                $parent = Split-Path -Path $_ -Parent
                if (Test-Path $parent) {
                    Return $True
                }
                else {
                    Throw "Failed to validate the parent path $parent."
                    Return $False
                }
            })]
        [string]$Path = $PSWorkItemPath,

        [Parameter(HelpMessage = "Specify an existing database connection",ParameterSetName="connection")]
        [System.Data.SQLite.SQLiteConnection]$Connection,

        [Parameter(HelpMessage = "Force overwriting an existing category")]
        [switch]$Force,

        [switch]$Passthru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting"
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug

        if ($pscmdlet.ParameterSetName -eq 'file') {

            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Opening a connection to $Path"
            Try {
                $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
                $conn | Out-String | Write-Debug

        }
        Catch {
            Throw "$($myinvocation.mycommand): Failed to open the database $Path"
        }
    }
    else {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Using an existing connection"
        $conn = $Connection
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
                    if ($Pscmdlet.ShouldProcess($item,"Remove category")) {
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
                    $splat.query = "INSERT INTO categories (category,comment) VALUES ('$item','$comment')"
                    If ($pscmdlet.ShouldProcess($item)) {
                        Invoke-MySQLiteQuery @splat
                        if ($Passthru) {
                            $splat.query = "Select * from categories where category = '$item'"
                            Invoke-MySQLiteQuery @splat | ForEach-Object {
                                [PSWorkItemCategory]::New($_.category, $_.comment)
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
