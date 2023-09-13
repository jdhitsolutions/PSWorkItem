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
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        # Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): $($strings.Starting)"
        #_verbose -block begin -message $strings.testing
        _verbose -message $strings.Starting
        _verbose -message ($strings.UsingDB -f $path)
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Getting database information from $Path"
        # Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($strings.getData) from $Path"
        _verbose -message ($strings.GetData -f $Path)
        Try {
            $db = Get-MySQLiteDB -Path $Path -ErrorAction Stop
        }
        Catch {
            Throw $_
        }
        if ($db) {
            #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($strings.OpenDBConnection)"
            _verbose -message $strings.OpenDBConnection
            $conn = Open-MySQLiteDB -Path $path
            #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($strings.TaskCount)"
            _verbose -message $strings.TaskCount
            $tasks = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from tasks" -ErrorAction Stop
            #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($strings.ArchiveCount)"
            _verbose -message $strings.ArchiveCount
            $archived = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from archive" -ErrorAction Stop
            #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($strings.CategoryCount)"
            _verbose -message $strings.CategoryCount
            $categories = Invoke-MySQLiteQuery -Connection $conn -KeepAlive -Query "Select Count() from categories" -ErrorAction Stop
            #Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): $($strings.CloseDBConnection)"
            _verbose -message $strings.CloseDBConnection
            Close-MySQLiteDB -Connection $conn

            #create a new PSWorkItemDatabase object from the class definition
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
        #write the object to the pipeline
        $out
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        _verbose -message $strings.Ending
        #Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): $($strings.Ending)"
    } #end

} #close Get-PSWorkItemDatabase