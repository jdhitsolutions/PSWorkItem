Function Initialize-PSWorkItemDatabase {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None","PSWorkItemDatabase")]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "The path to the PSWorkItem SQLite database file. It should end in .db")]
        [ValidatePattern("\.db$")]
        [ValidateScript(
            {
                $parent = Split-Path -Path $_ -Parent
                Test-Path $parent
            },
            ErrorMessage = "Failed to validate the parent path."
        )]
        [String]$Path = $PSWorkItemPath,
        [Switch]$PassThru,
        [Parameter(HelpMessage = "Force overwriting an existing file.")]
        [Switch]$Force
    )
    Begin {
        StartTimer
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingModule -f (Get-Command -name $MyInvocation.MyCommand).Version)
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        _verbose -message ($strings.InitializingDB -f $Path)
        Try {
            #using -f to accommodate culture with date times
            $comment = "PSWorkItem database created {0}." -f (Get-Date)
            $db = New-MySQLiteDB -Path $Path -PassThru -force:$Force -comment $comment -ErrorAction stop
        }
        Catch {
            Throw $_
        }
        if ($db) {
            _verbose -message $strings.AddTables
            $props = [ordered]@{
                taskid       = "text"
                taskcreated  = "text"
                taskmodified = "text"
                name         = "text"
                description  = "text"
                duedate      = "text"
                category     = "text"
                progress     = "integer"
                completed    = "integer"
                id           = "integer"
            }

            _verbose -message $strings.AddTasks
            New-MySQLiteDBTable -Path $Path -TableName tasks -ColumnProperties $props -Force:$Force

            _verbose -message $strings.AddArchive
            New-MySQLiteDBTable -Path $Path -TableName archive -ColumnProperties $props -force:$Force

            _verbose -message $strings.AddCategories
            $props = [ordered]@{
                category = "text"
                description = "text"
            }
            New-MySQLiteDBTable -Path $Path -TableName categories -ColumnProperties $props -force:$force
            _verbose -message ($strings.AddDefaultCategories -f $($script:PSWorkItemDefaultCategories -join ','))
            #give the database a chance to close
            Start-Sleep -milliseconds 500
            Add-PSWorkItemCategory -Path $Path -Category $script:PSWorkItemDefaultCategories -Force
            if ($PassThru) {
                Get-mySQLiteTable -Path $Path -Detail
            }
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end
}
