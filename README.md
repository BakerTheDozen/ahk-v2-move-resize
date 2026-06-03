# Window Drag, Resize, and Transparency Utilities

A lightweight AutoHotkey v2 script that enhances Windows window management. It allows you to move, resize, pin, and adjust the transparency of any window using intuitive mouse and keyboard shortcuts.

## Features & Hotkeys

### 1. Move Window
* **Hotkey:** `Alt` + `Left Click` (Drag)
* **Action:** Click and hold anywhere inside a window to drag and reposition it.
* *Note: Automatically ignores the Taskbar and Desktop to prevent accidental movement.*

### 2. Smart Resize Window
* **Hotkey:** `Alt` + `Right Click` (Drag)
* **Action:** Resizes the window based on the "zone" you click (Left, Right, Top, Bottom, or Corners). 
* **Visual Cue:** Automatically updates the system cursor to match the resize direction. Clicking the dead center defaults to bottom-right resizing.

### 3. Always on Top Toggle
* **Hotkey:** `Shift` + `Left Click`
* **Action:** Instantly pins a window to the forefront (Always on Top). Clicking it again restores it to normal.
* **Visual Cue:** Displays a brief 1-second tooltip (`Always On Top: ON/OFF`) to confirm the state.

### 4. Window Transparency
* **Hotkeys:** * `Left-Shift` + `+` (or `NumpadAdd`) to increase opacity (make more solid)
  * `Left-Shift` + `-` (or `NumpadSub`) to decrease opacity (make more transparent)
* **Action:** Adjusts the window opacity in ~10% increments.
* **Safety Clamp:** Opacity is locked between **50% and 100%** to ensure high-contrast windows (like dark-mode text editors over light backgrounds) never become completely invisible.

---

## Prerequisites

* **AutoHotkey v2.0** or higher installed. 
* *Note: This script utilizes features specific to the stable v2.0 release branch.*

## Installation & Usage

1. Download or clone this repository.
2. Double-click `window_drag_resize.ahk` to run the script.
3. To ensure it runs automatically on startup, place a shortcut of the script in your Windows Startup folder:
   * Press `Win + R`, type `shell:startup`, and press Enter.
   * Paste the shortcut there.
