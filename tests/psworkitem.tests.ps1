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
        $mod.ExportedFunctions.keys | Where-Object { $_ -notmatch "^\w+\-\w+"} | Should -HaveCount 0
    }

    It "Should export 5 format files" {
        ( $mod.ExportedFormatFiles).count | Should -Be 5
    }

    It "Should export 2 type extension files" {
        ( $mod.ExportedTypeFiles).count | Should -Be 2
    }

    It "Should have a project uri" {
        $mod.PrivateData.PSData.ProjectUri | Should -Match "^http"
    }

    It "Should have one or more tags" {
        $mod.PrivateData.PSData.tags.count | Should -BeGreaterThan 0
    }

    It "Should have markdown documents folder" {
        Get-ChildItem $PSScriptRoot\..\docs\*md | Should -Exist
    }

    It "Should have an external help file" {
        $cult = (Get-Culture).name
        Get-ChildItem $PSScriptRoot\..\$cult\*-help.xml | Should -Exist
    }

    It "Should have a README file" {
        Get-ChildItem $PSScriptRoot\..\README.md | Should -Exist
    }

    It "Should have a License file" {
        Get-ChildItem $PSScriptRoot\..\License.* | Should -Exist
    }
} #Describe ModuleStructure

Describe Add-PSWorkItemCategory {
    It "Should have help documentation" {
        (Get-Help Add-PSWorkItemCategory).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Add-PSWorkItemCategory).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should fail on a bad path" {
        {Add-PSWorkItemCategory -Path TestDrive:\foo.db -Category Foo} | Should -Throw
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
    It "Should fail on a bad path" {
        {Complete-PSWorkItem -id 1 -Path TestDrive:\foo.db} | Should -Throw
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
    It "Should fail on a bad path" {
        {Get-PSWorkItem -Path TestDrive:\foo.db} | Should -Throw
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

Describe Get-PSWorkItemData {
    It "Should have help documentation" {
        (Get-Help Get-PSWorkItemData).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -Name Get-PSWorkItemData).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should fail on a bad path" {
        {Get-PSWorkItemData -Path TestDrive:\foo.db} | Should -Throw
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        { Get-PSWorkItemData } | Should -Not -Throw
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
    It "Should fail on a bad path" {
        {Get-PSWorkItemArchive -Path TestDrive:\foo.db} | Should -Throw
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
    It "Should fail on a bad path" {
        {Get-PSWorkItemCategory-Path TestDrive:\foo.db} | Should -Throw
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
    It "Should fail on a bad path" {
        {Get-PSWorkItemDatabase -Path TestDrive:\foo.db} | Should -Throw
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
    It "Should fail on a bad path" {
        {Initialize-PSWorkItemDatabase -Path TestDrive:\foo.bar} | Should -Throw
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
    It "Should fail on a bad path" {
        {New-PSWorkItem -name Foo -Category work -Path TestDrive:\foo.db} | Should -Throw
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
    It "Should fail on a bad path" {
        {Remove-PSWorkItem -id 1 -Path TestDrive:\foo.db} | Should -Throw
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
    It "Should fail on a bad path" {
        {Remove-PSWorkItemCategory Foo -Path TestDrive:\foo.db} | Should -Throw
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
    It "Should fail on a bad path" {
        {Set-PSWorkItem -Path TestDrive:\foo.db} | Should -Throw
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

Describe Update-PSWorkItemPreference {
    It "Should have help documentation" {
        (Get-Help Update-PSWorkItemPreference).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Update-PSWorkItemPreference).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        {Update-PSWorkItemPreference} | Should -Not -Throw
    } -pending
    #insert additional command-specific tests

} -tag function

Describe Update-PSWorkItemDatabase {
    It "Should have help documentation" {
        (Get-Help Update-PSWorkItemDatabase).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Update-PSWorkItemDatabase).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        {Update-PSWorkItemDatabase} | Should -Not -Throw
    } -pending
    #insert additional command-specific tests

} -tag function

Describe Remove-PSWorkItemArchive {
    It "Should have help documentation" {
        (Get-Help Remove-PSWorkItemArchive).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Remove-PSWorkItemArchive).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        {Remove-PSWorkItemArchive} | Should -Not -Throw
    } -pending
    #insert additional command-specific tests

} -tag function


Describe Set-PSWorkItemCategory {
    It "Should have help documentation" {
        (Get-Help Set-PSWorkItemCategory).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Set-PSWorkItemCategory).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        {Set-PSWorkItemCategory} | Should -Not -Throw
    } -pending
    #insert additional command-specific tests

} -tag function


Describe Get-PSWorkItemPreference {
    It "Should have help documentation" {
        (Get-Help Get-PSWorkItemPreference).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Get-PSWorkItemPreference).OutputType | Should -Not -BeNullOrEmpty
    }
    It "Should run without error" {
        <#
        mock and set mandatory parameters as needed
        this test is marked as pending since it
        most likely needs to be refined
        #>
        {Get-PSWorkItemPreference} | Should -Not -Throw
    } -pending
    #insert additional command-specific tests

} -tag function