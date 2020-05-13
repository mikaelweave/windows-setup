# windows-setup
Script and supporting files to setup a Windows dev computer to my liking. 😊 To run this script, you have to understand what the functions do and what will be the implications for you if you run them. Some functions lower security, hide controls or uninstall applications. If you're not sure what the script does, do not attempt to run it!

## How to use from a fresh install
Just copy the code block and paste it into a new command prompt. If you get an error while installing asking for a reboot (especially around WSL), reboot and rerun the script.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 

# Install Boxstarter
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;. iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

# Run Boxstarter script from this repo
$cred=Get-Credential
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/mikaelsnavy/windows-setup/master/boxstarter -DisableReboots
```
