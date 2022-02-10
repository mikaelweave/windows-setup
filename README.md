# Windows Setup

Setting up a new computer for development and general use is a pain. Instead of spending days to get everything just right, why not just script it out? This repo uses [Chocolatey](https://chocolatey.org/) and [Boxstarter](https://boxstarter.org/) to provide an easy, quick, and **opinionated** computer setup that I use for all my Windows machines.

Please fork this repository, and modify the scripts to your liking if you want to use this approach yourself. There are some specialized setup in this, like the *colemak* keyboard layout.

## Install Links

### Click [here](http://boxstarter.org/package/url?https://raw.githubusercontent.com/mikaelweave/windows-setup/main/setup.ps1) to run the setup script.


***


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
- Installs some Misc Apps
  - Ditto Clipboard Manager
  - AutoHotKey (with some scripts)
  - Greenshot
  - ZoomIt
  - Dropbox
  - Notion
- Installs Docker
- Installs WSL with Ubuntu and Arch Linux distros
  


## Resources
- This repository was inspired by [windows-dev-box-setup-scripts](https://github.com/microsoft/windows-dev-box-setup-scripts).
- [Chocolatey](https://chocolatey.org/)
- [Boxstarter](https://boxstarter.org/)