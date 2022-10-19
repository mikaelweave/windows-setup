# Ensure proper version of GPG is first in path
cinst gpg4win --cacheLocation="C:\temp"

cinst git --package-parameters="'/GitOnPath /WindowsTerminal'" --cacheLocation="C:\temp"
cinst python --cacheLocation="C:\temp"
cinst nodejs.install --cacheLocation="C:\temp"

cinst vscode --cacheLocation="C:\temp"
cinst visualstudio2022professional-preview --pre --cacheLocation="C:\temp"

cinst 7zip.install --cacheLocation="C:\temp"
cinst sysinternals --cacheLocation="C:\temp"
cinst postman --cacheLocation="C:\temp"

cinst azure-cli --cacheLocation="C:\temp"

cinst sql-server-2019 --cacheLocation="C:\temp"
cinst azure-cosmosdb-emulator --cacheLocation="C:\temp"

# Pin items to the task bar
Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles}\Microsoft VS Code\Code.exe"
