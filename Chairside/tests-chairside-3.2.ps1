describe 'Chairside System 3.2' {
    it 'has UAC enabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 1
    }
	
    it 'has WSIG.Service running' {
        (Get-Service -Name "WSIG.Service").Status | Should Be 'Running'
    }
	
    it 'has DWOS DNS-SD Service running' {
        (Get-Service -Name "DWOS DNS-SD Service").Status | Should Be 'Running'
    }
}