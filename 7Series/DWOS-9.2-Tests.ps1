describe '7Series System 9.2' {
    it 'has UAC disabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }
	
    it 'has WSUS set up' {
        Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | Should Be $true
    }
    
    it 'has the "High performance" power plan' {
        # This test will fail unless run as admin. should be fine for 7Series as UAC is disabled
        (get-wmiobject -namespace "root\cimv2\power" -class Win32_powerplan | Where-Object {$_.IsActive}).ElementName  | Should Be "High performance"
    }
}