Function Initialize-PSWorkItemDatabase {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position = 0, HelpMessage = "The path to the PSWorkitem SQLite database file. It should end in .db")]
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
        [switch]$Passthru,
        [Parameter(HelpMessage = "Force overwriting an existing file.")]
        [switch]$Force
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] $($myinvocation.mycommand): Starting"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Initializing PSWorkItem database $Path "
        Try {
            $db = New-MySQLiteDB -Path $Path -Passthru -force:$Force -comment "PSWorkItem database created $(Get-Date)." -ErrorAction stop
        }
        Catch {
            Throw $_
        }
        if ($db) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Adding tables"
            $props = [ordered]@{
                taskid       = "text"
                taskcreated  = "text"
                taskmodified = "text"
                name         = "text"
                description   = "text"
                duedate      = "text"
                category     = "text"
                progress     = "integer"
                completed    = "integer"
            }

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): ...tasks"
            New-MySQLiteDBTable -Path $Path -TableName tasks -ColumnProperties $props -Force:$Force
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): ...archive"
            New-MySQLiteDBTable -Path $Path -TableName archive -ColumnProperties $props -force:$Force

            $props = [ordered]@{
                category = "text"
                description = "text"
            }
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): ...categories"
            New-MySQLiteDBTable -Path $Path -TableName categories -ColumnProperties $props -force:$force
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($myinvocation.mycommand): Adding default categories $($PSWorkItemDefaultCategories -join ',')"
            #give the database a chance to close
            Start-Sleep -milliseconds 500
            Add-PSWorkItemCategory -Path $Path -Category $PSWorkItemDefaultCategories -Force
            if ($passthru) {
                Get-mySQLiteTable -Path $Path -Detail
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] $($myinvocation.mycommand): Ending"
    } #end

}
