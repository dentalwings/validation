describe 'Medit Tests' {
    it 'has no WSUS' {
        (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate) | should be $false
    }
}
