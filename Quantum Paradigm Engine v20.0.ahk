#NoEnv
#SingleInstance Force
#MaxThreadsPerHotkey 32
ListLines, Off
Process, Priority,, Realtime
SendMode Input
SetWorkingDir %A_ScriptDir%
DetectHiddenWindows, On
SetControlDelay, -1
SetWinDelay, -1
SetMouseDelay, -1
SetKeyDelay, -1, -1

; --- PROFILE INI MATRIX SYSTEM SECTORS ---
IniRead, ActiveProfile, config.ini, System, ActiveProfile, 1
IniRead, ActiveColor, config.ini, System, ThemeColor, 0x050508

IniRead, SavedType, config.ini, Profile%ActiveProfile%, ActionType, Left Click
IniRead, SavedMode, config.ini, Profile%ActiveProfile%, TargetMode, Cursor
IniRead, SavedX1, config.ini, Profile%ActiveProfile%, XArray1, 0
IniRead, SavedY1, config.ini, Profile%ActiveProfile%, YArray1, 0
IniRead, SavedX2, config.ini, Profile%ActiveProfile%, XArray2, 0
IniRead, SavedY2, config.ini, Profile%ActiveProfile%, YArray2, 0
IniRead, SavedX3, config.ini, Profile%ActiveProfile%, XArray3, 0
IniRead, SavedY3, config.ini, Profile%ActiveProfile%, YArray3, 0
IniRead, SavedD1, config.ini, Profile%ActiveProfile%, Speed1, 50
IniRead, SavedD2, config.ini, Profile%ActiveProfile%, Speed2, 50
IniRead, SavedD3, config.ini, Profile%ActiveProfile%, Speed3, 50
IniRead, SavedUse1, config.ini, Profile%ActiveProfile%, ActiveV1, 1
IniRead, SavedUse2, config.ini, Profile%ActiveProfile%, ActiveV2, 0
IniRead, SavedUse3, config.ini, Profile%ActiveProfile%, ActiveV3, 0
IniRead, SavedHuman, config.ini, Profile%ActiveProfile%, OrganicMatrix, 0
IniRead, SavedBkg, config.ini, Profile%ActiveProfile%, Win32Hook, 0
IniRead, SavedStart, config.ini, Profile%ActiveProfile%, BootKey, F6
IniRead, SavedStop, config.ini, System, AbortKey, F5
IniRead, SavedHK1, config.ini, Profile%ActiveProfile%, CustomBind1, None
IniRead, SavedHK2, config.ini, Profile%ActiveProfile%, CustomBind2, None
IniRead, SavedHK3, config.ini, Profile%ActiveProfile%, CustomBind3, None
IniRead, SavedColorTrigger, config.ini, Profile%ActiveProfile%, ActiveColorTrigger, 0
IniRead, TargetColorHex, config.ini, Profile%ActiveProfile%, LockColorHex, 0xFF0000

Global TotalClicks := 0, SessionStart := 0, IsClicking := 0, ActiveMappingTarget := 0, TargetHwnd := 0
Global TargetX1 := SavedX1, TargetY1 := SavedY1, TargetX2 := SavedX2, TargetY2 := SavedY2, TargetX3 := SavedX3, TargetY3 := SavedY3
Global RunV1 := 0, RunV2 := 0, RunV3 := 0

CheckedCursor := (SavedMode = "Cursor") ? 1 : 0
CheckedFixed := (SavedMode = "Fixed") ? 1 : 0

; Rock-solid window dimension boundaries to block all typography crowding
Gui, Color, %ActiveColor%, 0x0C0C12 
Gui, +AlwaysOnTop -MinimizeBox +Owner +LastFound
WinSet, Transparent, 254 

Gui, Font, s16 Bold c0x00FFFF, Segoe UI
Gui, Add, Text, x20 y15 w540 h25 Center, QUANTUM PROTOCOL ENGINE v20.0

