Function Get-PSWorkitemCategory {
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
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting"
        Write-Debug "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Debug
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Opening a connection to $Path"
        Try {
            <#
            Save the connection to a script-scoped variable so that if this command is piped
            to another command like Remove-PSWorkItemCategory, the open connection will be
            reused.
            #>
            $script:conn = Open-MySQLiteDB -Path $Path -ErrorAction Stop
            $script:conn | Out-String | Write-Debug
            #parameters to splat to Invoke-MySQLiteQuery
            $splat = @{
                connection  = $script:conn
                KeepAlive   = $true
                Query       = ""
                As          = "Object"
                ErrorAction = "Stop"
            }
        }
        Catch {
            Throw "$($myinvocation.mycommand): Failed to open the database $Path"
        }
    } #begin

    Process {
        if ($script:conn.State -eq 'open') {
            if ($Category -eq "*") {
                $splat.Query = "SELECT * FROM categories"
                $data = Invoke-MySQLiteQuery @splat
            }
            else {
                Foreach ($item in $Category) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Getting category $item"
                    $splat.Query = "SELECT * FROM categories WHERE category = '$item'"
                    $data = Invoke-MySQLiteQuery @splat

                }
            }
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Found $($data.count) categories"
            foreach ($cat in $data) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Creating category object for $($cat.category)"
                [PSWorkItemCategory]::New($cat.category, $cat.comment)
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Closing the connection to $Path"
        <#
        There is a chance that subsequent commands might still need the connection.
        #>
        Close-MySQLiteDB -Connection $script:conn
        Write-Debug "connection state is $($script:conn.state)"
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end

}
