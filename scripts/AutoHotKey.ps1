mkdir $HOME\bin

# Fetch files from GitHub
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/AlwaysOnTop.ahk" -OutFile $HOME\bin\AlwaysOnTop.ahk
Invoke-WebRequest -Uri "https://gist.githubusercontent.com/endolith/876629/raw/8e237cf3ed79f33e85af21b4823ffe3d6685161f/AutoCorrect.ahk" -OutFile $HOME\bin\AutoCorrect.ahk
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/Main.ahk" -OutFile $HOME\bin\Main.ahk
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/text_replace.ico" -OutFile $HOME\bin\text_replace.ico
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mikaelweave/windows-setup/master/AutoHotKey/startup.cmd" -OutFile $HOME\bin\startup.cmd

# Make the startup script...well..startup automatically
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\bin\startup.cmd"
$Shortcut.Save()