cls

#Checking if the User Access Control is disabled to prevent app starting/blocking issues
Context 'DWOS UAC Disabled' {

    it 'has UAC disabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }

}

Context 'WSUS & Power plan Check' {

    it 'has WSUS' {
        Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | Should Be $true
        (Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate).WUServer | should be "https://wsus.dwos.com:8531"
    }
	
    it 'has the "High performance" power plan' {
        # This test will fail unless run as admin. should be fine for 7Series as UAC is disabled
        (get-wmiobject -namespace "root\cimv2\power" -class Win32_powerplan | Where-Object {$_.IsActive}).ElementName  | Should Be "High performance"
    }
	
}

# Scanner Hardware Checks     
Context "Scanner Hardware Configuration Checks" {

    #Check if C: drive has enough free space
    It "C drive free space greater than 10 GB" {
        (Get-WmiObject win32_logicaldisk -Filter "Drivetype=3" | Where-Object {$_.DeviceID -eq "C:"}).FreeSpace/1GB | Should BeGreaterThan 10
    }
    
    #Check if D: drive has enough free space
    It "D drive free space greater than 10 GB" {
        (Get-WmiObject win32_logicaldisk -Filter "Drivetype=3" | Where-Object {$_.DeviceID -eq "D:"}).FreeSpace/1GB | Should BeGreaterThan 10
    }

    #Check if the RAM size greater than 8GB
    It "Total RAM Size is greater than 8GB" {
        [Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName localhost).TotalPhysicalMemory/1Gb) | Should BeGreaterThan 8
    }
		
} 

# MySQL Ports Checkup 
#DWOS (61234. 9000)
#Chairside (9001, 37221)
#Standalone 3306
Context "MySQL Connectivity Ports" {

    # MySQL Port 9000 Check
    It "MySQL Local Port 9000 is OPEN" {
        (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 9000 -InformationLevel Quiet) | Should Be "True"
    }
        
    # MySQL Port 61324 Check
    It "MySQL JDBC Port 61324 is OPEN" {
        (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 61324 -InformationLevel Quiet) | Should Be "True"
    }

}

# FTP,SSH,HTTP, HTTPS Ports Checkup (21,22,80,443)
Context "FTP & SSH Ports Checkup" {

    #FTP Port 21 is OPEN
    It "FTP Port 21 is OPEN" {
        (Test-NetConnection -ComputerName ftp.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 21 -InformationLevel Quiet) | Should Be "True"
    }

    #SSH Port 22 Check
    It "SSH Port 22 is OPEN" {
        (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 22 -InformationLevel Quiet) | Should Be "True"
    }

    #HTTP Port 80 Check
    It "HTTP Port 80 is OPEN" {
        (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 80 -InformationLevel Quiet) | Should Be "True"
    }

    #HTTPS Port 443 Check
    It "HTTPS Port 443 is OPEN" {
        (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 443 -InformationLevel Quiet) | Should Be "True"
    }

    #DWOS License Port 9997 Check
    It "DWOS License Port 9997 is OPEN" {
        (Test-NetConnection -ComputerName licenses.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 9997 -InformationLevel Quiet) | Should Be "True"
    }

} 

# Scan Server Ports Checkup (22181, 22182, 22183, 22184, 22185)    
Context "Check Scan Server Ports" {

    # Scan Server Port 22184 Check
    It "Scan Server Port 22184 is OPEN" {
        (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 22184 -InformationLevel Quiet) | Should Be "True"
    }

    # Scan Server Port 22184 Check
    It "Scan Server Port 22185 is OPEN" {
        (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 22185 -InformationLevel Quiet) | Should Be "True"
    }

}