@echo off
REM PlatformIO Static Analysis Script
REM Usage: pio-check.bat [environment]

setlocal enabledelayedexpansion

set "ENV=%1"

echo ========================================
echo   PlatformIO Static Analysis
echo ========================================
echo Environment: %ENV%
echo ========================================

echo.
echo [INFO] Running static code analysis...
pio check --environment %ENV% --fail-on-defect=medium

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] No critical issues found!
    exit /b 0
) else (
    echo.
    echo [WARNING] Issues detected - review above
    exit /b %ERRORLEVEL%
)
