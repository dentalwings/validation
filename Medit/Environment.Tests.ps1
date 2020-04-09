describe 'a Windows system properly configured for Medit' {
    it 'has UAC disabled' {
        # https://github.com/dentalwings/validation/wiki/Medit-Windows-Configuration-UAC
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }
    it 'has no WSUS' {
        # https://github.com/dentalwings/validation/wiki/Medit-Windows-Configuration-WSUS
        (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate) | should be $false
    }
}
