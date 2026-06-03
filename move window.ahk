#Requires AutoHotkey v2.0
#SingleInstance Force

SetWinDelay(-1)

; --- CONFIGURATION ---
; Set how close to the center a click must be to be considered "middle" (0.3 = 30%)
InnerRatio := 0.3 

; --- MOVE WINDOW (Alt + Left Click) ---
!LButton::
{
    CoordMode("Mouse", "Screen")
    MouseGetPos(&startX, &startY, &targetWin)
    
    ; Exit if clicking on the Taskbar or Desktop
    if !targetWin || WinGetClass(targetWin) = "Shell_TrayWnd" || WinGetClass(targetWin) = "WorkerW" || WinGetClass(targetWin) = "Progman"
        return

    WinGetPos(&winX, &winY, , , targetWin)
    
    while GetKeyState("LButton", "P")
    {
        MouseGetPos(&curX, &curY)
        WinMove(winX + (curX - startX), winY + (curY - startY), , , targetWin)
    }
}

; --- RESIZE WINDOW (Alt + Right Click) ---
!RButton::
{
    CoordMode("Mouse", "Screen")
    MouseGetPos(&startX, &startY, &targetWin)
    
    if !targetWin || WinGetClass(targetWin) = "Shell_TrayWnd" || WinGetClass(targetWin) = "WorkerW" || WinGetClass(targetWin) = "Progman"
        return

    WinGetPos(&winX, &winY, &winW, &winH, targetWin)
    
    ; Determine which "zone" of the window was clicked to decide resize direction
    ; (Uses window-relative coordinates)
    CoordMode("Mouse", "Window")
    MouseGetPos(&relX, &relY)
    
    ; Zones: -1 (Left/Top), 0 (Middle), 1 (Right/Bottom)
    dirX := (relX < winW * (0.5 - InnerRatio/2)) ? -1 : (relX > winW * (0.5 + InnerRatio/2) ? 1 : 0)
    dirY := (relY < winH * (0.5 - InnerRatio/2)) ? -1 : (relY > winH * (0.5 + InnerRatio/2) ? 1 : 0)

    ; If user clicked dead center, default to bottom-right corner resize
    if (dirX == 0 && dirY == 0) {
        dirX := 1
        dirY := 1
    }

    ; Update Cursor Icon based on direction
    SetResizeCursor(dirX, dirY)

    CoordMode("Mouse", "Screen")
    while GetKeyState("RButton", "P")
    {
        MouseGetPos(&curX, &curY)
        
        newX := winX, newY := winY, newW := winW, newH := winH
        
        ; Calculate Horizontal Resize
        if (dirX == -1) { ; Left
            newX := winX + (curX - startX)
            newW := winW - (curX - startX)
        } else if (dirX == 1) { ; Right
            newW := winW + (curX - startX)
        }

        ; Calculate Vertical Resize
        if (dirY == -1) { ; Top
            newY := winY + (curY - startY)
            newH := winH - (curY - startY)
        } else if (dirY == 1) { ; Bottom
            newH := winH + (curY - startY)
        }

        WinMove(newX, newY, Max(newW, 100), Max(newH, 100), targetWin)
    }
    
    ; Restore System Cursor
    DllCall("SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "Ptr", 0, "UInt", 0)
}

; --- TOGGLE ALWAYS ON TOP (Shift + Left Click) ---
+LButton::
{
    CoordMode("Mouse", "Screen")
    MouseGetPos(,, &targetWin)
    
    if !targetWin || WinGetClass(targetWin) = "Shell_TrayWnd" || WinGetClass(targetWin) = "WorkerW" || WinGetClass(targetWin) = "Progman"
        return

    WinSetAlwaysOnTop(-1, targetWin)
    
    isTop := (WinGetExStyle(targetWin) & 0x8)
    ToolTip(isTop ? "Always On Top: ON" : "Always On Top: OFF")
    SetTimer(() => ToolTip(), -1000)
}

; --- ADJUST TRANSPARENCY (Left-Shift + Plus / Minus) ---
<+=::
<+NumpadAdd::
{
    AdjustTransparency(25) ; Increase opacity (make solid)
}

<+-::
<+NumpadSub::
{
    AdjustTransparency(-25) ; Decrease opacity (make transparent)
}


; --- HELPER FUNCTIONS ---

AdjustTransparency(amt) {
    CoordMode("Mouse", "Screen")
    MouseGetPos(,, &targetWin)
    
    if !targetWin || WinGetClass(targetWin) = "Shell_TrayWnd" || WinGetClass(targetWin) = "WorkerW" || WinGetClass(targetWin) = "Progman"
        return

    currentTrans := 255
    try {
        val := WinGetTransparent(targetWin)
        if (val !== "")
            currentTrans := val
    } catch {
        currentTrans := 255
    }

    newTrans := currentTrans + amt
    newTrans := Max(128, Min(255, newTrans)) ; Clamps between 128 (50% opacity) and 255 (100% opacity)

    if (newTrans >= 255) {
        WinSetTransparent("Off", targetWin)
        ToolTip("Opacity: 100%")
    } else {
        WinSetTransparent(newTrans, targetWin)
        ToolTip("Opacity: " . Round((newTrans / 255) * 100) . "%")
    }
    
    SetTimer(() => ToolTip(), -1000)
}

SetResizeCursor(dx, dy) {
    id := 0
    if (dx != 0 && dy != 0)
        id := (dx == dy) ? 32642 : 32643
    else if (dx != 0)
        id := 32644
    else
        id := 32645

    cursor := DllCall("LoadCursor", "Ptr", 0, "Ptr", id, "Ptr")
    for system_id in [32512, 32513, 32514, 32515, 32516, 32642, 32643, 32644, 32645]
        DllCall("SetSystemCursor", "Ptr", DllCall("CopyIcon", "Ptr", cursor, "Ptr"), "UInt", system_id)
}
