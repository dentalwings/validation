describe 'a Windows system properly connected for Medit' {

    Context 'Connectivity' {

        It 'can connect to ftp.dwos.com on port 21' {
            (Test-NetConnection -ComputerName ftp.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 21 -InformationLevel Quiet) | Should Be "True"
        }

        It 'can connect to updates.dwos.com on port 22 (SSH)' {
            (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 22 -InformationLevel Quiet) | Should Be "True"
        }

        It 'can connect to updates.dwos.com on port 80 (HTTP)' {
            (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 80 -InformationLevel Quiet) | Should Be "True"
        }
        
        It 'can connect to updates.dwos.com on port 443 (HTTPS)' {
            (Test-NetConnection -ComputerName updates.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 443 -InformationLevel Quiet) | Should Be "True"
        }
    
        It 'can connect to licenses.dwos.com on port 9997' {
            (Test-NetConnection -ComputerName licenses.dwos.com -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Port 9997 -InformationLevel Quiet) | Should Be "True"
        }
    }
}
