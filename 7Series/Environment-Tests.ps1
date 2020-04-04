describe '7Series Tests' {
    it 'has WSUS' {
        Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | Should Be $true
        (Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate).WUServer | should be "https://wsus.dwos.com:8531"
    }
	
    it 'has the "High performance" power plan' {
        # This test will fail unless run as admin. should be fine for 7Series as UAC is disabled
        (get-wmiobject -namespace "root\cimv2\power" -class Win32_powerplan | Where-Object {$_.IsActive}).ElementName  | Should Be "High performance"
    }
}
