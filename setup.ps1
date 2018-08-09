function Ask-Command {
    <#
    .SYNOPSIS
    Yes or no prompt to run a command
    .DESCRIPTION
    Provides the user with a yes or no prompt to do something, if yes run a command
    .EXAMPLE
    Give an example of how to use it
    .PARAMETER prompt
    What are we asking the user to do?
    .PARAMETER command
    Command to execute if yes 
    #>
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$prompt,
      [Parameter(Mandatory=$True)]
      [string]$command
    )

    process {
        $answer = Read-Host $($prompt + " (Yes or No)")
        while("yes","no" -notcontains $answer)
        {
            $answer = Read-Host "Yes or No"
        }
        if ($answer -eq "yes") {
            Invoke-Expression $command
        }
    }
  }

######################################################
## Windows Cleanup
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Windows Cleanup" -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;

Ask-Command "Do you want to cleanup Windows?" $(". " + $PSScriptRoot + "\reclaimWindows10.ps1")

Write-Host 'Done!!!';
Write-Host ""

######################################################
## INSTALL PACKAGE MANAGERS
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Installing Scoop and Choco..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;

if (Get-Command "scoop" -errorAction SilentlyContinue) {
  Write-Host "scoop already installed, checking for updates"
  scoop update scoop
} else {
    Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

# choco installer is more forgiving :)
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host 'Done!!!';
Write-Host ""

######################################################
## INSTALL APPS THROUGH SCOOP
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Installing basic apps through scoop (cmder, curl, docker, python)..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;

scoop install cmder
scoop install curl
scoop install dotnet-sdk
scoop install python
scoop install docker

# Optional installs
Ask-Command "Do you want to install r?" "scoop install r"
Ask-Command "Do you want to install rust?" "scoop install rust"

Write-Host 'Done!!!';
Write-Host ""

######################################################
# INSTALL APPS THROUGH CHOCO
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Installing apps through choco (Greenshot, git, ditto, vscode, microsoft teams, postman, 7-Zip, ZoomIt)..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;
choco install greenshot -y
choco install git.install -y
choco install ditto -y
choco install vscode -y
choco install 7zip -y
choco install zoomit -y
choco install autohotkey -y

Ask-Command "Do you want to install Microsoft Teams?" "choco install microsoft-teams.install -y"
Ask-Command "Do you want to install postman?" "choco install postman -y"
Ask-Command "Do you want to install Azure Storage Explorer?" "choco install microsoftazurestorageexplorer -y"

# Git config
$oldPath = $(Convert-Path .)
Set-Location "C:\Program Files\Git\cmd"
$name = Read-Host 'What name do you want to use for git?'
$email = Read-Host 'What email do you want to use for git?'
git config --global user.name $name
git config --global user.email $email
Set-Location $oldPath

Write-Host 'Done!!!';
Write-Host ""

######################################################
# Autohotkey customization
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Installing AutoHotKey customization..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;
# Startup script setup
New-Item -ItemType Directory -Force -Path $($env:USERPROFILE + "\bin")
Copy-Item $($PSScriptRoot + "\startup.cmd") -Destination $($env:USERPROFILE + "/bin/") -Force
# AutoHotKey setup :) 
Copy-Item $($PSScriptRoot + "\AutoHotKey") -Destination $($env:USERPROFILE + "\bin\") -Recurse -Force

# Make the startup script...well..startup automatically
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($env:USERPROFILE + "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd.lnk")
$Shortcut.TargetPath = $env:USERPROFILE + "\bin\startup.cmd"
$Shortcut.Save()
Write-Host 'Done!!!';
Write-Host ""

######################################################
# Visual Studio 2017 Enterprise
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Opening Visual Studio 2017 Enterprise installer..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;
Invoke-WebRequest -Uri "https://aka.ms/vs/15/release/vs_enterprise.exe" -UseBasicParsing -OutFile "vs_enterprise.exe"
.\vs_enterprise.exe
Write-Host 'Popping up VS Installer now!';
Write-Host -NoNewLine 'Press any key to continue once done...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host ""
Write-Host ""

######################################################
# VS Code Setup (using setting sync)
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Install setting sync for VSCode..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;

Write-Host "Launching VS Code to create temp files. Please close it and press any key to continue..."
& "C:\Program Files\Microsoft VS Code\Code.exe" > $null
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

$file = $($env:USERPROFILE + "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\setup_settings_sync.cmd")
if (Test-Path $file) { Remove-Item $file }
Add-Content $file 'code --install-extension Shan.code-settings-sync'
Add-Content $file 'del /f/q "%~0" | exit'

$settingsPath = $($PSScriptRoot + "\vscode-settings.json")
Write-Host "SETTINGS" $settingsPath
Copy-Item $settingsPath -Destination $($env:USERPROFILE + "\AppData\Roaming\Code\User\settings.json") -Force

Write-Host "VS Code Setting Sync will be installed on the next reboot time you use Code."
Write-Host ""

######################################################
# Notion
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "MANUAL STEP: Install Notion" -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;
Write-Host "You can install notion from http://www.notion.so..."
Write-Host -NoNewLine 'Press any key to continue once done...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host ""
Write-Host ""

###############################################
# Windows Subsystem for Linux
###############################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Installing WSL. You will still need to install a Linux distro through the store (like Ubuntu)" -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux;

Write-Host "Script is complete! You should be (mostly) setup" -ForegroundColor Green;
Write-Host -NoNewLine 'Press any key to exit...' -ForegroundColor Green;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
