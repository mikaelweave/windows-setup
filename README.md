# Windows Setup

Setting up a new computer for development and general use is a pain. Instead of spending days to get everything just right, why not just script it out? This repo uses winget to provide an easy, quick, and **opinionated** computer setup that I use for all my Windows machines.

Please fork this repository, and modify the scripts to your liking if you want to use this approach yourself. There are some specialized setup in this, like the *colemak* keyboard layout.

## Install

```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/mikaelweave/windows-setup/main/setup.ps1'))"
```

## What does this script do?
- Remove some default windows apps
- Installs Colemak keyboard layout
- Tweak explorer, and install [Files](https://github.com/files-community/Files)
- Installs some developer tools
  - Git
  - Python
  - NodeJS
  - Visual Studio Code
  - Visual Studio 2022
  - 7Zip
  - SysInternals
  - Postman
  - Azure CLI
  - SQL Server 2019 Developer
  - CosmosDB Emulator
  - more...
- Installs some Misc Apps
  - AutoHotKey (with some scripts)
  - Greenshot
  - ZoomIt
  - Dropbox
  - Notion
- Installs Docker
- Installs WSL (you will need to install ubuntu)
  

## Resources
- This repository was inspired by [windows-dev-box-setup-scripts](https://github.com/microsoft/windows-dev-box-setup-scripts).
- [Chocolatey](https://chocolatey.org/)
- [Boxstarter](https://boxstarter.org/)