Gui, Font, s9 Bold c0xFF9900, Segoe UI
Gui, Add, Text, x30 y52 w165 h20, System Architecture Profile:
Gui, Add, DropDownList, x195 y48 w85 vProfileSelect gSwitchProfile cFFFFFF, Sheet 1||Sheet 2|Sheet 3
GuiControl, Choose, ProfileSelect, %ActiveProfile%

; Pure static premium theme buttons—Rainbow completely eliminated
Gui, Add, Button, x295 y48 w45 h22 gThemeMatrix, Void
Gui, Add, Button, x345 y48 w45 h22 gThemeCarbon, Ash
Gui, Add, Button, x395 y48 w45 h22 gThemeCyber, Cyber
Gui, Add, Button, x445 y48 w45 h22 gThemeOverlord, Rage

Gui, Font, s9 Bold c0xFF00FF, Segoe UI
Gui, Add, GroupBox, x20 y85 w540 h155, CORE DRIVER-LEVEL ATTACK MATRIX
Gui, Font, s9 Norm cFFFFFF, Segoe UI
Gui, Add, Text, x40 y115 w160 h20, Hardware Intercept Action:
Gui, Add, DropDownList, x210 y112 w160 vClickType cFFFFFF, Left Click||Right Click|Middle Click|Double Left
GuiControl, ChooseString, ClickType, %SavedType%

Gui, Add, CheckBox, x40 y150 w180 h20 vHumanize Checked%SavedHuman%, Organic Gaussian Humanizer
Gui, Add, CheckBox, x240 y150 w260 h20 vBackgroundMode Checked%SavedBkg% gBkgChange, Low-Level Kernel Background Mode

Gui, Add, CheckBox, x40 y185 w200 h20 vActiveColorTrigger Checked%SavedColorTrigger%, Pixel Color Trigger (Sniper Mode)
Gui, Add, Text, x250 y187 w100 h20, Hex Lock Code:
Gui, Add, Edit, x355 y184 w80 h22 vLockColorHex cFFFFFF, %TargetColorHex%
Gui, Add, Button, x445 y184 w55 h22 gGrabPixelColor, Pick

Gui, Font, s9 Bold c0x00FFCC, Segoe UI
Gui, Add, GroupBox, x20 y255 w540 h225, ASYMMETRIC MULTI-THREAD VECTORS
Gui, Font, s9 Norm cFFFFFF, Segoe UI
Gui, Add, Radio, x40 y285 w200 h20 vTargetMode Group gRadioChange Checked%CheckedCursor%, Active Cursor Tracking
Gui, Add, Radio, x250 y285 w260 h20 gRadioChange Checked%CheckedFixed%, Geometric Coordinate Lock Matrix

Gui, Add, CheckBox, x40 y322 w70 h20 vUseT1 Checked%SavedUse1%, Vector A:
Gui, Add, Button, x115 y320 w75 h22 vBtnCoord1 gGetCoordinates1, Lock Array
Gui, Add, Text, x200 y323 w110 h20 vCoordDisplay1 c0x00FFCC, X: %TargetX1% | Y: %TargetY1%
Gui, Add, Text, x315 y323 w60 h20, Interval:
Gui, Add, Edit, x380 y320 w40 h22 vDelay1 Number cFFFFFF, %SavedD1%
Gui, Add, Hotkey, x445 y320 w75 h22 vKeyV1, %SavedHK1%

Gui, Add, CheckBox, x40 y367 w70 h20 vUseT2 Checked%SavedUse2%, Vector B:
Gui, Add, Button, x115 y365 w75 h22 vBtnCoord2 gGetCoordinates2, Lock Array
Gui, Add, Text, x200 y368 w110 h20 vCoordDisplay2 c0x00FFCC, X: %TargetX2% | Y: %TargetY2%
Gui, Add, Text, x315 y368 w60 h20, Interval:
Gui, Add, Edit, x380 y365 w40 h22 vDelay2 Number cFFFFFF, %SavedD2%
Gui, Add, Hotkey, x445 y365 w75 h22 vKeyV2, %SavedHK2%

