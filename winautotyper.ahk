#SingleInstance
Menu, Tray, NoStandard
Menu, Tray, add, winAutotyper, Set_text
Menu, Tray, Add,
Menu, Tray, Add, Set Input Text, set_text
Menu, Presets, Add, [Add preset], add_save
Menu, Presets, Add, [Delete preset], delete_save
Menu, Presets, Add,
gosub, update_tray
Menu, Tray, Add, Presets, :Presets
Menu, Tray, Add,
For i, key in ["F10", "F11", "F12", "","Insert", "Delete", "Home", "End", "", "CapsLock", "RShift", "RCtrl", "XButton1", "Xbutton2"]
	Menu, KeysMenu, add, %key%, hotkey_swap
Menu, Tray, Add, `Hotkey, :KeysMenu
For i, num in [0, 5, 10, 20, 30, 40, 50, 100, 150, 200, 300, 500]
	Menu, DelayMenu, add, %num%, inputdelay
Menu, Tray, add, Input Delay (ms), :DelayMenu
Menu, Tray, add,
Menu, Tray, Add, About, about_window
Menu, Tray, Add, Exit, exit
Menu, Tray, Default, winAutotyper
Menu, Tray, Disable, winAutotyper
 
IniRead, key, %A_ScriptDir%\saves.ini, options, hkey
If (key = "ERROR") {
	IniWrite, CapsLock, %A_ScriptDir%\saves.ini, options, hkey
	key = CapsLock
}

TrayTip, winAutotyper, Current hotkey: %key%`nDouble click on tray icon to set `input text`nRight click for settings,, 1

Hotkey, %key%, type_text
return

type_text:
	SetKeyDelay, %kdelay%
	Send, {Raw}%txt%
return

set_text:
	InputBox, resp, winAutotyper, Enter text for auto input and click "OK"
	If Errorlevel = 0
		txt = %resp%
return

hotkey_swap:
	try
		HotKey, %A_ThisHotkey%, Off
	catch
		HotKey, %key%, Off
	IniWrite, %A_ThisMenuItem%, %A_ScriptDir%\saves.ini, options, hkey
	HotKey, %A_ThisMenuItem%, type_text
	Return
return

exit:
	ExitApp
return

update_tray:
	IniRead, savesect, %A_ScriptDir%\saves.ini, saves
	Loop, parse, savesect, `n, `r
	{
		key := StrSplit(A_LoopField, "=")[1]
		Menu, Presets, Add, %key%, load_save
	}
	
return

add_save:
	Inputbox, newname, winAutotyper, Enter name for new preset
	If (errorlevel = 0) and (newname != "")
		Inputbox, newtext, winAutotyper, Enter text for new preset
	If (errorlevel = 0) and (newtext != "")
		IniWrite, %newtext%, %A_ScriptDir%\saves.ini, saves, %newname%
	gosub, update_tray
return

load_save:
	IniRead, txt, %A_ScriptDir%\saves.ini, saves, %A_ThisMenuItem%
return

inputdelay:
	kdelay = %A_ThisMenuItem%
return

delete_save:
	Inputbox, deletename, winAutotyper, Enter a preset name to remove it
	If (errorlevel = 0) and (deletename != "") {
		IniDelete, %A_ScriptDir%\saves.ini, saves, %deletename%
	    try
			Menu, tray, Delete, %deletename% 
	}
	gosub, update_tray
return

about_window:
	MsgBox, 68, About winAutotyper, winAutotyper (c) notsyncing12309`n`nThis software is released under the MIT license.`nDo you want to open Github page?
	IfMsgBox, Yes
		Run, www.github.com/notsyncing12309/winautotyper
return