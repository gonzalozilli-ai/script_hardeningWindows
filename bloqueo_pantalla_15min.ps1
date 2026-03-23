$loggedUser = (Get-WmiObject -Class Win32_ComputerSystem).UserName

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -Command `"`$guid = ((powercfg /getactivescheme) -split '\s+')[3]; powercfg /setacvalueindex `$guid SUB_VIDEO VIDEOIDLE 900; powercfg /setdcvalueindex `$guid SUB_VIDEO VIDEOIDLE 900; powercfg /setacvalueindex `$guid SUB_SLEEP STANDBYIDLE 900; powercfg /setdcvalueindex `$guid SUB_SLEEP STANDBYIDLE 900; powercfg /setacvalueindex `$guid SUB_SLEEP HIBERNATEIDLE 900; powercfg /setdcvalueindex `$guid SUB_SLEEP HIBERNATEIDLE 900; powercfg /setactive `$guid`""

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(10)

$principal = New-ScheduledTaskPrincipal -UserId $loggedUser -LogonType Interactive -RunLevel Highest

Register-ScheduledTask -TaskName "AplicarBloqueo15min" -Action $action -Trigger $trigger -Principal $principal -Force

Start-Sleep -Seconds 15

Unregister-ScheduledTask -TaskName "AplicarBloqueo15min" -Confirm:$false
