param([String[]] $Tags)

If ($Tags -Contains "dwos") {
    $product = "Dental Wings DWOS"
    $registryKey = "HKLM:\SOFTWARE\WOW6432Node\DWOS\CAD\*"
}
ElseIf ($Tags -Contains "cares") {
    $product = "Straumann Cares"
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

    It 'has VCredist 2019' {
        (Get-WmiObject Win32_product -Filter "Name LIKE '%Microsoft Visual C++ 2019 X64%'" | Should Not Be $null)
    }
}

Describe 'Synergy install' -Tags "Synergy" {

    It 'has DWSynergyPorts firewall rule' {
        (Get-NetFirewallRule -DisplayName "DWSynergyPorts" | Should Not Be $null)
    }

    It 'has RabbitMQ_Erl firewall rule' {
        (Get-NetFirewallRule -DisplayName "RabbitMQ_Erl" | Should Not Be $null)
    }

    It 'has RabbitMQ_ErlSrv firewall rule' {
        (Get-NetFirewallRule -DisplayName "RabbitMQ_ErlSrv" | Should Not Be $null)
    }

    It 'has RabbitMQ_Epmd firewall rule' {
        (Get-NetFirewallRule -DisplayName "RabbitMQ_Epmd" | Should Not Be $null)
    }
    
    It 'has DWSynergySrv firewall rule' {
        (Get-NetFirewallRule -DisplayName "DWSynergySrv" | Should Not Be $null)
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
}
