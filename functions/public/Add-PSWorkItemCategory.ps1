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
        [String]$Path = $PSWorkItemPath,

        [Parameter(HelpMessage = "Force overwriting an existing category")]
        [Switch]$Force,

        [Switch]$PassThru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting"
        Write-Debug "Using bound parameters"
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
            Query       = ""
            ErrorAction = "Stop"
        }
    } #begin

    Process {
        if ($conn.state -eq "open") {
            foreach ($item in $category) {
                #test if the category already exists
                $splat.Query = "SELECT * FROM categories WHERE category = '$item' collate nocase"
                $test = Invoke-MySQLiteQuery @splat
                if ($test.category -eq $item -AND (-Not $Force)) {
                    Write-Warning "$($MyInvocation.MyCommand): The category $item already exists"
                    $ok = $false
                }
                elseif ($test.category -eq $item -AND $Force) {
                    Write-Verbose "$($MyInvocation.MyCommand): The category $item already exists and will be overwritten"
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
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Adding category $Item"
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
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Closing the connection to $Path"
        Close-MySQLiteDB -Connection $conn
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending"
    } #end
}
