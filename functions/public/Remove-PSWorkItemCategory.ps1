Function Remove-PSWorkItemCategory {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "Specify the category name",
            ValueFromPipelineByPropertyName,
            ValueFromPipeline
            )]
        [ValidateNotNullOrEmpty()]
        [alias("Name")]
        [string[]]$Category,
        [Parameter(HelpMessage = "The path to the PSWorkitem SQLite database file. It should end in .db")]
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
        [string]$Path = $PSWorkItemPath
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Opening a connection to $Path"
        if ($script:conn.state -ne 'Open') {
            Try {
                $conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
                $conn | Out-String | Write-Verbose
            }
            Catch {
                Throw "Failed to open the database $Path"
            }
        }
    } #begin

    Process {
        if ($conn.state -eq 'open') {
            foreach ($item in $Category ) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing category $item "
                $query = "DELETE FROM categories WHERE category = '$item'"
                if ($pscmdlet.ShouldProcess($item)) {
                    Invoke-MySQLiteQuery -Query $query -Connection $conn -keepalive
                }
            }
        }
    } #process

    End {
        if ($conn.state -eq 'open') {
            Write-Verbose "[$((Get-Date).TimeofDay) END    ] Closing the connection to $Path"
            Close-MySQLiteDB -Connection $conn
        }
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

}
