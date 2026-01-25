@echo off
REM PlatformIO Flash Script - Upload firmware to ESP32
REM Usage: pio-flash.bat [environment] [port]

setlocal enabledelayedexpansion

set "ENV=%1"
set "PORT=%2"

echo ========================================
echo   PlatformIO Flash Script
echo ========================================

REM Check if platformio.ini exists
if not exist "platformio.ini" (
    echo [ERROR] No platformio.ini found in current directory
    exit /b 1
)

REM Auto-detect port if not specified
if "%PORT%"=="" (
    echo [INFO] Auto-detecting serial port...
    for /f "tokens=*" %%i in ('pio device list ^| findstr /C:"COM"') do (
        set "PORT=%%i"
        goto :port_found
    )
    echo [ERROR] No serial port found. Please specify manually.
    exit /b 1
)

:port_found
echo Environment: %ENV%
echo Port: %PORT%
echo ========================================

REM Upload firmware
echo.
echo [INFO] Uploading firmware...
if "%PORT%"=="" (
    pio run --target upload --environment %ENV%
) else (
    pio run --target upload --environment %ENV% --upload-port %PORT%
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] Firmware uploaded successfully!
    echo.
    echo [INFO] Opening serial monitor...
    timeout /t 2 /nobreak >nul
    pio device monitor --environment %ENV%
    exit /b 0
) else (
    echo.
    echo [ERROR] Upload failed with error code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)
