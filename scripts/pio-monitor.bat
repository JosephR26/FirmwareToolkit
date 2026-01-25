@echo off
REM PlatformIO Serial Monitor Script
REM Usage: pio-monitor.bat [environment] [port] [baudrate]

setlocal enabledelayedexpansion

set "ENV=%1"
set "PORT=%2"
set "BAUD=%3"

if "%BAUD%"=="" set "BAUD=115200"

echo ========================================
echo   PlatformIO Serial Monitor
echo ========================================
echo Environment: %ENV%
echo Baudrate: %BAUD%
echo ========================================
echo.
echo [INFO] Press Ctrl+C to exit
echo.

if "%PORT%"=="" (
    pio device monitor --environment %ENV% --baud %BAUD%
) else (
    pio device monitor --environment %ENV% --port %PORT% --baud %BAUD%
)
