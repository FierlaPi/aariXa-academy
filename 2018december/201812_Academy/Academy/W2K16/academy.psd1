@{
    AllNodes = @(
        @{
            NodeName = '*'
            InterfaceName = 'DSCInterface'
            Gateway = '10.1.4.1'
        },@{
            NodeName = 'localhost'
            Role = 'PDC'
            MAC = '00-15-5D-64-80-06'
            IP = '10.1.4.3'
            DomainName = 'aariXaAcademy.local'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        },@{
            NodeName = '10.1.4.20'
            Role = 'Desk'
            MAC = '00-15-5D-64-80-07'
            IP = '10.1.4.20'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}
# Save ConfigurationData in a file with .psd1 file extension