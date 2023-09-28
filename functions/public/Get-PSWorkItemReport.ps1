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
        $PSDefaultParameterValues["_verbose:Command"] = $MyInvocation.MyCommand
        $PSDefaultParameterValues["_verbose:block"] = "Begin"
        _verbose -message $strings.Starting
        _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
        _verbose -message ($strings.UsingDB -f $path)
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
        _verbose -message $strings.Ending -command $myInvocation.MyCommand
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