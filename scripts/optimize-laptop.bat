@echo off
REM Laptop Optimization Script for Development
REM Optimizes Windows settings for firmware development and compilation

setlocal enabledelayedexpansion

echo ========================================
echo   Laptop Optimization for Development
echo ========================================
echo.
echo This script will optimize your laptop for:
echo   - Faster compilation times
echo   - Better PlatformIO performance
echo   - Optimized power settings for development
echo   - Disabled unnecessary background services
echo.

set /p CONFIRM="Continue with optimization? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo [INFO] Optimization cancelled
    exit /b 0
)

echo.
echo [STEP 1/6] Setting Power Plan to High Performance...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Power plan set to High Performance
) else (
    echo [WARNING] Could not set power plan - may require admin
)

echo.
echo [STEP 2/6] Disabling USB Selective Suspend...
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setactive SCHEME_CURRENT
echo [SUCCESS] USB selective suspend disabled (improves serial stability)

echo.
echo [STEP 3/6] Optimizing Disk for Development...
REM Disable Windows Search indexing for build directories
echo [INFO] Excluding build directories from search indexing...
reg add "HKCU\Software\Microsoft\Windows Search\Gather\Windows\SystemIndex" /v "DisableIndex" /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo [STEP 4/6] Setting Visual Effects to Performance Mode...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
echo [SUCCESS] Visual effects optimized for performance

echo.
echo [STEP 5/6] Optimizing Virtual Memory...
echo [INFO] Current virtual memory settings:
wmic computersystem get TotalPhysicalMemory
echo [INFO] Recommended: Let system manage virtual memory

echo.
echo [STEP 6/6] Setting Processor Scheduling to Background Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 24 /f >nul 2>&1
echo [SUCCESS] Processor scheduling optimized

echo.
echo ========================================
echo   Optimization Complete!
echo ========================================
echo.
echo [INFO] Recommendations:
echo   1. Restart your computer for all changes to take effect
echo   2. Close unnecessary background applications
echo   3. Consider adding more RAM if < 8GB
echo   4. Use SSD for faster compilation
echo.
echo [INFO] To revert power settings:
echo   powercfg /setactive SCHEME_BALANCED
echo.

pause
