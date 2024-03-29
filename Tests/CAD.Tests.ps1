param([String[]] $Tags)

If ($Tags -Contains "dwos") {
    $product = "Dental Wings DWOS"
    $registryKey = "HKLM:\SOFTWARE\WOW6432Node\DWOS\CAD\*"
}
ElseIf ($Tags -Contains "cares") {
    $product = "Dental Wings DWOS"
    $registryKey = "HKLM:\SOFTWARE\WOW6432Node\DWOS\Cares\*"
}
If ($Tags -Contains "7Series") {
    $scannerType = "DW7140"
}
ElseIf ($Tags -Contains "3Series") {
    $scannerType = "DW390PLUS"
}

Describe 'System requirements (DW Scanners)' -Tags "7Series", "3Series" {

    #Checking if the User Access Control is disabled to prevent app starting/blocking issues
    It 'has UAC disabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }

    It "MySQL JDBC Port 37132 is OPEN" {
        (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 37132 -InformationLevel Quiet) | Should Be "True"
    }
}

Describe 'System requirements (Medit)' -Tags "Medit" {

    #Checking if the User Access Control is disabled to prevent app starting/blocking issues
    It 'has UAC disabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }
}

Describe 'System requirements' -Tags "7Series", "3Series", "Medit" {

    It 'has VCredist 2022' {
        (Get-WmiObject Win32_product -Filter "Name LIKE '%Microsoft Visual C++ 2022 X64%'" | Should Not Be $null)
    }
}

Describe "$product Software" -Tags "dwos", "cares" {
    $installdir = (Get-Item -Path $registryKey | `
            Where-Object { $_ | Get-ItemProperty -name Path | test-path } | `
            Select-Object -First 1 | Get-ItemProperty -name Path).Path

    It 'is installed' {
        $installdir | Should Not BeNullOrEmpty
    }

    It 'has the correct scanner type' {
        [XML]$scannerTypeXML = Get-Content "$installdir\DWData\release\localconf\ScannerType.xml" -ErrorAction Ignore
        $scannerTypeXML.Conf.ScannerType.Type | should be $scannerType
    }

    It 'has coDiagnostiX installed' {
        Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{8E844415-B43B-40F7-9625-BDD6A5F640D4}" | Should be $true
    }
    
    It 'has coDiagnostiX available' {
        Test-Path "C:\Program Files (x86)\coDiagnostiX\coDiagnostiX.App\coDiagStarter.exe" | Should be $true
    }
}
