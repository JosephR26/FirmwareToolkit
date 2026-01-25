@echo off
REM Complete Development Environment Setup
REM Installs and configures all tools needed for ESP32 development

setlocal enabledelayedexpansion

echo ========================================
echo   Development Environment Setup
echo ========================================
echo.
echo This script will install/configure:
echo   - Git (if not installed)
echo   - Python (if not installed)
echo   - Node.js (if not installed)
echo   - PlatformIO Core
echo   - VS Code extensions (if VS Code is installed)
echo   - ESP32 toolchain
echo.

set /p CONFIRM="Continue with setup? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo [INFO] Setup cancelled
    exit /b 0
)

echo.
echo ========================================
echo   Checking Prerequisites
echo ========================================

REM Check Git
echo.
echo [CHECK] Git...
git --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Git is installed
    git --version
) else (
    echo [MISSING] Installing Git...
    winget install --id Git.Git -e --source winget
)

REM Check Python
echo.
echo [CHECK] Python...
python --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Python is installed
    python --version
) else (
    echo [MISSING] Installing Python...
    winget install --id Python.Python.3.12 -e --source winget
)

REM Check Node.js
echo.
echo [CHECK] Node.js...
node --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Node.js is installed
    node --version
) else (
    echo [MISSING] Installing Node.js...
    winget install --id OpenJS.NodeJS.LTS -e --source winget
)

REM Check PlatformIO
echo.
echo [CHECK] PlatformIO...
pio --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] PlatformIO is installed
    pio --version
) else (
    echo [MISSING] Installing PlatformIO...
    pip install -U platformio
)

echo.
echo ========================================
echo   Configuring PlatformIO
echo ========================================

REM Update PlatformIO
echo.
echo [INFO] Updating PlatformIO Core...
pio upgrade

REM Install ESP32 platform
echo.
echo [INFO] Installing ESP32 platform...
pio platform install espressif32

REM Install common libraries
echo.
echo [INFO] Installing common libraries...
pio lib -g install "AsyncTCP"
pio lib -g install "ESPAsyncWebServer"

echo.
echo ========================================
echo   Configuring Git
echo ========================================

REM Configure Git for firmware development
echo.
echo [INFO] Configuring Git settings...
git config --global core.autocrlf true
git config --global core.longpaths true
git config --global pull.rebase false
git config --global init.defaultBranch main

REM Check if Git user is configured
git config --global user.name >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    set /p GIT_NAME="Enter your Git name: "
    git config --global user.name "!GIT_NAME!"
)

git config --global user.email >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    set /p GIT_EMAIL="Enter your Git email: "
    git config --global user.email "!GIT_EMAIL!"
)

echo [SUCCESS] Git configured

echo.
echo ========================================
echo   Installing VS Code Extensions
echo ========================================

code --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [INFO] VS Code detected, installing extensions...
    code --install-extension platformio.platformio-ide
    code --install-extension ms-vscode.cpptools
    code --install-extension mhutchie.git-graph
    echo [SUCCESS] VS Code extensions installed
) else (
    echo [INFO] VS Code not found - skipping extension installation
)

echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo [NEXT STEPS]
echo   1. Create a new project:
echo      %~dp0..\templates\create-project.bat
echo.
echo   2. Or navigate to existing project and run:
echo      pio run
echo.
echo   3. Install Git hooks in your projects:
echo      %~dp0..\git-hooks\install-hooks.bat
echo.
echo [INFO] Toolkit location:
echo      C:\Users\josep\Documents\FirmwareToolkit\
echo.

pause
