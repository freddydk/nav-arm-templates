
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "This script needs to run as admin"
}

# Install Windows feature containers
$restartNeeded = $false
if (!(Get-WindowsOptionalFeature -FeatureName containers -Online).State -eq 'Enabled') {
    $restartNeeded = (Enable-WindowsOptionalFeature -FeatureName containers -Online).RestartNeeded
}

# Get Latest Stable version and URL
$latestZipFile = (Invoke-WebRequest -UseBasicParsing -uri "https://download.docker.com/win/static/stable/x86_64/").Content.split("`r`n") | 
                 Where-Object { $_ -like "<a href=""docker-*"">docker-*" } | Select-Object -Last 1 | ForEach-Object { $_.Split('"')[1] }
if (-not $latestZipFile) {
    throw "Unable to locate latest stable docker download"
}
$latestZipFileUrl = "https://download.docker.com/win/static/stable/x86_64/$latestZipFile"
$latestVersion = [Version]($latestZipFile.SubString(7,$latestZipFile.Length-11))
Write-Host "Latest stable available Docker Engine version is $latestVersion"

# Check existing docker version
$dockerService = get-service docker -ErrorAction SilentlyContinue
if ($dockerService) {
    if ($dockerService.Status -eq "Running") {
        $dockerVersion = [Version](docker version -f "{{.Server.Version}}")
        Write-Host "Current installed Docker Engine version $dockerVersion"
        if ($latestVersion -le $dockerVersion) {
            Write-Host "No new Docker Engine available"
            Exit
        }
        Write-Host "New Docker Engine available"
    }
    else {
        Write-Host "Docker Service not running"
    }
}
else {
    Write-Host "Docker Engine not found"
}

Read-Host "Press Enter to Install new Docker Engine version (or Ctrl+C to break) ?"

if ($dockerService) {
    Stop-Service docker
}

# Download new version
$tempFile = "$([System.IO.Path]::GetTempFileName()).zip"
Invoke-WebRequest -UseBasicParsing -Uri $latestZipFileUrl -OutFile $tempFile
Expand-Archive $tempFile -DestinationPath $env:ProgramFiles -Force
Remove-Item $tempFile -Force

# Register service if necessary
if (-not $dockerService) {
    [Environment]::SetEnvironmentVariable("Path", "$($env:path);$env:ProgramFiles\docker", [System.EnvironmentVariableTarget]::Machine)
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    dockerd --register-service
    Start-Service docker
}

Start-Service docker