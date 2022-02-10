Invoke-WebRequest -Uri "https://colemak.com/pub/windows/Colemak-1.1-Caps-Lock-Unchanged.zip" -OutFile $HOME\Downloads\colemak.zip
mkdir $HOME\Downloads\colemak
Expand-Archive -LiteralPath $HOME\Downloads\colemak.zip -DestinationPath $HOME\Downloads\colemak
& $HOME\Downloads\colemak\setup.exe /a
