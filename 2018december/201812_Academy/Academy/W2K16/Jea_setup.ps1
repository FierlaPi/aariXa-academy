$modulePath = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules\aariXaAcademy"
New-Item -ItemType Directory -Path $modulePath

New-Item -ItemType File -Path (Join-Path $modulePath "aariXaAcademy.psm1")
New-ModuleManifest -Path (Join-Path $modulePath "aariXaAcademy.psd1") -RootModule "aariXaAcademy.psm1"

$rcFolder = Join-Path $modulePath "RoleCapabilities"
New-Item -ItemType Directory $rcFolder
Copy-Item -Path .\PrinterOperator.psrc -Destination $rcFolder