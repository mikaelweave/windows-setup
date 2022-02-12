mkdir $HOME\bin
mkdir $HOME\bin\AutoHotKey

# Fetch files from GitHub
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/AlwaysOnTop.ahk" -OutFile $HOME\bin\AutoHotKey\AlwaysOnTop.ahk
Invoke-WebRequest -Uri "https://gist.githubusercontent.com/endolith/876629/raw/8e237cf3ed79f33e85af21b4823ffe3d6685161f/AutoCorrect.ahk" -OutFile $HOME\bin\AutoHotKey\AutoCorrect.ahk
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/Main.ahk" -OutFile $HOME\bin\AutoHotKey\Main.ahk
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/text_replace.ico" -OutFile $HOME\bin\AutoHotKey\text_replace.ico
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/startup.cmd" -OutFile $HOME\bin\AutoHotKey\startup.cmd

$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = “$oldpath;$HOME\bin”
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

# Make the startup script...well..startup automatically
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\bin\startup.cmd"
$Shortcut.Save()