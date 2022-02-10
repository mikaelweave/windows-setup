# https://github.com/microsoft/windows-dev-box-setup-scripts/blob/d488050ca9111e903cf0a5706d3de4e072fcbd89/scripts/Docker.ps1

Enable-WindowsOptionalFeature -Online -FeatureName containers -All
RefreshEnv
choco install -y docker-desktop
choco install -y vscode-docker