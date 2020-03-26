describe '7Series Tests' {
    it 'has WSUS' {
        (Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate).WUServer | should be "https://wsus.dwos.com:8531"
    }
}