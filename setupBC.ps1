# Install Business Central
$ErrorActionPreference = 'Stop'
Write-Host "Path = $env:PATH"
Write-Host "PSModulePath = $env:PSModulePath"
Get-Module | Out-Host
. c:\run\start.ps1 -installOnly -includeTestToolkit -includeTestLibrariesOnly
. c:\run\navstart.ps1
if ($LASTEXITCODE -ne 0) {
  Write-Host "LASTEXITCODE from navstart.ps1 was $LASTEXITCODE"
}
$BcServiceName = 'MicrosoftDynamicsNavServer$BC'
$SqlServiceName = 'MSSQL$SQLEXPRESS'
$SqlWriterServiceName = "SQLWriter"
$SqlBrowserServiceName = "SQLBrowser"
$IisServiceName = "W3SVC"
Write-Host "Starting Local SQL Server"
Start-Service -Name $SqlBrowserServiceName
Start-Service -Name $SqlWriterServiceName
Start-Service -Name $SqlServiceName
Write-Host "Starting Internet Information Server"
Start-Service -name $IisServiceName
Write-Host "Starting BC Service..."
Start-Service -name $BcServiceName
Get-Service -name $BcServiceName | Out-Host
exit 0
