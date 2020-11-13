Describe 'Chairside Installation' -Tags "chairside"{
    It 'has UAC enabled' {
        # https://github.com/dentalwings/validation/wiki/Chairside-Windows-Configuration
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 1
    }
	
    It 'has WSIG.Service running' {
        # https://github.com/dentalwings/validation/wiki/Chairside-Services#wsigservice
        (Get-Service -Name "WSIG.Service").Status | Should Be 'Running'
    }
	
    It 'has DWOS DNS-SD Service running' {
        # https://github.com/dentalwings/validation/wiki/Chairside-Services#dwos-dns-sd-service
        (Get-Service -Name "DWOS DNS-SD Service").Status | Should Be 'Running'
    }
    
    It "MySQL JDBC Port 37132 is OPEN" {
        (Test-NetConnection -ComputerName 127.0.0.1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 37132 -InformationLevel Quiet) | Should Be "True"
    }
}