Gui, Add, CheckBox, x40 y412 w70 h20 vUseT3 Checked%SavedUse3%, Vector C:
Gui, Add, Button, x115 y410 w75 h22 vBtnCoord3 gGetCoordinates3, Lock Array
Gui, Add, Text, x200 y413 w110 h20 vCoordDisplay3 c0x00FFCC, X: %TargetX3% | Y: %TargetY3%
Gui, Add, Text, x315 y413 w60 h20, Interval:
Gui, Add, Edit, x380 y410 w40 h22 vDelay3 Number cFFFFFF, %SavedD3%
Gui, Add, Hotkey, x445 y410 w75 h22 vKeyV3, %SavedHK3%

Gui, Font, s7 c888888, Segoe UI
Gui, Add, Text, x380 y442 w50 h15, Delay (ms)
Gui, Add, Text, x445 y442 w75 h15, Macro Bind

Gui, Font, s9 Bold c0x9933FF, Segoe UI
Gui, Add, GroupBox, x20 y495 w540 h75, MASTER HARDWARE TRIPPERS
Gui, Font, s9 Norm cFFFFFF, Segoe UI
Gui, Add, Text, x40 y527 w110 h20, Fire Drive Engine:
Gui, Add, Hotkey, x155 y524 w75 h22 vStartHotkey, %SavedStart%
Gui, Add, Text, x270 y527 w110 h20, Emergency Scram:
Gui, Add, Hotkey, x385 y524 w75 h22 vStopHotkey, %SavedStop%

Gui, Font, s9 Bold c0x00FFFF, Segoe UI
Gui, Add, GroupBox, x20 y585 w540 h75, SYSTEM TELEMETRY LOAD INTERFACE
Gui, Font, s11 Bold c0xFF3333, Segoe UI
Gui, Add, Text, x40 y615 w150 h22 vStatusDisplay, ENGINE MATRIX OFFLINE
Gui, Font, s11 Bold cFFFFFF, Segoe UI
Gui, Add, Text, x200 y615 w340 h22 vTelemetryDisplay, CPS: 0.0 | Drive Operations: 0

Gui, Font, s8 Norm c444444, Segoe UI
Gui, Add, Text, x20 y672 w540 h20 Center, [Lock Array] -> Position Cursor -> Tap [SPACEBAR]

Gui, +MinimizeBox +SysMenu
Gui, Show, w580 h705, Quantum Paradigm Suite
SetTimer, BindHotkeys, -150
return
ThemeMatrix:
Gui, Color, 0x050508
IniWrite, 0x050508, config.ini, System, ThemeColor
return

ThemeCarbon:
Gui, Color, 0x1A1A22
IniWrite, 0x1A1A22, config.ini, System, ThemeColor
return

ThemeCyber:
Gui, Color, 0x060B16
IniWrite, 0x060B16, config.ini, System, ThemeColor
return

ThemeOverlord:
Gui, Color, 0x160202
IniWrite, 0x160202, config.ini, System, ThemeColor
return

BindHotkeys:
Gui, Submit, NoHide
if (OldStart != "") {
    Hotkey, *%OldStart%, Off, UseErrorLevel
    Hotkey, *%OldStop%, Off, UseErrorLevel
}
if (OldK1 != "" && OldK1 != "None")
    Hotkey, *%OldK1%, Off, UseErrorLevel
if (OldK2 != "" && OldK2 != "None")
    Hotkey, *%OldK2%, Off, UseErrorLevel
if (OldK3 != "" && OldK3 != "None")
    Hotkey, *%OldK3%, Off, UseErrorLevel

Hotkey, *%StartHotkey%, TriggerStart, On
Hotkey, *%StopHotkey%, TriggerStop, On

if (KeyV1 != "None" && KeyV1 != "") {
    Hotkey, *%KeyV1%, TriggerV1, On
    OldK1 := KeyV1
}
if (KeyV2 != "None" && KeyV2 != "") {
    Hotkey, *%KeyV2%, TriggerV2, On
    OldK2 := KeyV2
}
if (KeyV3 != "None" && KeyV3 != "") {
    Hotkey, *%KeyV3%, TriggerV3, On
    OldK3 := KeyV3
}
OldStart := StartHotkey
OldStop := StopHotkey
return

