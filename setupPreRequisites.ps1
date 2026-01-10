# Install any additional prerequisites for Business Central
$ErrorActionPreference = 'Stop'
choco feature enable -n=allowGlobalConfirmation
choco install git -y --no-progress
choco install 7zip -y --no-progress
