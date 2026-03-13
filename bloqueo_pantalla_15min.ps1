# Obtener SID del usuario activo
$username = "gonzalo"
$sid = (New-Object System.Security.Principal.NTAccount("GDESKTOP", $username)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Montar HKU
if (-not (Test-Path "HKU:")) { New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null }

# Escribir en registro del usuario activo
$desktopPath = "HKU:\$sid\Control Panel\Desktop"
Set-ItemProperty $desktopPath -Name "ScreenSaveActive"    -Value "1"   -Type String
Set-ItemProperty $desktopPath -Name "ScreenSaverIsSecure" -Value "1"   -Type String
Set-ItemProperty $desktopPath -Name "ScreenSaveTimeOut"   -Value "900" -Type String

# HKLM accesible desde SYSTEM
$sysPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (-not (Test-Path $sysPath)) { New-Item -Path $sysPath -Force | Out-Null }
Set-ItemProperty $sysPath -Name "InactivityTimeoutSecs" -Value 900 -Type DWord
