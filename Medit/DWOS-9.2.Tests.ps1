describe 'DWOS 9.2 on Medit tests' {
    it 'has UAC enabled' {
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 1
    }
}
