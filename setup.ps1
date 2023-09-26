###########################
#### Script Setup
###########################
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$cancel = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $cancel)

$FolderName = "$HOME\bin"
if (-Not (Test-Path $FolderName))
{
    New-Item $FolderName -ItemType Directory
}

function WingetInstallFromList($apps)
{
    Foreach ($app in $apps) {
	
        if ($app.Contains("installSearchName"))
        {
	    Write-Host "Searching winget for app by name $($app.installSearchName)"
            $listApp = winget list --name $app.installSearchName --accept-source-agreements --accept-package-agreements
            $checkName=$app.installSearchName
        }
        else
        {
	    Write-Host "Searching winget for EXACT app by name $($app.name)"
            $listApp = winget list --exact -q $app.name --accept-source-agreements --accept-package-agreements
            $checkName=$app.name
        }

        Write-Host "Found $checkName"
        
        if (![String]::Join("", $listApp).Contains($checkName)) {
            Write-host "Installing:" $app.name
            if ($app.source -ne $null) {
		$command = "winget install --exact --silent $($app.name) --source $($app.source)"
            }
            else {
                $command = "winget install --exact --silent $($app.name)"
            }

	    $command += " --accept-source-agreements --accept-package-agreements"
	    if ($app.Contains("additionalArgs")) {
		$command += " $additionalArgs"
	    }
	    Invoke-Expression $command
            
        }
        else {
            Write-host "Skipping Install of $($app.name)..."
        }
    }
}

###########################
#### System Configuration
###########################

#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name "AllowDevelopmentWithoutDevLicense" -Value 1

# Make windows clock play nice with Linux
# Only do this if you are dual-booting with Linux and want to set the system clock to UTC.
# Set-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\TimeZoneInformation -Name "RealTimeIsUniversal" -Value 1 -Type "Dword"


###########################
#### Dev Apps
###########################

#Install New apps
Write-Output "Installing Dev Apps"
$devApps = @(
#    @{name = "GnuPG.Gpg4win" },
    @{name = "Python.Python.3.10"; installSearchName = "Python" },
    @{name = "OpenJS.NodeJS" },
    @{name = "Microsoft.AzureCLI" }, 
    @{name = "Microsoft.PowerShell" }, 
    @{name = "Microsoft.VisualStudioCode"; additionalArgs = "--override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" }, 
    @{name = "Microsoft.AzureStorageExplorer" }, 
    @{name = "Microsoft.PowerToys" }, 
    @{name = "Git.Git" }, 
#    @{name = "Docker.DockerDesktop" },
    @{name = "dotnet-sdk-7" },
    @{name = "aspnetcore-7" },
    @{name = "GitHub.cli" },
    @{name = "mcmilk.7zip-zstd" },
    @{name = "Postman.Postman" },
    @{name = "Microsoft.SQLServer.2019.Developer" },
    @{name = "Microsoft.AzureCosmosEmulator" },
    @{name = "Microsoft.VisualStudio.2022.Enterprise-Preview" }
);

WingetInstallFromList($devApps)

###########################
#### Misc Apps
###########################

#Install New apps
Write-Output "Installing Misc. Apps"

#$miscApps = @(
#    @{name = "Lexikos.AutoHotkey" },
#    @{name = "Google.Chrome" },
#    @{name = "Greenshot.Greenshot"; installSearchName = "Greenshot" },
#    @{name = "wandersick.AeroZoom" },
#    @{name = "Dropbox.Dropbox"; installSearchName = "Dropbox" },
#    @{name = "Notion.Notion"; installSearchName = "Notion" },
#    @{name = "Agilebits.1Password" }
#);

# WingetInstallFromList($miscApps)

###########################
#### Colemak
###########################

