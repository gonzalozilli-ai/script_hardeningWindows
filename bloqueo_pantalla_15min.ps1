# Bloqueo de pantalla, suspension e hibernacion a 15 minutos

# powercfg para la UI
$guid = ((powercfg /getactivescheme) -split '\s+')[3]
powercfg /setacvalueindex $guid SUB_VIDEO VIDEOIDLE      900
powercfg /setdcvalueindex $guid SUB_VIDEO VIDEOIDLE      900
powercfg /setacvalueindex $guid SUB_SLEEP STANDBYIDLE    900
powercfg /setdcvalueindex $guid SUB_SLEEP STANDBYIDLE    900
powercfg /setacvalueindex $guid SUB_SLEEP HIBERNATEIDLE  900
powercfg /setdcvalueindex $guid SUB_SLEEP HIBERNATEIDLE  900
powercfg /setactive $guid

# Screensaver con contrasena via registro del usuario activo
if (-not (Test-Path "HKU:")) { New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null }

$loggedUser = (Get-WmiObject -Class Win32_ComputerSystem).UserName
$domain     = $loggedUser -split '\\' | Select-Object -First 1
$username   = $loggedUser -split '\\' | Select-Object -Last 1
$sid        = (New-Object System.Security.Principal.NTAccount($domain, $username)).Translate([System.Security.Principal.SecurityIdentifier]).Value

Set-ItemProperty "HKU:\$sid\Control Panel\Desktop" -Name "ScreenSaveTimeOut"   -Value "900" -Type String
Set-ItemProperty "HKU:\$sid\Control Panel\Desktop" -Name "ScreenSaveActive"    -Value "1"   -Type String
Set-ItemProperty "HKU:\$sid\Control Panel\Desktop" -Name "ScreenSaverIsSecure" -Value "1"   -Type String
