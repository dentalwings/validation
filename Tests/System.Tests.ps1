Describe 'Hardware' -Tags "7Series","3Series","Medit" {

    # Check if C: drive has enough free space
    It "has enough space on C:" {
        (Get-WmiObject win32_logicaldisk -Filter "Drivetype=3" | Where-Object { $_.DeviceID -eq "C:" }).FreeSpace / 1GB | Should BeGreaterThan 10
    }

    # Check if D: drive has enough free space
    It "has enough space on D:" {
        (Get-WmiObject win32_logicaldisk -Filter "Drivetype=3" | Where-Object { $_.DeviceID -eq "D:" }).FreeSpace / 1GB | Should BeGreaterThan 10
    }

    # Check if the RAM size greater than 16GB (some old 7S have 8Go but those are running on Win7, and this pester test can only run on Win10)
    It "has enough RAM" {
        [Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName localhost).TotalPhysicalMemory / 1Gb) | Should BeGreaterThan 16
    }

    It "has all devices properly detected" {
        @(Get-WmiObject Win32_PNPEntity | Where-Object{$_.ConfigManagerErrorCode -ne 0}).Count | Should be 0
    }

}

Describe 'System (DW Scanners)' -Tags "7Series","3Series" {

    It 'has WSUS' {
        Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | Should Be $true
    }

    It 'has DWOS WSUS' {
        (Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate).WUServer | should be "https://wsus.dwos.com:8531"
    }
}

Describe 'System (Medit)' -Tags "Medit" {

    It 'has no WSUS' {
        Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | Should Be $false
    }

}

Describe 'System (Scanners)' -Tags "7Series","3Series","Medit" {

    It 'has the "Balanced" power plan' {
        # This test will fail unless run as admin. should be fine for 7Series as UAC is disabled
        (Get-WmiObject -namespace "root\cimv2\power" -class Win32_powerplan | Where-Object { $_.IsActive }).ElementName  | Should Be "Balanced"
    }

    It 'has minimum processor state set to 75%' {
        # This test will fail unless run as admin. should be fine for 7Series as UAC is disabled
        [int64]$value = $(powercfg.exe -q SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMIN | Select-String -Pattern "\s*Current AC Power Setting Index: (.*)").Matches.Groups[1].Value
        $value | Should Be "75"
    }
}

Describe 'Graphic drivers (NVidia)' -Tags "7Series","Medit" {

    It 'has NVidia drivers' {
        Get-WmiObject Win32_PnPSignedDriver -Filter "DeviceName LIKE '%NVIDIA GeForce GTX 1050 Ti%'" | Select -ExpandProperty "DriverVersion" | Should be "26.21.14.3200"
    }
}

Describe 'Connectivity' -Tags "7Series","3Series","Medit","chairside" {

    It 'can connect to ftp.dwos.com on port 21' {
        (Test-NetConnection -ComputerName ftp.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 21 -InformationLevel Quiet) | Should Be "True"
    }

    It 'can connect to updates.dwos.com on port 22 (SSH)' {
        (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 22 -InformationLevel Quiet) | Should Be "True"
    }

    It 'can connect to updates.dwos.com on port 80 (HTTP)' {
        (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 80 -InformationLevel Quiet) | Should Be "True"
    }
    
    It 'can connect to updates.dwos.com on port 443 (HTTPS)' {
        (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 443 -InformationLevel Quiet) | Should Be "True"
    }

    It 'can connect to licenses.dwos.com on port 9997' {
        (Test-NetConnection -ComputerName licenses.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 9997 -InformationLevel Quiet) | Should Be "True"
    }
}
