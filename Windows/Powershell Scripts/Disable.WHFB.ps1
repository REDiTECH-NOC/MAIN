# PowerShell script to disable Windows Hello for Business and related features

# Ensure running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script! Please run this as an Administrator!"
    exit
}

# Disable Domain PIN Logon
Set-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name 'AllowDomainPINLogon' -Value 0

# Disable Sign-In Options
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions -Name 'value' -Value 0

# Disable Biometrics
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\' -Name 'Biometrics' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Biometrics' -Name 'Enabled' -Value 0 -PropertyType Dword -Force

# Disable Windows Hello for Business
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\' -Name 'PassportforWork' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\PassportforWork' -Name 'Enabled' -Value 0 -PropertyType Dword -Force

# Take ownership and adjust permissions before deleting NGC folder
Start-Process cmd -ArgumentList '/s,/c,takeown /f C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /r /d y & icacls C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /grant administrators:F /t' -Verb runAs -Wait

# Delete NGC folder and recreate it
Remove-Item -Path C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC -Recurse -Force
New-Item -ItemType directory -Path C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC

# Reset permissions on the new NGC folder
icacls C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc /T /Q /C /RESET

Write-Output "Windows Hello for Business and related features have been disabled."
