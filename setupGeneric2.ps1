# Setup generic image part 2 - i.e. prepare runner for running BC
$ErrorActionPreference = 'Stop'
Write-Host "Path = $env:PATH"
Write-Host "PSModulePath = $env:PSModulePath"
Get-Module | Out-Host
. c:\run\SetupGeneric2.ps1
