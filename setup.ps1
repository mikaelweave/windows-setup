# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for desktop app development
# Taken and modified from https://github.com/microsoft/windows-dev-box-setup-scripts/blob/ee2a2cf65bfe76b915bf02d3e5475e7dccc51aa8/dev_app.ps1

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

# Choco temp dir
mkdir C:\temp

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "Colemak.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "DevTools.ps1";
executeScript "Web.ps1";
executeScript "MiscApps.ps1";
executeScript "AutoHotKey.ps1";
executeScript "WSL.ps1";
executeScript "WSLArch.ps1";
executeScript "Docker.ps1";

cinst visualstudio2017community --package-parameters="'--add Microsoft.VisualStudio.Component.Git'"
Update-SessionEnvironment #refreshing env due to Git install

#--- UWP Workload and installing Windows Template Studio ---
cinst visualstudio2017-workload-azure
cinst visualstudio2017-workload-universal
cinst visualstudio2017-workload-manageddesktop
cinst visualstudio2017-workload-nativedesktop

executeScript "WindowsTemplateStudio.ps1";
executeScript "GetUwpSamplesOffGithub.ps1";

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula