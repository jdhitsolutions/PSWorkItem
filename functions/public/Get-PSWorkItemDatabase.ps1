Function Get-PSWorkItemDatabase {
    [cmdletbinding()]
    [OutputType("PSWorkItemDatabase")]
    Param(
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
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting "
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Getting database information from $Path"

        Try {
            $db = Get-MySQLiteDB -Path $Path -ErrorAction Stop
        }
        Catch {
            Throw $_
        }
        if ($db) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Opening a database connection"
            $conn = Open-MySQLiteDB -Path $path
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Getting task count"
            $tasks = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from tasks" -ErrorAction Stop
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Getting archive count"
            $archived = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from archive" -ErrorAction Stop
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Getting category count"
            $categories = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from categories" -ErrorAction Stop
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Closing the database connection"
            Close-MySQLiteDB -Connection $conn

            #create a new PSWorkItemDatabase object
            $out = [PSWorkitemDatabase]::new()
            #define properties
            $out.Path = $db.Path
            $out.Created = $db.Created
            $out.LastModified = $db.Modified
            $out.size = $db.Size
            $out.taskcount = $tasks.'Count()'
            $out.archivecount = $archived.'Count()'
            $out.categorycount = $categories.'Count()'
            $out.encoding = $db.Encoding
            $out.PageCount = $db.PageCount
            $out.PageSize = $db.PageSize
        }
        $out
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end

} #close Get-PSWorkItemDatabase