RadioChange:
BkgChange:
Gui, Submit, NoHide
return

SwitchProfile:
Gui, Submit, NoHide
ActiveProfile := ProfileSelect
IniWrite, %ActiveProfile%, config.ini, System, ActiveProfile
Reload
return

GetCoordinates1:
ActiveMappingTarget := 1
GuiControl, Disable, BtnCoord1
GuiControl,, CoordDisplay1, RESOLVING SECTOR...
return

GetCoordinates2:
ActiveMappingTarget := 2
GuiControl, Disable, BtnCoord2
GuiControl,, CoordDisplay2, RESOLVING SECTOR...
return

GetCoordinates3:
ActiveMappingTarget := 3
GuiControl, Disable, BtnCoord3
GuiControl,, CoordDisplay3, RESOLVING SECTOR...
return

#If (ActiveMappingTarget > 0)
*Space::
if (ActiveMappingTarget = 1) {
    MouseGetPos, TargetX1, TargetY1, TargetHwnd
    GuiControl,, CoordDisplay1, X: %TargetX1% | Y: %TargetY1%
    GuiControl, Enable, BtnCoord1
} else if (ActiveMappingTarget = 2) {
    MouseGetPos, TargetX2, TargetY2, TargetHwnd
    GuiControl,, CoordDisplay2, X: %TargetX2% | Y: %TargetY2%
    GuiControl, Enable, BtnCoord2
} else if (ActiveMappingTarget = 3) {
    MouseGetPos, TargetX3, TargetY3, TargetHwnd
    GuiControl,, CoordDisplay3, X: %TargetX3% | Y: %TargetY3%
    GuiControl, Enable, BtnCoord3
}
ActiveMappingTarget := 0
return
#If

GrabPixelColor:
Gui, +Disabled
MsgBox, 64, Color Matrix Intercept, Position cursor over target asset and tap [SPACEBAR] to index Hex value., 3
Loop {
    if GetKeyState("Space", "P") {
        MouseGetPos, ColorX, ColorY
        PixelGetColor, PickedColor, %ColorX%, %ColorY%, RGB
        GuiControl,, LockColorHex, %PickedColor%
        break
    }
    Sleep, 10
}
Gui, -Disabled
Gui, Show
return

TriggerStart:
Gui, Submit, NoHide
if (IsClicking = 1)
    return

IniWrite, %ClickType%, config.ini, Profile%ActiveProfile%, ActionType
IniWrite, % (TargetMode=1 ? "Cursor" : "Fixed"), config.ini, Profile%ActiveProfile%, TargetMode
IniWrite, %TargetX1%, config.ini, Profile%ActiveProfile%, XArray1
IniWrite, %TargetY1%, config.ini, Profile%ActiveProfile%, YArray1
IniWrite, %TargetX2%, config.ini, Profile%ActiveProfile%, XArray2
IniWrite, %TargetY2%, config.ini, Profile%ActiveProfile%, YArray2
IniWrite, %TargetX3%, config.ini, Profile%ActiveProfile%, XArray3
IniWrite, %TargetY3%, config.ini, Profile%ActiveProfile%, YArray3
IniWrite, %Delay1%, config.ini, Profile%ActiveProfile%, Speed1
IniWrite, %Delay2%, config.ini, Profile%ActiveProfile%, Speed2
IniWrite, %Delay3%, config.ini, Profile%ActiveProfile%, Speed3
IniWrite, %UseT1%, config.ini, Profile%ActiveProfile%, ActiveV1
IniWrite, %UseT2%, config.ini, Profile%ActiveProfile%, ActiveV2
IniWrite, %UseT3%, config.ini, Profile%ActiveProfile%, ActiveV3
IniWrite, %Humanize%, config.ini, Profile%ActiveProfile%, OrganicMatrix
IniWrite, %BackgroundMode%, config.ini, Profile%ActiveProfile%, Win32Hook
IniWrite, %StartHotkey%, config.ini, Profile%ActiveProfile%, BootKey
IniWrite, %StopHotkey%, config.ini, Profile%ActiveProfile%, AbortKey
IniWrite, %KeyV1%, config.ini, Profile%ActiveProfile%, CustomBind1
IniWrite, %KeyV2%, config.ini, Profile%ActiveProfile%, CustomBind2
IniWrite, %KeyV3%, config.ini, Profile%ActiveProfile%, CustomBind3
IniWrite, %ActiveColorTrigger%, config.ini, Profile%ActiveProfile%, ActiveColorTrigger
IniWrite, %LockColorHex%, config.ini, Profile%ActiveProfile%, LockColorHex

