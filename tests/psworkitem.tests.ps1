
# test designed for Pester 5.x
# Import the parent module to test

if (Get-Module -Name PSWorkItem) {
    Remove-Module -Name PSWorkItem
}

Import-Module "$PSScriptRoot\..\PSWorkItem.psd1" -Force

Describe 'ModuleStructure' {

    BeforeAll {
        $mod = Get-Module -Name PSWorkItem
    }
    It 'Passes Test-ModuleManifest' {
        { Test-ModuleManifest -Path "$PSScriptRoot\..\PSWorkItem.psd1" } | Should -Not -Throw True
    }

    It "Should export functions" {
        ( $mod.ExportedFunctions).count | Should -BeGreaterThan 0
    }

    It "Should export functions with a Verb-Noun naming convention" {
        $mod.ExportedFunctions.keys | where { $_ -notmatch "^\w+\-\w+"} | Should -HaveCount 0
    }

    It "Should export two format files" {
        ( $mod.ExportedFormatFiles).count | Should -Be 2
    }

    It "Should export two format files" {
        ( $mod.ExportedFormatFiles).count | Should -Be 2
    }

    It "Should have a project uri" {
        $mod.PrivateData.psdata.projecturi | Should -Match "^http"
    }

    It "Should have one or more tags" {
        $mod.PrivateData.psdata.tags.count | Should -BeGreaterThan 0
    }

    It "Should have markdown documents folder" {
        Get-ChildItem $psscriptroot\..\docs\*md | Should -Exist
    }

    It "Should have an external help file" {
        $cult = (Get-Culture).name
        Get-ChildItem $psscriptroot\..\$cult\*-help.xml | Should -Exist
    }

    It "Should have a README file" {
        Get-ChildItem $psscriptroot\..\README.md | Should -Exist
    }

    It "Should have a License file" {
        Get-ChildItem $psscriptroot\..\License.* | Should -Exist
    }
} #Describe ModuleStructure

Describe Add-PSWorkItemCategory {
    It "Should have help documentation" {
        (Get-Help Add-PSWorkItemCategory).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Add-PSWorkItemCategory).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Add-PSWorkItemCategory } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Complete-PSWorkItem {
    It "Should have help documentation" {
        (Get-Help Complete-PSWorkItem).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Complete-PSWorkItem).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Complete-PSWorkItem } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Get-PSWorkItem {
    It "Should have help documentation" {
        (Get-Help Get-PSWorkItem).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Get-PSWorkItem).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Get-PSWorkItem } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Get-PSWorkItemArchive {
    It "Should have help documentation" {
        (Get-Help Get-PSWorkItemArchive).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Get-PSWorkItemArchive).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Get-PSWorkItemArchive } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Get-PSWorkItemCategory {
    It "Should have help documentation" {
        (Get-Help Get-PSWorkItemCategory).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Get-PSWorkItemCategory).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Get-PSWorkItemCategory } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Get-PSWorkItemDatabase {
    It "Should have help documentation" {
        (Get-Help Get-PSWorkItemDatabase).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Get-PSWorkItemDatabase).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Get-PSWorkItemDatabase } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Initialize-PSWorkItemDatabase {
    It "Should have help documentation" {
        (Get-Help Initialize-PSWorkItemDatabase).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Initialize-PSWorkItemDatabase).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Initialize-PSWorkItemDatabase } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe New-PSWorkItem {
    It "Should have help documentation" {
        (Get-Help New-PSWorkItem).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name New-PSWorkItem).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { New-PSWorkItem } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Remove-PSWorkItem {
    It "Should have help documentation" {
        (Get-Help Remove-PSWorkItem).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Remove-PSWorkItem).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Remove-PSWorkItem } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Remove-PSWorkItemCategory {
    It "Should have help documentation" {
        (Get-Help Remove-PSWorkItemCategory).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Remove-PSWorkItemCategory).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Remove-PSWorkItemCategory } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function

Describe Set-PSWorkItem {
    It "Should have help documentation" {
        (Get-Help Set-PSWorkItem).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Set-PSWorkItem).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Set-PSWorkItem } | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -Tag function