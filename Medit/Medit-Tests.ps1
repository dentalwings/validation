describe 'Medit Tests' {
    it 'has not WSUS' {
        (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate) | should be $false
    }
}