IsClicking := 1
SessionStart := A_TickCount
GuiControl,, StatusDisplay, DRIVE ENGINE ON
GuiControl, +c0x00FFFF, StatusDisplay
SetTimer, TelemetryEngine, 100  
SetTimer, CoreExecutionLoop, -1
return

TriggerStop:
IsClicking := 0
RunV1 := 0, RunV2 := 0, RunV3 := 0
GuiControl,, StatusDisplay, ENGINE MATRIX OFFLINE
GuiControl, +c0xFF3333, StatusDisplay
SetTimer, TelemetryEngine, Off
return

TriggerV1:
RunV1 := !RunV1
if (RunV1) {
    SessionStart := A_TickCount
    SetTimer, LoopVector1, -1
}
return

TriggerV2:
RunV2 := !RunV2
if (RunV2) {
    SessionStart := A_TickCount
    SetTimer, LoopVector2, -1
}
return

TriggerV3:
RunV3 := !RunV3
if (RunV3) {
    SessionStart := A_TickCount
    SetTimer, LoopVector3, -1
}
return

TelemetryEngine:
if (IsClicking = 0 && RunV1 = 0 && RunV2 = 0 && RunV3 = 0) {
    SetTimer, TelemetryEngine, Off
    return
}
ElapsedSec := (A_TickCount - SessionStart) / 1000
if (ElapsedSec <= 0) 
    ElapsedSec := 0.1
CurrentCPS := Round(TotalClicks / ElapsedSec, 1)
GuiControl,, TelemetryDisplay, CPS: %CurrentCPS% | Drive Operations: %TotalClicks%
return

CoreExecutionLoop:
While (IsClicking = 1) {
    Gui, Submit, NoHide
    if (TargetMode = 2) {
        if (UseT1 = 1 && IsClicking = 1) {
            if (ActiveColorTrigger = 1 && !VerifyTargetColor(TargetX1, TargetY1, LockColorHex)) {
                Sleep, 1
                continue
            }
            ExecuteActionPipeline(ClickType, TargetX1, TargetY1, BackgroundMode, TargetHwnd, Humanize)
            HandleSpeedThrottle(Delay1, Humanize)
        }
        if (UseT2 = 1 && IsClicking = 1) {
            if (ActiveColorTrigger = 1 && !VerifyTargetColor(TargetX2, TargetY2, LockColorHex)) {
                Sleep, 1
                continue
            }
            ExecuteActionPipeline(ClickType, TargetX2, TargetY2, BackgroundMode, TargetHwnd, Humanize)
            HandleSpeedThrottle(Delay2, Humanize)
        }
        if (UseT3 = 1 && IsClicking = 1) {
            if (ActiveColorTrigger = 1 && !VerifyTargetColor(TargetX3, TargetY3, LockColorHex)) {
                Sleep, 1
                continue
            }
            ExecuteActionPipeline(ClickType, TargetX3, TargetY3, BackgroundMode, TargetHwnd, Humanize)
            HandleSpeedThrottle(Delay3, Humanize)
        }
        if (UseT1 = 0 && UseT2 = 0 && UseT3 = 0) {
            Sleep, 10
        }
    } else {
        if (ActiveColorTrigger = 1) {
            MouseGetPos, CurrentX, CurrentY
            if (!VerifyTargetColor(CurrentX, CurrentY, LockColorHex)) {
                Sleep, 1
                continue
            }
        }
        ExecuteActionPipeline(ClickType, -1, -1, BackgroundMode, TargetHwnd, Humanize)
        HandleSpeedThrottle(Delay1, Humanize)
    }
}
return

