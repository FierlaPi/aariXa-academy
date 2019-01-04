#region Fail Safe
Write-Host "This file is not intended to be run as a script`nUse F8"
Break

# CTRL + M: Collapse/Expand regions
# CTRL + 1: Script + Console View
# CTRL + 3: Focus script
# CTRL + R: Toggle console

#endregion Fail Safe

#region Current Path
pushd "$env:Userprofile\Deskto2p\Academy"
popd
#endregion Current Path

#region PSRemoting
Enter-PSSession -ComputerName ACADEMY-PDC000 -Credential (Get-Credential -UserName 'aariXaAcademy\Administrator' -Message 'Get Domaina admin Credetials')
#endregion PSRemoting

#region JEA
$cred = (Get-Credential -UserName 'aariXaAcademy\chapmch' -Message 'Get Printer Operator Credetials')

Enter-PSSession -ComputerName ACADEMY-PDC000 -Credential $cred
Enter-PSSession -ComputerName ACADEMY-PDC000 -Credential $cred -ConfigurationName aariXaAcademy.PrintOperator
#endregion JEA
