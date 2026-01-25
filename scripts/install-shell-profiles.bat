@echo off
REM Install Shell Profiles for Quick Access

echo ========================================
echo   Shell Profile Installation
echo ========================================
echo.

set "TOOLKIT_DIR=%~dp0.."

echo [INFO] This will install shell profiles:
echo   - PowerShell profile with aliases
echo   - Bash profile (for Git Bash)
echo.

set /p CONFIRM="Install shell profiles? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo [INFO] Installation cancelled
    exit /b 0
)

REM ============================================
REM PowerShell Profile
REM ============================================

echo.
echo [STEP 1/2] Installing PowerShell profile...

REM Get PowerShell profile directory
for /f "tokens=*" %%i in ('powershell -Command "$PROFILE"') do set PROFILE_PATH=%%i

REM Create profile directory if doesn't exist
for %%F in ("%PROFILE_PATH%") do set "PROFILE_DIR=%%~dpF"
if not exist "%PROFILE_DIR%" mkdir "%PROFILE_DIR%"

REM Check if profile exists and backup
if exist "%PROFILE_PATH%" (
    echo [INFO] Backing up existing profile...
    copy "%PROFILE_PATH%" "%PROFILE_PATH%.backup.%date:~-4%%date:~4,2%%date:~7,2%" >nul
)

REM Copy new profile
copy /Y "%TOOLKIT_DIR%\scripts\PowerShell_Profile.ps1" "%PROFILE_PATH%" >nul

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] PowerShell profile installed: %PROFILE_PATH%
) else (
    echo [ERROR] Failed to install PowerShell profile
)

REM ============================================
REM Bash Profile
REM ============================================

echo.
echo [STEP 2/2] Installing Bash profile...

set "BASH_PROFILE=%USERPROFILE%\.bashrc"

REM Backup existing bashrc
if exist "%BASH_PROFILE%" (
    echo [INFO] Backing up existing .bashrc...
    copy "%BASH_PROFILE%" "%BASH_PROFILE%.backup.%date:~-4%%date:~4,2%%date:~7,2%" >nul
)

REM Append toolkit bashrc
echo. >> "%BASH_PROFILE%"
echo # ESP32 Firmware Toolkit >> "%BASH_PROFILE%"
type "%TOOLKIT_DIR%\scripts\.bashrc" >> "%BASH_PROFILE%"

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Bash profile updated: %BASH_PROFILE%
) else (
    echo [ERROR] Failed to update Bash profile
)

echo.
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo [INFO] Restart your terminals to activate profiles
echo.
echo [INFO] PowerShell aliases:
echo   fw build      - Build firmware
echo   fw flash      - Flash firmware
echo   fw cycle      - Full cycle
echo   toolkit       - Open toolkit menu
echo   gst           - Git status
echo.
echo [INFO] To test, open new PowerShell and type: fw
echo.

pause
