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

# Refresh env is usefull in many places :)
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force; Get-Help Update-SessionEnvironment -Full > $null
Update-SessionEnvironment

Write-Host 'Done!!!';
Write-Host ""

######################################################
## INSTALL APPS THROUGH SCOOP
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Installing basic apps through scoop (curl, docker, python)..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;

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
choco install Microsoft-Windows-Subsystem-Linux -source windowsfeatures -y
choco install Microsoft-Hyper-V-All -source windowsFeatures -y

Ask-Command "Do you want to install Microsoft Teams?" "choco install microsoft-teams.install -y"
Ask-Command "Do you want to install Office365 (proplus)?" "choco install office365proplus -y"
Ask-Command "Do you want to install postman?" "choco install postman -y"
Ask-Command "Do you want to install Azure Storage Explorer?" "choco install microsoftazurestorageexplorer -y"
Ask-Command "Do you want to install Cacher?" "choco install cacher -y"

Update-SessionEnvironment

# Git config
$answer = Read-Host $("Do you want to setup your git info? (Yes or No)")
while("yes","no" -notcontains $answer)
{
    $answer = Read-Host "Yes or No"
}
if ($answer -eq "yes") {
    $name = Read-Host 'What name do you want to use for git?'
    $email = Read-Host 'What email do you want to use for git?'
    git config --global user.name $name
    git config --global user.email $email
    Write-Host 'Done!!!';
}

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

Update-SessionEnvironment

######################################################
# VS Code Setup (using setting sync)
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Install setting sync for VSCode..." -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;

Write-Host "Launching VS Code to create temp files. Please close it and press any key to continue..."
& "C:\Program Files\Microsoft VS Code\Code.exe" > $null
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

code --install-extension Shan.code-settings-sync
Ask-Command "Do you want to copy templated VS Code settings?" $("Copy-Item " + $($PSScriptRoot + "\vscode-settings.json") + "-Destination " + $($env:USERPROFILE + "\AppData\Roaming\Code\User\settings.json") + "-Force")

Write-Host ""

######################################################
# Notion
######################################################
Write-Host "###############################################" -ForegroundColor White;
Write-Host "MANUAL STEP: Install Notion" -ForegroundColor White;
Write-Host "###############################################" -ForegroundColor White;
Write-Host "Popping up Edge to download/install notion";
start microsoft-edge:https://www.notion.so/desktop
Write-Host -NoNewLine 'Press any key to continue once done...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host ""
Write-Host ""

###############################################
# Ubuntu WSL
###############################################
.\ubuntu-wsl-setup.ps1

###############################################
# Arch WSL
###############################################
.\arch-wsl-setup.ps1

Write-Host "Script is complete! You should be (mostly) setup" -ForegroundColor Green;
Write-Host -NoNewLine 'Press any key to exit...' -ForegroundColor Green;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');


$($env:USERPROFILE + "\bin")