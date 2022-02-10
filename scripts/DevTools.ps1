cinst git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
cinst python
cinst nodejs.install

cinst vscode
cinst visualstudio2022professional-preview --pre 

cinst 7zip.install
cinst sysinternals
cinst postman

cinst azure-cli

cinst sql-server-2019
cinst azure-cosmosdb-emulator

# Pin items to the task bar
Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles}\Microsoft VS Code\Code.exe"