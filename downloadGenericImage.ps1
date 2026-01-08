# Download nav-docker repository zip from GitHub, extract the 'generic' run files, and copy to C:\run
$ErrorActionPreference = 'Stop'
$navDockerUrl = 'https://github.com/freddydk/nav-docker/archive/refs/heads/main.zip'
$tempRoot = [System.IO.Path]::GetTempPath()
$tempDir  = Join-Path $tempRoot ([System.Guid]::NewGuid().ToString())
$zipPath = "$($tempDir).zip"
New-Item -ItemType Directory -Path $tempDir | Out-Null
Invoke-WebRequest -Uri $navDockerUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
$runPath = Join-Path $tempDir "*/generic/run" -Resolve
Copy-Item -Path $runPath -Destination "C:\" -force -Recurse
Remove-Item -Path $zipPath -Force
Remove-Item $tempDir -Recurse -Force
Get-ChildItem -Path "c:\run" | Out-Host

function ReplaceStr {
    param (
        [string] $FileName,
        [string] $SearchStr,
        [string] $ReplaceStr
    )
    Set-Content -Path $FileName -Encoding utf8 -Value (Get-Content -Path $FileName -raw -Encoding utf8).Replace($SearchStr, $ReplaceStr)
}

ReplaceStr -FileName: 'c:/run/SetupUrls.ps1' -SearchStr: 'https://aka.ms/bcdocker-Sql2022Url' -ReplaceStr: 'https://aka.ms/sqlserver2022developer'
ReplaceStr -FileName: 'c:/run/SQLConf.ini' -SearchStr: 'SQLMAXMEMORY="2147483647"' -ReplaceStr: 'SQLMAXMEMORY="22528"'
ReplaceStr -FileName: 'c:/run/SQLConf.ini' -SearchStr: '"Manual"' -ReplaceStr: '"Automatic"'
ReplaceStr -FileName: 'c:/run/SetupGeneric1.ps1' -SearchStr: 'SQLEXPRADV_x64_ENU.exe' -ReplaceStr: 'SQLServer2022-DEV-x64-ENU.exe'
ReplaceStr -FileName: 'c:/run/SetupGeneric1.ps1' -SearchStr: ', "/MediaType=Advanced"' -ReplaceStr: ''
ReplaceStr -FileName: 'c:/run/HelperFunctions.ps1' -SearchStr: '[string] $basePath = ''c:\dl''' -ReplaceStr: '[string] $basePath = ''c:\bcartifacts.cache'''
