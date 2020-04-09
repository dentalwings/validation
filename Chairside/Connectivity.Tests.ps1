describe 'Chairside Connectivity' {
    it 'can connect to updates.dwos.com' {
        # https://github.com/dentalwings/validation/wiki/Chairside-Windows-Configuration
        $ip = "192.99.147.12" # ip for updates.dwos.com
        test-netconnection $ip -Port 22 | should be $true # SSH port
        test-netconnection $ip -Port 80 | should be $true # HTTP port
        test-netconnection $ip -Port 443 | should be $true # HTTPS port
    }
}
