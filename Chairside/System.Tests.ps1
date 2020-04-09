describe 'Chairside System' {
    it 'has UAC enabled' {
        # https://github.com/dentalwings/validation/wiki/Chairside-Windows-Configuration
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 1
    }
	
    it 'has WSIG.Service running' {
        # https://github.com/dentalwings/validation/wiki/Chairside-Services#wsigservice
        (Get-Service -Name "WSIG.Service").Status | Should Be 'Running'
    }
	
    it 'has DWOS DNS-SD Service running' {
        # https://github.com/dentalwings/validation/wiki/Chairside-Services#dwos-dns-sd-service
        (Get-Service -Name "DWOS DNS-SD Service").Status | Should Be 'Running'
    }
}
