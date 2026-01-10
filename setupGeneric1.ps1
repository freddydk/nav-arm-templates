# Setup generic image part 1 - i.e. install pre-requisites
$ErrorActionPreference = 'Stop'
Write-Host "Path = $env:PATH"
Get-Module | Out-Host
. c:\run\SetupGeneric1.ps1
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
$env:PSModulePath = "C:\Users\$($env:USERNAME)\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\Windows\system32\WindowsPowerShell\v1.0\Modules;C:\Program Files (x86)\Microsoft SQL Server\160\Tools\PowerShell\Modules\"
Add-Content -Path $env:GITHUB_ENV -Value "PSModulePath=$env:PSModulePath" -Encoding utf8
$env:PATH = "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Program Files (x86)\Microsoft SQL Server\160\Tools\Binn\;C:\Program Files\Microsoft SQL Server\160\Tools\Binn\;C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\;C:\Program Files\Microsoft SQL Server\160\DTS\Binn\;C:\Program Files\dotnet\;C:\Program Files\PowerShell\7\;C:\Users\$($env:USERNAME)\AppData\Local\Microsoft\WindowsApps;C:\ProgramData\chocolatey\bin"
$pathEntries = $env:PATH -split ';' | Where-Object { $_ -and $_.Trim() -ne '' }
$existingEntries = Get-Content $env:GITHUB_PATH | Where-Object { $_ -and $_.Trim() -ne '' } | ForEach-Object { $_.TrimEnd('\').ToLowerInvariant() }
foreach ($path in $pathEntries) {
  $normalized = $path.TrimEnd('\').ToLowerInvariant()
  if ($existingEntries -notcontains $normalized) {
    Write-Host "Adding '$path' to GITHUB_PATH"
    Add-Content -Path $env:GITHUB_PATH -Value $path -Encoding utf8
  }
  else {
    Write-Host "'$path' is already in GITHUB_PATH"
  }
}
