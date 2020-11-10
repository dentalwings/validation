describe 'a Windows system properly configured for Medit' {
    It 'has UAC disabled' {
        # https://github.com/dentalwings/validation/wiki/Medit-Windows-Configuration-UAC
        (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA | should be 0
    }
    It 'has no WSUS' {
        # https://github.com/dentalwings/validation/wiki/Medit-Windows-Configuration-WSUS
        (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate) | should be $false
    }

    Context 'Runtime dependencies' {
        It 'has VCredist 2019' {
            (Get-WmiObject Win32_product -Filter "Name LIKE '%Microsoft Visual C++ 2019 X64%'" | Should Not Be $null)
        }

        It 'has Medit Link' {
            (Test-Path "D:\Medit\CARES Medit Link\") | should be $true
        }
    }
}
