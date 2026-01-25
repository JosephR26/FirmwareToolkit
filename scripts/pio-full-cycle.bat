@echo off
REM Complete Build-Flash-Monitor Cycle
REM Usage: pio-full-cycle.bat [environment] [port]

setlocal enabledelayedexpansion

set "ENV=%1"
set "PORT=%2"
set "SCRIPT_DIR=%~dp0"

echo ========================================
echo   PlatformIO FULL CYCLE
echo ========================================
echo Environment: %ENV%
echo ========================================

REM Step 1: Build
echo.
echo [STEP 1/3] Building firmware...
call "%SCRIPT_DIR%pio-build.bat" %ENV%
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed - aborting
    exit /b %ERRORLEVEL%
)

REM Step 2: Flash
echo.
echo [STEP 2/3] Flashing firmware...
call "%SCRIPT_DIR%pio-flash.bat" %ENV% %PORT%
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flash failed - aborting
    exit /b %ERRORLEVEL%
)

echo.
echo [SUCCESS] Full cycle completed!
echo Firmware is now running on device.
