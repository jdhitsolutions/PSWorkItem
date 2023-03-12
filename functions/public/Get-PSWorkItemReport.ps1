Function Get-PSWorkItemReport {
    [cmdletbinding()]
    [OutputType("PSWorkItemReport")]
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
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting work item report from $Path"
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
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
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