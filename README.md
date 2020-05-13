# windows-setup
Script and supporting files to setup a Windows dev computer to my liking 😊

## How to use from a fresh install
Just copy the code block and paste it into a new command prompt. If this asks to Cleanup Windows multiple times after a reboot, say "No" after the first time.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 

# Install Boxstarter
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;. iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

# Run Boxstarter script from this repo
$cred=Get-Credential
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/mikaelsnavy/windows-setup/master/boxstarter
```
