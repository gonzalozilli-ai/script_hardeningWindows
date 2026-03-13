$desktopPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop"
if (-not (Test-Path $desktopPath)) { New-Item -Path $desktopPath -Force | Out-Null }
Set-ItemProperty $desktopPath -Name "ScreenSaveActive"    -Value "1"   -Type String
Set-ItemProperty $desktopPath -Name "ScreenSaverIsSecure" -Value "1"   -Type String
Set-ItemProperty $desktopPath -Name "ScreenSaveTimeOut"   -Value "900" -Type String

$sysPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (-not (Test-Path $sysPath)) { New-Item -Path $sysPath -Force | Out-Null }
Set-ItemProperty $sysPath -Name "InactivityTimeoutSecs" -Value 900 -Type DWord

# Hardening - Bloqueo de pantalla, suspension e hibernacion a 15 minutos

$guid = ((powercfg /getactivescheme) -split '\s+')[3]

powercfg /setacvalueindex $guid SUB_VIDEO VIDEOIDLE     900
powercfg /setdcvalueindex $guid SUB_VIDEO VIDEOIDLE     900
powercfg /setacvalueindex $guid SUB_SLEEP STANDBYIDLE   900
powercfg /setdcvalueindex $guid SUB_SLEEP STANDBYIDLE   900
powercfg /setacvalueindex $guid SUB_SLEEP HIBERNATEIDLE 900
powercfg /setdcvalueindex $guid SUB_SLEEP HIBERNATEIDLE 900

powercfg /setactive $guid
