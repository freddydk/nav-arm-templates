# Disable Windows Defender and Search to speed up the build process
$ErrorActionPreference = 'Stop'
Add-MpPreference -ExclusionPath "C:\Program Files\Microsoft SQL Server"
Add-MpPreference -ExclusionPath "C:\Program Files\Microsoft Dynamics NAV"
Add-MpPreference -ExclusionPath "C:\ProgramData\BcContainerHelper"
Add-MpPreference -ExclusionPath "C:\agent"
Add-MpPreference -ExclusionPath "C:\_work"
Add-MpPreference -ExclusionPath "C:\Applications"
Add-MpPreference -ExclusionPath "C:\bcartifacts.cache"
Add-MpPreference -ExclusionPath "C:\run"
Add-MpPreference -ExclusionPath "C:\Windows\temp"
Add-MpPreference -ExclusionPath "$env:TEMP"
Set-MpPreference -DisableRealtimeMonitoring $true
Stop-Service -Name WSearch
Set-Service -Name WSearch -StartupType Disabled
