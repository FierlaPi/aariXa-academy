#region Fail Safe
Write-Host "This file is not intended to be run as a script`nUse F8"
Break

# CTRL + M: Collapse/Expand regions
# CTRL + 1: Script + Console View
# CTRL + 3: Focus script
# CTRL + R: Toggle console
#endregion Fail Safe

#region Academy Setup
pushd "$env:USERPROFILE\Desktop\Academy"
Start-VM -Name 'Ubuntu 18.10 Desktop'
Start-VM -Name 'W2K16'
Start-VM -Name 'W10'
#endregion Academy Setup

#region Console
vmconnect localhost 'Ubuntu 18.10 Desktop'
vmconnect localhost 'W2K16'
vmconnect localhost 'W10'
#endregion Console

#region Academy Cleanup
popd
#endregion Academy Cleanup

#region Different kind of editors
ise Foo.ps1
# Foo in terminal
code Foo.ps1
# Powershell Ctrl+Shift+P
Start-Process 'https://portal.azure.com' #CloudShell
#endregion Different kind of editors
