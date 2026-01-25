@echo off
REM PlatformIO Build Script - Optimized for ESP32
REM Usage: pio-build.bat [environment] [options]

setlocal enabledelayedexpansion

set "PROJECT_DIR=%cd%"
set "ENV=%1"
set "EXTRA_ARGS=%2 %3 %4 %5 %6 %7 %8 %9"

echo ========================================
echo   PlatformIO Build Script
echo ========================================
echo Project: %PROJECT_DIR%
echo Environment: %ENV%
echo ========================================

REM Check if platformio.ini exists
if not exist "platformio.ini" (
    echo [ERROR] No platformio.ini found in current directory
    echo [ERROR] Please run this script from a PlatformIO project root
    exit /b 1
)

REM Display memory before build
echo.
echo [INFO] Checking available memory...
pio run --target size --environment %ENV% 2>nul

REM Clean build if requested
if "%EXTRA_ARGS%" == "*--clean*" (
    echo [INFO] Cleaning build files...
    pio run --target clean --environment %ENV%
)

REM Run the build
echo.
echo [INFO] Building firmware...
pio run --environment %ENV% %EXTRA_ARGS%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] Build completed successfully!
    echo.
    echo [INFO] Firmware size:
    pio run --target size --environment %ENV%
    echo.
    echo [INFO] Build artifacts location:
    echo %PROJECT_DIR%\.pio\build\%ENV%\
    exit /b 0
) else (
    echo.
    echo [ERROR] Build failed with error code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)
