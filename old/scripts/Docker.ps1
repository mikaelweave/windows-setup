# https://github.com/microsoft/windows-dev-box-setup-scripts/blob/d488050ca9111e903cf0a5706d3de4e072fcbd89/scripts/Docker.ps1

Enable-WindowsOptionalFeature -Online -FeatureName containers -All
RefreshEnv
cinst docker-desktop --cacheLocation="C:\temp"
cinst vscode-docker --cacheLocation="C:\temp"