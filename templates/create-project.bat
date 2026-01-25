@echo off
REM ESP32 Project Creator
REM Creates a new ESP32 project from templates

setlocal enabledelayedexpansion

echo ========================================
echo   ESP32 Project Creator
echo ========================================
echo.

REM Get project name
if "%1"=="" (
    set /p PROJECT_NAME="Enter project name: "
) else (
    set "PROJECT_NAME=%1"
)

REM Get template type
echo.
echo Available templates:
echo   1. Basic ESP32 (minimal setup)
echo   2. WiFi ESP32 (with WiFi connectivity)
echo   3. Custom (empty project)
echo.
set /p TEMPLATE_CHOICE="Select template (1-3): "

set "TEMPLATE_DIR="
if "%TEMPLATE_CHOICE%"=="1" set "TEMPLATE_DIR=esp32-basic"
if "%TEMPLATE_CHOICE%"=="2" set "TEMPLATE_DIR=esp32-wifi"
if "%TEMPLATE_CHOICE%"=="3" set "TEMPLATE_DIR=esp32-custom"

if "%TEMPLATE_DIR%"=="" (
    echo [ERROR] Invalid template selection
    exit /b 1
)

REM Get project location
set /p PROJECT_PATH="Enter project path [default: %cd%]: "
if "%PROJECT_PATH%"=="" set "PROJECT_PATH=%cd%"

set "FULL_PROJECT_PATH=%PROJECT_PATH%\%PROJECT_NAME%"

echo.
echo ========================================
echo   Project Configuration
echo ========================================
echo Project Name: %PROJECT_NAME%
echo Template: %TEMPLATE_DIR%
echo Location: %FULL_PROJECT_PATH%
echo ========================================
echo.

set /p CONFIRM="Create project? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo [INFO] Project creation cancelled
    exit /b 0
)

REM Create project directory
echo.
echo [INFO] Creating project directory...
mkdir "%FULL_PROJECT_PATH%" 2>nul

if "%TEMPLATE_DIR%"=="esp32-custom" (
    REM Create empty PlatformIO project
    echo [INFO] Creating custom PlatformIO project...
    cd "%FULL_PROJECT_PATH%"
    pio init --board esp32dev
) else (
    REM Copy from template
    echo [INFO] Copying template files...
    set "TEMPLATE_SOURCE=%~dp0%TEMPLATE_DIR%"
    xcopy /E /I /Y "%TEMPLATE_SOURCE%\*" "%FULL_PROJECT_PATH%\"
)

REM Initialize git repository
echo [INFO] Initializing Git repository...
cd "%FULL_PROJECT_PATH%"
git init >nul 2>&1

REM Create .gitignore
echo [INFO] Creating .gitignore...
(
echo .pio
echo .vscode
echo .DS_Store
echo *.pyc
echo .env
echo config.h
echo build/
echo *.bin
echo *.elf
) > .gitignore

REM Create README
echo [INFO] Creating README...
(
echo # %PROJECT_NAME%
echo.
echo ESP32 firmware project created from template.
echo.
echo ## Build
echo ```bash
echo pio run
echo ```
echo.
echo ## Upload
echo ```bash
echo pio run --target upload
echo ```
echo.
echo ## Monitor
echo ```bash
echo pio device monitor
echo ```
echo.
echo ## Or use the toolkit scripts:
echo ```bash
echo %%FIRMWARE_TOOLKIT_PATH%%\scripts\pio-full-cycle.bat esp32dev
echo ```
) > README.md

REM Install git hooks
echo [INFO] Installing Git hooks...
if defined FIRMWARE_TOOLKIT_PATH (
    call "%FIRMWARE_TOOLKIT_PATH%\git-hooks\install-hooks.bat" >nul 2>&1
)

echo.
echo ========================================
echo   Project Created Successfully!
echo ========================================
echo.
echo Next steps:
echo   1. cd "%FULL_PROJECT_PATH%"
echo   2. Edit src/main.cpp for your application
echo   3. Build: pio run
echo   4. Flash: pio run --target upload
echo.
echo Or use quick scripts:
echo   Build: %%FIRMWARE_TOOLKIT_PATH%%\scripts\pio-build.bat esp32dev
echo   Flash: %%FIRMWARE_TOOLKIT_PATH%%\scripts\pio-flash.bat esp32dev
echo   Full cycle: %%FIRMWARE_TOOLKIT_PATH%%\scripts\pio-full-cycle.bat esp32dev
echo.
echo ========================================

REM Ask if user wants to open in VSCode
set /p OPEN_VSCODE="Open project in VS Code? (Y/N): "
if /i "%OPEN_VSCODE%"=="Y" (
    code "%FULL_PROJECT_PATH%"
)

exit /b 0
