###############################
#--- Ubuntu WSL Setup---
#
# This script does the following:
#  - Ensures WSL is enabled
#  - Adds Ubuntu app from the store
#  - Updates Ubuntu (using apt)
#  - Installs dev tools (python, pip, Azure cli) 
###############################
Write-Host "Downloading Ubuntu WSL..."
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx

# run the distro once and have it install locally with a blank root user
Ubuntu1804 install --root

Write-Host "Installing tools inside the Ubuntu WSL distro..."
Ubuntu1804 run 'apt update; apt upgrade -y;'

# devtools
Ubuntu1804 run 'apt-get install python3 python-pip vim git -y'

# azure cli
$azureCliCommand = @'
AZ_REPO=$(lsb_release -cs);
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |  tee /etc/apt/sources.list.d/azure-cli.list;
curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;
apt-get install apt-transport-https;
apt-get update && sudo apt-get install azure-cli;
'@
Ubuntu1804 run $azureCliCommand

# Add default user (not root)
$userName = Read-Host -Prompt "What do you want your Ubnutu WSL username to be?"
Ubuntu1804 run "adduser $userName; usermod -aG sudo $userName"
Ubuntu1804 config --default-user $userName

Write-Host "Finished setting up Ubuntu WSL environment!"