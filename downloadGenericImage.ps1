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
