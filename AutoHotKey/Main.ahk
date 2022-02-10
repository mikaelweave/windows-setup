; #These are a few of my favorite things
#Include %A_ScriptDir%\autoCorrect.ahk
#Include %A_ScriptDir%\alwaysOnTop.ahk

; ##### Program Killer #####
^!k:: Run %ProgramFiles%\AutoHotkey\Kill.exe 

; ### Paste RAW ###
#IfWinActive ahk_class ConsoleWindowClass
^V::
SendInput {Raw}%clipboard%
return
#IfWinActive