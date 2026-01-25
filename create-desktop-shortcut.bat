@echo off
REM Create Desktop Shortcut to Toolkit

echo ========================================
echo   Creating Desktop Shortcut
echo ========================================
echo.

set "SHORTCUT_PATH=%USERPROFILE%\Desktop\ESP32 Toolkit.lnk"
set "TARGET_PATH=%~dp0TOOLKIT.bat"
set "ICON_PATH=%SystemRoot%\System32\SHELL32.dll,165"

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.TargetPath = '%TARGET_PATH%'; $Shortcut.IconLocation = '%ICON_PATH%'; $Shortcut.Description = 'ESP32 Firmware Development Toolkit'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.Save()"

if exist "%SHORTCUT_PATH%" (
    echo [SUCCESS] Desktop shortcut created!
    echo.
    echo Location: %SHORTCUT_PATH%
    echo.
    echo You can now access the toolkit from your desktop!
) else (
    echo [ERROR] Failed to create shortcut
)

echo.
pause
