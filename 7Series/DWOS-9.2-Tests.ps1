describe 'DWOS 9.2 on 7Series tests' {
    it 'has UAC disabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }
}
