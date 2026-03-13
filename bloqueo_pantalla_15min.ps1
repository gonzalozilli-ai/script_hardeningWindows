#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Configura el bloqueo de pantalla automatico a 15 minutos en Windows 11 (Home/Pro)
#>

Write-Host "Configurando bloqueo de pantalla a 15 minutos..." -ForegroundColor Cyan

# Obtener plan de energia activo
$guid = ((powercfg /getactivescheme) -split '\s+')[3]
Write-Host "Plan activo: $guid" -ForegroundColor Gray

# Apagar pantalla a los 15 min (enchufado y bateria)
powercfg /setacvalueindex $guid SUB_VIDEO VIDEOIDLE 900
powercfg /setdcvalueindex $guid SUB_VIDEO VIDEOIDLE 900

# Sleep e Hibernate a los 15 min
powercfg /setacvalueindex $guid SUB_SLEEP STANDBYIDLE   900
powercfg /setdcvalueindex $guid SUB_SLEEP STANDBYIDLE   900
powercfg /setacvalueindex $guid SUB_SLEEP HIBERNATEIDLE 900
powercfg /setdcvalueindex $guid SUB_SLEEP HIBERNATEIDLE 900

# Aplicar al plan activo
powercfg /setactive $guid

# Screensaver con contrasena
Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name "ScreenSaveActive"    -Value "1"   -Type String
Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name "ScreenSaverIsSecure" -Value "1"   -Type String
Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name "ScreenSaveTimeOut"   -Value "900" -Type String

# Politica de inactividad
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
Set-ItemProperty $regPath -Name "InactivityTimeoutSecs" -Value 900 -Type DWord

Write-Host "[OK] Listo. Pantalla se apaga a los 15 minutos de inactividad." -ForegroundColor Green
