# PowerShell script to re-enable Windows Hello for Business and related features

# Ensure running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script! Please run this as an Administrator!"
    exit
}

# Re-enable Domain PIN Logon
Set-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name 'AllowDomainPINLogon' -Value 1

# Re-enable Sign-In Options
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions -Name 'value' -Value 1

# Remove the Biometrics restriction
Remove-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Biometrics' -Force -ErrorAction SilentlyContinue

# Remove the Windows Hello for Business restriction
Remove-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\PassportforWork' -Force -ErrorAction SilentlyContinue

Write-Output "Windows Hello for Business and related features have been re-enabled."
