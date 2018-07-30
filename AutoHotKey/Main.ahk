; #These are a few of my favorite things
#Include %A_ScriptDir%\AutoCorrect.ahk
#Include %A_ScriptDir%\AlwaysOnTop.ahk

; ##### Program Killer #####
^!k:: Run %ProgramFiles%\AutoHotkey\Kill.exe 

; ### Paste RAW ###
#IfWinActive ahk_class ConsoleWindowClass
^V::
SendInput {Raw}%clipboard%
return
#IfWinActive