#region Fail Safe
Write-Host "This file is not intended to be run as a script`nUse F8"
Break

# CTRL + M: Collapse/Expand regions
# CTRL + 1: Script + Console View
# CTRL + 3: Focus script
# CTRL + R: Toggle console

#endregion Fail Safe

#region Current Path
pushd "$env:Userprofile\Desktop\Academy"
popd
#endregion Current Path

#region Restore
$NewUsers = Import-Csv .\NewUser.csv
$NewUsers | ConvertTo-Json | Out-File -Encoding utf8 -FilePath .\NewUser.json


$NewUsers = Get-Content .\NewUser.json | ConvertFrom-Json
$NewUsers | Export-Csv .\NewUser2.csv -Encoding UTF8 -NoTypeInformation
#endregion Restore

#region Manage AD
. .\AcademyScript.ps1

$param = @{
    FirstName  = "Chaim"
    LastName   = "Chapman"
    Phone      = "+32477123456"
    Title      = "System Engeneer"
    Department = "Infrastructure"
}
Add-aariXaUser @param -Verbose

ise .\NewUser.csv
ise .\NewUser.json

$NewUsers = Import-Csv .\NewUser.csv
$NewUsers | Out-GridView

$NewUsers | Add-aariXaUser -Verbose

#region On Request
ise $env:Userprofile\documents\WindowsPowerShell\Modules\aariXaAcademy.IdentityManagement\1.0.0.0\Public\AcademyScript.ps1
#endregion On Request

#endregion Manage AD

#region DSC

ise .\academy.psd1
ise .\DSCDomainController.ps1

Test-DscConfiguration -Detailed | Select-Object -ExpandProperty ResourcesInDesiredState    | Select-Object @{Name = "In State"; Expression = { $_.InstanceName}} | Out-GridView
Test-DscConfiguration -Detailed | Select-Object -ExpandProperty ResourcesNotInDesiredState | Select-Object @{Name = "In State"; Expression = { $_.InstanceName}} | Out-GridView

#endregion DSC

#region JEA
ise .\Jea_setup.ps1
ise .\PrintOperator.pssc
ise "$env:ProgramFiles\WindowsPowerShell\Modules\aariXaAcademy\RoleCapabilities\PrintOperator.psrc"

$param = @{
    Name = "aariXaAcademy.PrintOperator"
    Path = ".\PrintOperator.pssc"
}
Register-PSSessionConfiguration @param -Force
Get-PSSessionConfiguration -Name aariXaAcademy*

explorer C:\Transcripts

$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList "aariXaAcademy\chapmch",("P@ssW0rd000" | ConvertTo-SecureString -AsPlainText -Force)
$param = @{
    ComputerName      = "localhost"
    ConfigurationName = "aariXaAcademy.PrintOperator"
    Credential        = $Credentials
}
Enter-PSSession @param
#endregion

#region Cleanup
Unregister-PSSessionConfiguration -Name aariXaAcademy.PrintOperator
Remove-Item -Path C:\Transcripts\* -Force
Get-ADUser -Filter * -SearchBase "OU=Users,OU=aariXa,DC=aariXaAcademy,DC=local" | Remove-ADUser -Confirm:$false
#endregion Cleanup
