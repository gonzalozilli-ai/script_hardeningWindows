New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force

Set-ItemProperty `
 -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
 -Name "SettingsPageVisibility" `
 -Value "hide:powersleep"


New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force

Set-ItemProperty `
 -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
 -Name "NoControlPanel" `
 -Value 1 `
 -Type DWord

gpupdate /force
