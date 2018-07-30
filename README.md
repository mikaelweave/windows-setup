# windows-setup
Script and supporting files to setup a Windows dev computer to my liking 😊

## How to use from a fresh install
Just copy the code block and paste it into a new PowerShell window RUN AS ADMIN

```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/mikaelsnavy/windows-setup/archive/master.zip" -OutFile "windows-setup.zip"
Expand-Archive -LiteralPath "windows-setup.zip" -DestinationPath windows-setup\
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
windows-setup\windows-setup-master\setup.ps1
```