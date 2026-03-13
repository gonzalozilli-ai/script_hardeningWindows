#bloquear power settings
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force

Set-ItemProperty `
 -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
 -Name "SettingsPageVisibility" `
 -Value "hide:powersleep"
# fin 
#Bloquear panel de control
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force

Set-ItemProperty `
 -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
 -Name "NoControlPanel" `
 -Value 1 `
 -Type DWord
#fin
gpupdate /force
