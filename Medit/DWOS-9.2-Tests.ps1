describe '7Series System 9.2' {
    it 'has UAC enabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 1
    }
	
    it 'has not WSUS set up' {
        Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | Should Be $false
    }
}
