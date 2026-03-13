# Obtener SID del usuario activo
$username = (Get-WmiObject -Class Win32_ComputerSystem).UserName -replace '.*\\'
$sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Aplicar en el registro del usuario activo (funciona desde SYSTEM)
$base = "HKU:\$sid"
if (-not (Test-Path "HKU:")) { New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null }

$desktopPath = "$base\Control Panel\Desktop"
Set-ItemProperty $desktopPath -Name "ScreenSaveActive"    -Value "1"   -Type String
Set-ItemProperty $desktopPath -Name "ScreenSaverIsSecure" -Value "1"   -Type String
Set-ItemProperty $desktopPath -Name "ScreenSaveTimeOut"   -Value "900" -Type String

# InactivityTimeoutSecs en HKLM (siempre accesible desde SYSTEM)
$sysPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (-not (Test-Path $sysPath)) { New-Item -Path $sysPath -Force | Out-Null }
Set-ItemProperty $sysPath -Name "InactivityTimeoutSecs" -Value 900 -Type DWord