$title = "Colemak"
$message = "Do you want to install the Colemak layout?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    Write-Host "Installing Colemak"
    Invoke-WebRequest -Uri "https://colemak.com/pub/windows/Colemak-1.1-Caps-Lock-Unchanged.zip" -OutFile $HOME\Downloads\colemak.zip
    $FolderName = "$HOME\bin\colemak"
    if (-Not (Test-Path $FolderName))
    {
        New-Item $FolderName -ItemType Directory
    }
    Expand-Archive -LiteralPath $HOME\Downloads\colemak.zip -DestinationPath $HOME\bin\colemak -Force
    & $HOME\bin\colemak\setup.exe /a
  }1{
    Write-Host "Skipping Colemak"
  }2{
  Write-Host "Exiting script"
  exit
  }
}


###########################
#### File Explorer Settings
###########################

#--- Windows Features ---
# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
# will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
#adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
#opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
#taskbar where window is open for multi-monitor
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2


###########################
#### Removing default apps
###########################

function removeApp {
	Param ([string]$appName)
	Write-Output "Trying to remove $appName"
	Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where DisplayName -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
	"Microsoft.BingFinance"
	"Microsoft.3DBuilder"
	"Microsoft.BingFinance"
	"Microsoft.BingNews"
	"Microsoft.BingSports"
	"Microsoft.BingWeather"
	"Microsoft.CommsPhone"
	"Microsoft.Getstarted"
	"Microsoft.WindowsMaps"
	"*MarchofEmpires*"
	"Microsoft.GetHelp"
	"Microsoft.Messaging"
	"*Minecraft*"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.OneConnect"
	"Microsoft.WindowsPhone"
	"Microsoft.WindowsSoundRecorder"
	"*Solitaire*"
	"Microsoft.MicrosoftStickyNotes"
	"Microsoft.Office.Sway"
	"Microsoft.XboxApp"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"
	"Microsoft.NetworkSpeedTest"
	"Microsoft.FreshPaint"
	"Microsoft.Print3D"
	"*Autodesk*"
	"*BubbleWitch*"
    "king.com*"
    "G5*"
	"*Dell*"
	"*Facebook*"
	"*Keeper*"
	"*Netflix*"
	"*Twitter*"
	"*Plex*"
	"*.Duolingo-LearnLanguagesforFree"
	"*.EclipseManager"
	"ActiproSoftwareLLC.562882FEEB491" # Code Writer
	"*.AdobePhotoshopExpress"
	#"*Xbox*"
	"*Disney*"
	"*Clipchamp*"
	"Prime*"
	"*TikTok*"
	"*Facebook*"
);

foreach ($app in $applicationList) {
    removeApp $app
}


###########################
#### Autohotkey Setup
###########################


$title = "Autohotkey"
$message = "Do you want to install Mikael's custom AutoHotkey setup?"
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
switch ($result) {
  0{
    Write-Host "Installing Mikael's super special auto hot key setup..."
    mkdir $HOME\bin\AutoHotKey

    # Fetch files from GitHub
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/AlwaysOnTop.ahk" -OutFile $HOME\bin\AutoHotKey\AlwaysOnTop.ahk
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/endolith/876629/raw/8e237cf3ed79f33e85af21b4823ffe3d6685161f/AutoCorrect.ahk" -OutFile $HOME\bin\AutoHotKey\AutoCorrect.ahk
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/Main.ahk" -OutFile $HOME\bin\AutoHotKey\Main.ahk
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/text_replace.ico" -OutFile $HOME\bin\AutoHotKey\text_replace.ico
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/startup.cmd" -OutFile $HOME\bin\AutoHotKey\startup.cmd

    $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
    $newpath = "$oldpath;$HOME\bin"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

    # Make the startup script...well..startup automatically
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd.lnk")
    $Shortcut.TargetPath = "$env:USERPROFILE\bin\startup.cmd"
    $Shortcut.Save()
  }1{
    Write-Host "Skipping Mikael's super special auto hot key setup..."
  }2{
  Write-Host "Exiting script"
  exit
  }
}

###########################
#### WSL
###########################
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName containers -All -NoRestart
wsl --set-default-version 2
wsl --install -d Ubuntu
