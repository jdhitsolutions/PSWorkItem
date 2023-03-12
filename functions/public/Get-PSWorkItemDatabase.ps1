Function Get-PSWorkItemDatabase {
    [cmdletbinding()]
    [OutputType("PSWorkItemDatabase")]
    Param(
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
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting "
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Getting database information from $Path"

        Try {
            $db = Get-MySQLiteDB -Path $Path -ErrorAction Stop
        }
        Catch {
            Throw $_
        }
        if ($db) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Opening a database connection"
            $conn = Open-MySQLiteDB -Path $path
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Getting task count"
            $tasks = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from tasks" -ErrorAction Stop
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Getting archive count"
            $archived = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from archive" -ErrorAction Stop
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Getting category count"
            $categories = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from categories" -ErrorAction Stop
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Closing the database connection"
            Close-MySQLiteDB -Connection $conn

            #create a new PSWorkItemDatabase object
            $out = [PSWorkItemDatabase]::new()
            #define properties
            $out.Path = $db.Path
            $out.Created = $db.Created
            $out.LastModified = $db.Modified
            $out.size = $db.Size
            $out.TaskCount = $tasks.'Count()'
            $out.ArchiveCount = $archived.'Count()'
            $out.CategoryCount = $categories.'Count()'
            $out.encoding = $db.Encoding
            $out.PageCount = $db.PageCount
            $out.PageSize = $db.PageSize
        }
        $out
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending"
    } #end

} #close Get-PSWorkItemDatabase