LoopVector1:
While (RunV1 = 1) {
    Gui, Submit, NoHide
    if (ActiveColorTrigger = 1 && !VerifyTargetColor(TargetX1, TargetY1, LockColorHex)) {
        Sleep, 1
        continue
    }
    ExecuteActionPipeline(ClickType, TargetX1, TargetY1, BackgroundMode, TargetHwnd, Humanize)
    HandleSpeedThrottle(Delay1, Humanize)
}
return

LoopVector2:
While (RunV2 = 1) {
    Gui, Submit, NoHide
    if (ActiveColorTrigger = 1 && !VerifyTargetColor(TargetX2, TargetY2, LockColorHex)) {
        Sleep, 1
        continue
    }
    ExecuteActionPipeline(ClickType, TargetX2, TargetY2, BackgroundMode, TargetHwnd, Humanize)
    HandleSpeedThrottle(Delay2, Humanize)
}
return

LoopVector3:
While (RunV3 = 1) {
    Gui, Submit, NoHide
    if (ActiveColorTrigger = 1 && !VerifyTargetColor(TargetX3, TargetY3, LockColorHex)) {
        Sleep, 1
        continue
    }
    ExecuteActionPipeline(ClickType, TargetX3, TargetY3, BackgroundMode, TargetHwnd, Humanize)
    HandleSpeedThrottle(Delay3, Humanize)
}
return

VerifyTargetColor(X, Y, RequiredHex) {
    PixelGetColor, CurrentHex, %X%, %Y%, RGB
    return (CurrentHex = RequiredHex)
}

ExecuteActionPipeline(ActionType, XPos, YPos, BackgroundOn, HwndId, JitterOn) {
    MsgDown := (ActionType = "Right Click") ? 0x0204 : 0x0201
    MsgUp   := (ActionType = "Right Click") ? 0x0205 : 0x0202
    ParamButton := (ActionType = "Right Click") ? "Right" : "Left"
    if (JitterOn = 1 && XPos != -1) {
        Random, JX, -1, 1
        Random, JY, -1, 1
        XPos += JX
        YPos += JY
    }
    if (BackgroundOn = 1 && HwndId != 0 && XPos != -1) {
        lParam := (YPos << 16) | (XPos & 0xFFFF)
        DllCall("PostMessage", "Ptr", HwndId, "UInt", MsgDown, "Ptr", 1, "Ptr", lParam)
        DllCall("PostMessage", "Ptr", HwndId, "UInt", MsgUp, "Ptr", 0, "Ptr", lParam)
        if (ActionType = "Double Left") {
            DllCall("PostMessage", "Ptr", HwndId, "UInt", MsgDown, "Ptr", 1, "Ptr", lParam)
            DllCall("PostMessage", "Ptr", HwndId, "UInt", MsgUp, "Ptr", 0, "Ptr", lParam)
            TotalClicks++
        }
    } else {
        if (XPos = -1) {
            Click, %ParamButton%
            if (ActionType = "Double Left") {
                Click, Left
                TotalClicks++
            }
        } else {
            Click, %XPos%, %YPos%, %ParamButton%
            if (ActionType = "Double Left") {
                Click, %XPos%, %YPos%, Left
                TotalClicks++
            }
        }
    }
    TotalClicks++
}

HandleSpeedThrottle(BaseDelay, EnableHumanizer) {
    if (EnableHumanizer = 1) {
        Random, r1, 1, 10
        Random, r2, 1, 10
        Random, r3, 1, 10
        Variance := Round((r1 + r2 + r3) / 3) - 5
FinalSleep := BaseDelay + (Variance * 2)
if (FinalSleep < 0)
FinalSleep := 0
} else {
FinalSleep := BaseDelay
}
if (FinalSleep <= 0) {
Sleep, -1
} else {
Sleep, %FinalSleep%
}
}

Guiclose:
ExitApp