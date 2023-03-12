Function Initialize-PSWorkItemDatabase {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None","PSWorkItemDatabase")]
    Param(
        [Parameter(Position = 0, HelpMessage = "The path to the PSWorkItem SQLite database file. It should end in .db")]
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
        [String]$Path = $PSWorkItemPath,
        [Switch]$PassThru,
        [Parameter(HelpMessage = "Force overwriting an existing file.")]
        [Switch]$Force
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] $($MyInvocation.MyCommand): Starting"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Initializing PSWorkItem database $Path "
        Try {
            #using -f to accommodate culture with datetimes
            $comment = "PSWorkItem database created {0}." -f (Get-Date)
            $db = New-MySQLiteDB -Path $Path -PassThru -force:$Force -comment $comment -ErrorAction stop
        }
        Catch {
            Throw $_
        }
        if ($db) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Adding tables"
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

            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): ...tasks"
            New-MySQLiteDBTable -Path $Path -TableName tasks -ColumnProperties $props -Force:$Force

            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): ...archive"
            New-MySQLiteDBTable -Path $Path -TableName archive -ColumnProperties $props -force:$Force

            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): ...categories"
            $props = [ordered]@{
                category = "text"
                description = "text"
            }
            New-MySQLiteDBTable -Path $Path -TableName categories -ColumnProperties $props -force:$force
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($MyInvocation.MyCommand): Adding default categories $($PSWorkItemDefaultCategories -join ',')"
            #give the database a chance to close
            Start-Sleep -milliseconds 500
            Add-PSWorkItemCategory -Path $Path -Category $PSWorkItemDefaultCategories -Force
            if ($PassThru) {
                Get-mySQLiteTable -Path $Path -Detail
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] $($MyInvocation.MyCommand): Ending"
    } #end

}
