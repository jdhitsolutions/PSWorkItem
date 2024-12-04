Function Get-PSWorkItemReport {
    [cmdletbinding()]
    [OutputType("PSWorkItemReport")]
    Param(
        [Parameter(
            HelpMessage = 'The path to the PSWorkItem SQLite database file. It must end in .db'
        )]
        [ValidatePattern('\.db$')]
        [ValidateScript(
            {Test-Path $_},
            ErrorMessage = "Could not validate the database path."
        )]
        [String]$Path = $PSWorkItemPath
    )
    Begin {
        StartTimer
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        if ($MyInvocation.CommandOrigin -eq 'Runspace') {
            #Hide this metadata when the command is called from another command
            _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
            _verbose -message ($strings.UsingHost -f $host.Name)
            _verbose -message ($strings.UsingOS -f $PSVersionTable.OS)
            _verbose -message ($strings.UsingModule -f $ModuleVersion)
            _verbose -message ($strings.UsingDB -f $path)
            _verbose ($strings.DetectedCulture -f (Get-Culture))
        }
    } #begin

    Process {
        $PSDefaultParameterValues["_verbose:block"] = "Process"
        _verbose -message ($strings.GetReport -f $Path)
        Get-PSWorkItem -Path $Path -All -OutVariable all |
        Group-Object category -NoElement |
        Sort-Object count, name -Descending | ForEach-Object {
            [PSCustomObject]@{
                PSTypeName = "PSWorkItemReport"
                Count      = $_.Count
                Category   = $_.Name
                PctTotal   = ($_.count / $all.count) * 100 -as [int]
                Path       = $Path
            }
        } #Foreach-Object

        #add Overdue
        [PSCustomObject]@{
            PSTypeName = "PSWorkItemReport"
            Count      = $all.Where({ $_.overdue }).count
            Category   = "Overdue"
            PctTotal   = ($all.Where({ $_.overdue }).count / $all.count) * 100 -as [int]
            Path       = $Path
        }
    } #process

    End {
        $PSDefaultParameterValues["_verbose:block"] = "End"
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        _verbose -message $strings.Ending -command $myInvocation.MyCommand
        _verbose -message ($strings.RunTime -f (StopTimer))
    } #end

} #close Get-PSWorkItemReport

<#
$report = Get-PSWorkItem -all -OutVariable all |
Group-Object category |
Sort-Object count,name -Descending |
Select-Object Count,
@{Name="Category";Expression={$_.Name}},
@{Name="PctTotal";Expression={($_.count/$all.count)*100 -as [int]}}

$report+= [PSCustomObject]@{
    Count  = $all.Where({$_.overdue}).count
    Category = "Overdue"
    PctTotal = ($all.Where({$_.overdue}).count/$all.count)*100 -as [int]
}
#>