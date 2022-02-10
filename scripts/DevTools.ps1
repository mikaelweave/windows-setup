choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y python
choco install -y nodejs.install

choco install -y vscode
choco install -y visualstudio2022professional-preview --pre 

choco install -y 7zip.install
choco install -y sysinternals
choco install -y postman

choco install -y azure-cli

choco install -y sql-server-2019
choco install -y azure-cosmosdb-emulator

# Pin items to the task bar
Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles}\Microsoft VS Code\Code.exe"