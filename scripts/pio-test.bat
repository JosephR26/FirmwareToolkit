@echo off
REM PlatformIO Test Script - Run unit tests
REM Usage: pio-test.bat [environment]

setlocal enabledelayedexpansion

set "ENV=%1"

echo ========================================
echo   PlatformIO Test Suite
echo ========================================
echo Environment: %ENV%
echo ========================================

REM Check if test directory exists
if not exist "test" (
    echo [WARNING] No test directory found
    echo [INFO] Creating test directory structure...
    mkdir test
    echo ; PlatformIO Test Suite > test\README
)

echo.
echo [INFO] Running tests...
if "%ENV%"=="" (
    pio test
) else (
    pio test --environment %ENV%
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] All tests passed!
    exit /b 0
) else (
    echo.
    echo [ERROR] Tests failed with error code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)
