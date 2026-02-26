#Requires AutoHotkey v2.0
#SingleInstance Force

global iniPath := A_ScriptDir "\power_defaults.ini"
global lastState := ""
global configLoaded := false

; Global variables for power settings
global originalLidAC := 0, originalLidDC := 0
global originalSleepAC := 0, originalSleepDC := 0

InitializeConfiguration()
OnExit(RestoreSettings)
SetTimer(CheckSpotify, 2000)

InitializeConfiguration() {
    global configLoaded, iniPath
    global originalLidAC, originalLidDC, originalSleepAC, originalSleepDC

    if !FileExist(iniPath) {
        ; First run: Capture current system values as the "True Originals"
        originalLidAC := GetPowerValue("SUB_BUTTONS", "5ca83367-6e45-459f-a27b-476b1d01c936", "AC")
        originalLidDC := GetPowerValue("SUB_BUTTONS", "5ca83367-6e45-459f-a27b-476b1d01c936", "DC")
        originalSleepAC := GetPowerValue("238c9fa8-0aad-41ed-83f4-97be242c8f20", "7bc02e2a-bb2d-4831-956f-99941a64c7fe", "AC")
        originalSleepDC := GetPowerValue("238c9fa8-0aad-41ed-83f4-97be242c8f20", "7bc02e2a-bb2d-4831-956f-99941a64c7fe", "DC")

        IniWrite(originalLidAC, iniPath, "LidAction", "AC")
        IniWrite(originalLidDC, iniPath, "LidAction", "DC")
        IniWrite(originalSleepAC, iniPath, "SleepTimeout", "AC")
        IniWrite(originalSleepDC, iniPath, "SleepTimeout", "DC")
    } else {
        ; Subsequent runs: Load from permanent file
        originalLidAC := IniRead(iniPath, "LidAction", "AC")
        originalLidDC := IniRead(iniPath, "LidAction", "DC")
        originalSleepAC := IniRead(iniPath, "SleepTimeout", "AC")
        originalSleepDC := IniRead(iniPath, "SleepTimeout", "DC")
    }
    configLoaded := true
    
    ; Sanity Check: Ensure system is restored to INI defaults immediately if Spotify is stopped
    DetectHiddenWindows(true)
    try {
        title := WinGetTitle("ahk_exe Spotify.exe")
    } catch {
        title := ""
    }
    
    if !(title != "" && InStr(title, " - ") && !RegExMatch(title, "^Spotify( Free| Premium)?$")) {
        RestoreSettings()
    }
}

CheckSpotify() {
    global lastState, configLoaded
    if !configLoaded
        return

    DetectHiddenWindows(true)
    try {
        title := WinGetTitle("ahk_exe Spotify.exe")
    } catch {
        title := ""
    }

    state := (title != "" && InStr(title, " - ") && !RegExMatch(title, "^Spotify( Free| Premium)?$")) ? "playing" : "stopped"

    if (state != lastState) {
        lastState := state

        if (state = "playing") {
            RunWait('powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS 5ca83367-6e45-459f-a27b-476b1d01c936 0',, "Hide")
            RunWait('powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS 5ca83367-6e45-459f-a27b-476b1d01c936 0',, "Hide")
            RunWait('powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc02e2a-bb2d-4831-956f-99941a64c7fe 0',, "Hide")
            RunWait('powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc02e2a-bb2d-4831-956f-99941a64c7fe 0',, "Hide")
        } else {
            RestoreSettings()
        }
        RunWait('powercfg /SETACTIVE SCHEME_CURRENT',, "Hide")
    }
}

GetPowerValue(subgroup, setting, mode) {
    output := RunGetOutput('powercfg /QUERY SCHEME_CURRENT ' subgroup ' ' setting)
    regex := (mode = "AC") ? "Current AC Power Setting Index:\s+0x(\w+)" : "Current DC Power Setting Index:\s+0x(\w+)"
    if RegExMatch(output, regex, &match)
        return Integer("0x" match[1])
    return 0
}

RunGetOutput(cmd) {
    tempFile := A_Temp "\ahk_pwr_out.tmp"
    RunWait(A_ComSpec ' /c ' cmd ' > "' tempFile '"',, "Hide")
    if FileExist(tempFile) {
        text := FileRead(tempFile)
        FileDelete(tempFile)
        return text
    }
    return ""
}

RestoreSettings(*) {
    global configLoaded, originalLidAC, originalLidDC, originalSleepAC, originalSleepDC
    if (configLoaded) {
        RunWait('powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS 5ca83367-6e45-459f-a27b-476b1d01c936 ' originalLidAC,, "Hide")
        RunWait('powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS 5ca83367-6e45-459f-a27b-476b1d01c936 ' originalLidDC,, "Hide")
        RunWait('powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc02e2a-bb2d-4831-956f-99941a64c7fe ' originalSleepAC,, "Hide")
        RunWait('powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc02e2a-bb2d-4831-956f-99941a64c7fe ' originalSleepDC,, "Hide")
        RunWait('powercfg /SETACTIVE SCHEME_CURRENT',, "Hide")
    }
}