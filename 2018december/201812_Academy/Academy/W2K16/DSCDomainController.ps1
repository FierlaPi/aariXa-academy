Configuration LCM {
    LocalConfigurationManager {
        ActionAfterReboot = 'ContinueConfiguration'
        ConfigurationMode = 'ApplyAndAutoCorrect'
        RebootNodeIfNeeded = $true
    }
}

Configuration Net {
    param (
        [Parameter(Mandatory)][String]$Name,
        [Parameter(Mandatory)][String]$Mac,
        [Parameter(Mandatory)][Net.IPAddress]$Address,
        [Parameter(Mandatory)][Net.IPAddress]$Gateway,
        [Parameter(Mandatory)][Net.IPAddress]$DNS
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName NetworkingDsc

    NetAdapterName interface {
        MacAddress = $Mac
        NewName = $Name
    }
    
    IPAddress address {
        DependsOn = '[NetAdapterName]interface'
        IPAddress = $Address.IPAddressToString
        InterfaceAlias = $Name
        AddressFamily = 'IPv4'
    }

    DefaultGatewayAddress gateway {
        DependsOn = '[NetAdapterName]interface'
        InterfaceAlias = $Name
        Address = $Gateway
        AddressFamily = 'IPv4'
    }

    DnsServerAddress dns {
        DependsOn = '[NetAdapterName]interface'
        InterfaceAlias = $Name
        Address = $DNS.IPAddressToString
        AddressFamily = 'IPv4'
    }
}

Configuration DC {
    param(
        [Parameter(Mandatory)][String]$DomainName,
        [Parameter(Mandatory)][PSCredential]$DomainAdminCred,
        [Parameter(Mandatory)][PSCredential]$SaveModeCred
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xActiveDirectory

    WindowsFeature RSATFeature {
        Ensure = 'Present'
        Name = 'RSAT-ADDS'
    }

    WindowsFeature ADFeature {
        Ensure = 'Present'
        Name = 'AD-Domain-Services'
        IncludeAllSubFeature = $true
    }

    File NTDSFolder {
        Ensure = 'Present'
        DestinationPath = 'C:\NTDS'
        Type = 'Directory'
    }

    xADDomain DC {
        DependsOn = '[File]NTDSFolder','[WindowsFeature]ADFeature'
        DomainName = $DomainName
        DomainAdministratorCredential = $DomainAdminCred
        SafemodeAdministratorPassword = $SaveModeCred
        DatabasePath = 'C:\NTDS'
        LogPath = 'C:\NTDS'
        SysvolPath = 'C:\NTDS'
    }

    xADOrganizationalUnit aariXaOU {
        DependsOn = '[xADDomain]DC'
        Ensure = 'Present'
        Name = 'aariXa'
        Path = 'DC=aariXaAcademy,DC=local'
        ProtectedFromAccidentalDeletion = $true
    }

    xADOrganizationalUnit usersOU {
        DependsOn = '[xADOrganizationalUnit]aariXaOU'
        Ensure = 'Present'
        Name = 'Users'
        Path = 'OU=aariXa,DC=aariXaAcademy,DC=local'
        ProtectedFromAccidentalDeletion = $true
    }


    xADOrganizationalUnit groupOU {
        DependsOn = '[xADOrganizationalUnit]aariXaOU'
        Ensure = 'Present'
        Name = 'Groups'
        Path = 'OU=aariXa,DC=aariXaAcademy,DC=local'
        ProtectedFromAccidentalDeletion = $true
    }

    xADGroup GrpInfra {
        DependsOn = '[xADOrganizationalUnit]groupOU'
        Ensure = 'Present'
        GroupName = 'Infrastructure'
        GroupScope = 'DomainLocal'
        Path = 'OU=Groups,OU=aariXa,DC=aariXaAcademy,DC=local'
    }

    xADGroup GrpDev {
        DependsOn = '[xADOrganizationalUnit]groupOU'
        Ensure = 'Present'
        GroupName = 'Development'
        GroupScope = 'DomainLocal'
        Path = 'OU=Groups,OU=aariXa,DC=aariXaAcademy,DC=local'
    }

    xADGroup GrpSal {
        DependsOn = '[xADOrganizationalUnit]groupOU'
        Ensure = 'Present'
        GroupName = 'Sales'
        GroupScope = 'DomainLocal'
        Path = 'OU=Groups,OU=aariXa,DC=aariXaAcademy,DC=local'
    }

    xADGroup GrpMng {
        DependsOn = '[xADOrganizationalUnit]groupOU'
        Ensure = 'Present'
        GroupName = 'Managment'
        GroupScope = 'DomainLocal'
        Path = 'OU=Groups,OU=aariXa,DC=aariXaAcademy,DC=local'
    }
}

Configuration LaboServer {
    param(
        [Parameter(Mandatory)][PSCredential]$DomainAdminCred,
        [Parameter(Mandatory)][PSCredential]$SaveModeCred
    )

    node $AllNodes.Where{$_.Role -eq "PDC"}.NodeName {
        LCM pol {}

        net network {
            Name = $Node.InterfaceName
            Mac = $Node.Mac
            Address = $Node.IP
            Gateway = $Node.Gateway
            DNS = '127.0.0.1'
        }

        DC PDC {
            DependsOn = '[net]network'
            DomainName = $Node.DomainName
            DomainAdminCred = $DomainAdminCred
            SaveModeCred = $SaveModeCred
        }
    }
}

Configuration LaboDesk {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDsc

    node $AllNodes.Where{$_.Role -eq "Desk"}.NodeName {
        LCM DskPol {}

        net DskNet {
            Name = $Node.InterfaceName
            Mac = $Node.Mac
            Address = $Node.IP
            Gateway = $Node.Gateway
            DNS = '10.1.4.3'
        }

        Computer DskComp {
            Name = 'ACADEMY-DSK001'
            DomainName = 'aarixaacademy.local'
            Credential = (Get-Credential -Username 'aarixaacademy\Administrator' -Message 'Domain user with join pivileges')
        }
    }
}

Pushd C:\Users\Administrator\Documents

#Set-DscLocalConfigurationManager -Path c:\MOF -Verbose -Force
#Set-DscLocalConfigurationManager -Path c:\MOF -Verbose -Force -ComputerName 10.1.4.20 -Credential (Get-Credential -UserName '10.1.4.20\Fierlafijn Pierre' -Message 'Remote user account')

LaboServer -ConfigurationData .\academy.psd1 -OutputPath C:\MOF -DomainAdminCred (Get-Credential -UserName 'aariXaAcademy\Administrator' -Message 'New Domain Admin Creds') -SaveModeCred (Get-Credential -UserName '(Password Only)' -Message 'New Save Mode Admin Password') -Verbose -InstanceName 'localhost'
#LaboDesk -ConfigurationData .\academy.psd1 -OutputPath C:\MOF -Verbose -InstanceName 'Desk'
Start-DscConfiguration -Wait -Path C:\MOF -ComputerName localhost -Verbose -Force
#Start-DscConfiguration -Wait -Path C:\MOF -ComputerName 10.1.4.20 -Verbose -Force -Credential (Get-Credential -UserName '10.1.4.20\Fierlafijn Pierre' -Message 'Remote user account') 

Popd
   
# ConfigurationName -configurationData <path to ConfigurationData (.psd1) file>