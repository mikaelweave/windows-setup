Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    <#
    .SYNOPSIS
    Unzips a zip file into a folder
    .DESCRIPTION
    Allows the user to unzip a zip file into a specified folder
    .EXAMPLE
    Unzip "C:\a.zip" "C:\a"
    .PARAMETER zipFile
    Full path to zip file
    .PARAMETER command
    Directory to extact zip file to 
    #>
    [CmdletBinding()]
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

#if Arch directory exists already, ask the user if they want to remove it and re-install
if(Test-Path -Path "$env:USERPROFILE\bin\Arch\") {
    $answer = Read-Host "It looks like Arch is already installed. (R)einstall or (A)bort??"
    while("R","A", "r", "a" -notcontains $answer)
    {
        $answer = Read-Host "(R)einstall or (A)bort??"
    }

    if ("a", "A" -contains $answer)
    {
        exit
    }
    
    # Remove old arch
    & "$env:USERPROFILE\bin\Arch\Arch.exe" clean
    Remove-Item -Force -Recurse "$env:USERPROFILE\bin\Arch\"
}

# Tell our script to use TLS1.2 (github requires this)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Get latest bundle
$wslJson = Invoke-WebRequest 'https://api.github.com/repos/yuk7/ArchWSL/releases/latest' -UseBasicParsing | ConvertFrom-Json;
Invoke-WebRequest $("https://github.com/yuk7/ArchWSL/releases/download/$($wslJson.tag_name)/Arch.zip") -UseBasicParsing -OutFile "$env:USERPROFILE\Downloads\Arch.zip";

# Extract Arch
New-Item -ItemType Directory -Force -Path $($env:USERPROFILE + "\bin\Arch\")
Unzip $($env:USERPROFILE + "\Downloads\Arch.zip") $($env:USERPROFILE + "\bin\Arch\")

# Run the installer
Write-Host "Installing Arch WSL..." 
& "$env:USERPROFILE\bin\Arch\Arch.exe"

Write-Host "Setting up user..."
$archUser = Read-Host -Prompt 'What do you want your Arch user name to be?'
& "$env:USERPROFILE\bin\Arch\Arch.exe" run "useradd --create-home -g users -G wheel $archUser"
& "$env:USERPROFILE\bin\Arch\Arch.exe" run "passwd $archUser"
& "$env:USERPROFILE\bin\Arch\Arch.exe" run pacman-key --init
& "$env:USERPROFILE\bin\Arch\Arch.exe" run pacman-key --populate

# Change our mirror to OSU (go beavs)
& "$env:USERPROFILE\bin\Arch\Arch.exe" run "sed -i -e 's/^/#/' /etc/pacman.d/mirrorlist"
& "$env:USERPROFILE\bin\Arch\Arch.exe" run 'echo "Server = http://ftp.osuosl.org/pub/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist'

# Install yay (AUR Helper)
& "$env:USERPROFILE\bin\Arch\Arch.exe" run 'mkdir yay && cd yay'
& "$env:USERPROFILE\bin\Arch\Arch.exe" run 'wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay'
& "$env:USERPROFILE\bin\Arch\Arch.exe" config --default-user $archUser
& "$env:USERPROFILE\bin\Arch\Arch.exe" run  'makepkg -Acs'
& "$env:USERPROFILE\bin\Arch\Arch.exe" config --default-user $root
pacman -U yay*

# LAST THING - Change the default user to not root
& "$env:USERPROFILE\bin\Arch\Arch.exe" config --default-user $archUser
