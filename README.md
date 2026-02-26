# LidFX
Automatically manages your laptop lid and sleep behavior while Spotify is playing. LidFX ensures uninterrupted music playback by setting the lid to “Do Nothing” and restoring your original settings when playback stops.
# LidFX

**Automatically manages your laptop lid behavior when Spotify is playing.**

LidFX monitors Spotify on your Windows PC. When music is playing, it sets your laptop lid to **Do Nothing** and disables sleep. Once music stops, it restores your original lid and sleep settings.  

This ensures that your laptop won’t accidentally sleep or hibernate while listening to Spotify, without requiring manual adjustments.

---

## Features

- Detects Spotify desktop playback automatically.
- Sets lid close action to “Do Nothing” when music is playing.
- Disables sleep timeout while music is playing.
- Restores original lid and sleep settings when music stops.
- Safely preserves user’s original power scheme values.
- Can be set to launch automatically on Windows startup.

---

## Installation

1. **Download** `LidFX.exe`.  
2. **Run** LidFX. On first run, it captures your current lid and sleep settings as “original values.”  
3. **Optional:** To have LidFX run automatically on Windows startup:
   - Press `Win + R`, type `shell:startup`, and press Enter.
   - Copy `LidFX.exe` (or a shortcut) into this folder.
   - LidFX will now start automatically whenever you log in.  

---

## Usage

- Make sure **Spotify desktop** is running.  
- LidFX monitors playback every 2 seconds.  
- While music plays, the lid action switches to **Do Nothing**.  
- When music stops, original lid and sleep settings are restored.  
- You can exit the program at any time via the system tray; settings will be restored automatically.  

---

## Important Note About Power Settings

On first run, the script saves your current lid and sleep settings to a .ini file.
When Spotify stops playing, those saved values are restored automatically.

If you manually change your Windows lid or sleep settings while the script is running, your changes may be overwritten.

To permanently change your lid or sleep behavior:

Exit the script completely.

Delete the generated .ini file.

Adjust your Windows power settings.

Run the script again if desired.

This ensures the script captures your updated settings correctly.

---

## Safety Notes

- Works on Windows 10 and 11.
- Does not require admin privileges for normal operation.
- First run **captures your existing power settings**. Do not move or delete the exe between runs without restarting to avoid incorrect restoration.
- LidFX changes your power scheme temporarily; original values are preserved.
- On abrupt shutdown or reboot, Windows persists last applied power scheme. LidFX restores the scheme on next start.

---

## Requirements

- Windows 10 or 11
- Spotify desktop app installed
