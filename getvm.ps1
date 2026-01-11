Param(
    [string] $templateLink,
    [string] $adminUsername,
    [string] $adminPassword,
    [string] $artifactUrl,
    [string] $bakFile
)

Start-Transcript -Path "c:\temp\log.txt" -Append

# https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Ffreddydk%2Fnav-arm-templates%2Frefs%2Fheads%2Fmain%2Fgetvm.json
$ENV:GITHUB_ENV = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$ENV:GITHUB_PATH = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())

New-Item $ENV:GITHUB_ENV -ItemType File
New-Item $ENV:GITHUB_PATH -ItemType File

Function LoadEnvironmentVariables {
    # Load Environment variables from ENV:GITHUB_ENV in this session
    $envFile = $env:GITHUB_ENV
    if (Test-Path $envFile) {   
        $lines = Get-Content -Path $envFile -Encoding utf8
        foreach ($line in $lines) {
            if ($line -match "^(.*?)=(.*)$") {
                $name = $matches[1]
                $value = $matches[2]
                Write-Host "Setting environment variable: $name=$value"
                [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Process)
            }
        }
    }
}

function LoadPathVariables {
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
    [System.Environment]::SetEnvironmentVariable("PATH", $currentPath, [System.EnvironmentVariableTarget]::Process)
}

function RunScript {
    param (
        [switch] $usePwsh,
        [string] $scriptUrl
    )

    LoadEnvironmentVariables
    LoadPathVariables

    Write-Host "Running script from URL: $scriptUrl"
    $fileName = Join-Path $env:TEMP ([System.IO.Path]::GetFileName($scriptUrl))
    (New-Object Net.WebClient).DownloadFile($scriptUrl, $fileName)
    if ($usePwsh) {
        & "pwsh.exe" -NoProfile -ExecutionPolicy Unrestricted -File $fileName
    }
    else {
        & "powershell.exe" -NoProfile -ExecutionPolicy Unrestricted -File $fileName
    }
}

RunScript -scriptUrl 'https://raw.githubusercontent.com/freddydk/nav-arm-templates/refs/heads/main/disableDefender.ps1'
RunScript -scriptUrl 'https://raw.githubusercontent.com/freddydk/nav-arm-templates/refs/heads/main/downloadGenericImage.ps1'
RunScript -scriptUrl 'https://raw.githubusercontent.com/freddydk/nav-arm-templates/refs/heads/main/setupGeneric1.ps1'
RunScript -scriptUrl 'https://raw.githubusercontent.com/freddydk/nav-arm-templates/refs/heads/main/setupGeneric2.ps1'
RunScript -scriptUrl 'https://raw.githubusercontent.com/freddydk/nav-arm-templates/refs/heads/main/setupPreRequisites.ps1'

# Setup BC
$ENV:ACCEPT_EULA = 'Y'
$ENV:ACCEPT_INSIDEREULA = 'Y'
$ENV:useSSL = 'N'
$ENV:enableApiServices = 'Y'
$ENV:memory = '12G'
$ENV:isBcSandbox = 'N'
$ENV:auth = 'UserPassword'
$ENV:username = $adminUsername
$ENV:password = $adminPassword
$ENV:locale = 'da-DK'
$ENV:filesOnly = 'false'
$ENV:bakFile = $bakFile
$ENV:artifactUrl = $artifactUrl
RunScript -scriptUrl 'https://raw.githubusercontent.com/freddydk/nav-arm-templates/refs/heads/main/setupBC.ps1'

Stop-Transcript
