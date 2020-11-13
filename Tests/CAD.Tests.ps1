Describe 'CAD Installation' -Tags "dwos","cares" {

    #Checking if the User Access Control is disabled to prevent app starting/blocking issues
    It 'has UAC disabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }

    It "MySQL JDBC Port 37132 is OPEN" {
        (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 37132 -InformationLevel Quiet) | Should Be "True"
    }

    It 'has VCredist 2019' {
        (Get-WmiObject Win32_product -Filter "Name LIKE '%Microsoft Visual C++ 2019 X64%'" | Should Not Be $null)
    }

}
Describe 'Dental Wings DWOS Software' -Tags "dwos" {
    # Will run for every hardware if variant is dwos

    $installdir = (Get-Item -Path HKLM:\SOFTWARE\WOW6432Node\DWOS\CAD\* | `
    Where-Object {$_ | Get-ItemProperty -name Path | test-path} | `
    Select-Object -First 1 | Get-ItemProperty -name Path).Path

    It 'is installed' {
        $installdir | Should Not BeNullOrEmpty
    }

    It 'has the correct scanner type' -Tags "7Series-dwos" {
        [XML]$scannerType = Get-Content "$installdir\DWData\release\localconf\ScannerType.xml" -ErrorAction Ignore
        $scannerType.Conf.ScannerType.Type | should be "DW7140"
    }

    It 'has the correct scanner type' -Tags "3Series-dwos" {
        [XML]$scannerType = Get-Content "$installdir\DWData\release\localconf\ScannerType.xml" -ErrorAction Ignore
        $scannerType.Conf.ScannerType.Type | should be "DW390PLUS"
    }
}
Describe 'Straumann Cares Visual Software' -Tags "cares" {
    # Will run for every hardware if variant is cares

    $installdir = (Get-Item -Path HKLM:\SOFTWARE\WOW6432Node\DWOS\Cares\* | `
    Where-Object {$_ | Get-ItemProperty -name Path | test-path} | `
    Select-Object -First 1 | Get-ItemProperty -name Path).Path

    It 'is installed' {
        $installdir | Should Not BeNullOrEmpty
    }
    Context "7Series scanner configured" -Tags "7Series-cares" {
    
        It 'has the correct scanner type' {
            [XML]$scannerType = Get-Content "$installdir\DWData\release\localconf\ScannerType.xml" -ErrorAction Ignore
            $scannerType.Conf.ScannerType.Type | should be "DW7140"
        }
    }
    
    Context "3Series scanner configured" -Tags "3Series-cares" {
    
        It 'has the correct scanner type' {
            [XML]$scannerType = Get-Content "$installdir\DWData\release\localconf\ScannerType.xml" -ErrorAction Ignore
            $scannerType.Conf.ScannerType.Type | should be "DW390PLUS"
        }
    }
}
