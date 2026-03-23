# Obtener usuario actual de forma más fiable
$loggedUser = "$env:USERDOMAIN\$env:USERNAME"

# Obtener GUID del plan activo (independiente del idioma)
$guid = (powercfg /getactivescheme | Select-String -Pattern '([a-f0-9\-]{36})').Matches.Value

# Crear acción con el GUID ya resuelto
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -Command `"powercfg /setacvalueindex $guid SUB_VIDEO VIDEOIDLE 900; powercfg /setdcvalueindex $guid SUB_VIDEO VIDEOIDLE 900; powercfg /setacvalueindex $guid SUB_SLEEP STANDBYIDLE 900; powercfg /setdcvalueindex $guid SUB_SLEEP STANDBYIDLE 900; powercfg /setacvalueindex $guid SUB_SLEEP HIBERNATEIDLE 900; powercfg /setdcvalueindex $guid SUB_SLEEP HIBERNATEIDLE 900; powercfg /setactive $guid`""

# Trigger en 10 segundos
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(10)

# Ejecutar con privilegios altos
$principal = New-ScheduledTaskPrincipal -UserId $loggedUser -LogonType InteractiveToken -RunLevel Highest

# Registrar tarea
Register-ScheduledTask -TaskName "AplicarBloqueo15min" -Action $action -Trigger $trigger -Principal $principal -Force

# Esperar a que corra
Start-Sleep -Seconds 15

# Eliminar tarea
Unregister-ScheduledTask -TaskName "AplicarBloqueo15min" -Confirm:$false
