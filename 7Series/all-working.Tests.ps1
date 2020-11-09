
Describe 'Dental Wings 7Series Scanner' {
    Context 'Hardware is adequate' {

        # Check if C: drive has enough free space
        It "C drive free space greater than 10 GB" {
            (Get-WmiObject win32_logicaldisk -Filter "Drivetype=3" | Where-Object { $_.DeviceID -eq "C:" }).FreeSpace / 1GB | Should BeGreaterThan 10
        }
    
        # Check if D: drive has enough free space
        It "D drive free space greater than 10 GB" {
            (Get-WmiObject win32_logicaldisk -Filter "Drivetype=3" | Where-Object { $_.DeviceID -eq "D:" }).FreeSpace / 1GB | Should BeGreaterThan 10
        }

        # Check if the RAM size greater than 16GB (some old 7S have 8Go but those are running on Win7, and this pester test can only run on Win10)
        It "Total RAM Size is greater than 16GB" {
            [Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName localhost).TotalPhysicalMemory / 1Gb) | Should BeGreaterThan 8
        }
	
    }

    Context 'Windows configurations are properly applied' {

        It 'has WSUS' {
            Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | Should Be $true
            (Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate).WUServer | should be "https://wsus.dwos.com:8531"
        }
	
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

    Context 'Connectivity' {

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

    Context 'DWOS is properly installed' {

        #Checking if the User Access Control is disabled to prevent app starting/blocking issues
        It 'has UAC disabled' {
            (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
        }

    }

    Context 'DWOS Easy is properly installed' {

        It "MySQL JDBC Port 37132 is OPEN" {
            (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 37132 -InformationLevel Quiet) | Should Be "True"
        }

    }
    
    Context 'VCredist is present' {

    	It 'VCredist 2019 is present' {
	   (Get-WmiObject Win32_product -Filter "Name LIKE '%Microsoft Visual C++ 2019 X64%'" | Should Not Be $null)
	}

    }

}
