@echo off
REM ESP32 Firmware Development Toolkit - Master Menu
REM One-stop access to all toolkit features

setlocal enabledelayedexpansion

:menu
cls
echo =========================================================================
echo    ESP32 FIRMWARE DEVELOPMENT TOOLKIT
echo =========================================================================
echo.
echo    Current Directory: %cd%
if exist "platformio.ini" (
    echo    Project Type: PlatformIO Project
) else (
    echo    Project Type: Not a PlatformIO project
)
echo.
echo =========================================================================
echo    MAIN MENU
echo =========================================================================
echo.
echo    [1] PROJECT MANAGEMENT
echo        1. Create new ESP32 project
echo        2. Install Git hooks in current project
echo        3. Setup GitHub Actions
echo.
echo    [2] BUILD & FLASH
echo        4. Build firmware
echo        5. Flash firmware
echo        6. Build + Flash + Monitor (full cycle)
echo        7. Monitor serial output
echo.
echo    [3] TESTING & VALIDATION
echo        8. Run unit tests
echo        9. Run static analysis
echo        10. Run serial tests (Python)
echo        11. Performance benchmark
echo        12. Local CI test
echo.
echo    [4] GIT OPERATIONS
echo        13. Git workflow helper
echo        14. Configure Git settings
echo        15. View project status
echo.
echo    [5] SYSTEM OPTIMIZATION
echo        16. Optimize laptop for development
echo        17. Clean temp files
echo        18. Monitor system resources
echo        19. Setup development environment
echo.
echo    [6] DOCUMENTATION
echo        20. Open README
echo        21. Open Quick Reference
echo.
echo    [0] EXIT
echo.
echo =========================================================================
set /p CHOICE="Enter your choice (0-21): "

if "%CHOICE%"=="0" goto :eof

REM Project Management
if "%CHOICE%"=="1" (
    call "%~dp0templates\create-project.bat"
    pause
    goto :menu
)
if "%CHOICE%"=="2" (
    call "%~dp0git-hooks\install-hooks.bat"
    pause
    goto :menu
)
if "%CHOICE%"=="3" (
    call "%~dp0ci-cd\setup-github-actions.bat"
    pause
    goto :menu
)

REM Build & Flash
if "%CHOICE%"=="4" (
    call "%~dp0scripts\pio-build.bat" esp32dev
    pause
    goto :menu
)
if "%CHOICE%"=="5" (
    call "%~dp0scripts\pio-flash.bat" esp32dev
    pause
    goto :menu
)
if "%CHOICE%"=="6" (
    call "%~dp0scripts\pio-full-cycle.bat" esp32dev
    pause
    goto :menu
)
if "%CHOICE%"=="7" (
    call "%~dp0scripts\pio-monitor.bat" esp32dev
    goto :menu
)

REM Testing & Validation
if "%CHOICE%"=="8" (
    call "%~dp0scripts\pio-test.bat" esp32dev
    pause
    goto :menu
)
if "%CHOICE%"=="9" (
    call "%~dp0scripts\pio-check.bat" esp32dev
    pause
    goto :menu
)
if "%CHOICE%"=="10" (
    call "%~dp0testing\run-tests.bat"
    pause
    goto :menu
)
if "%CHOICE%"=="11" (
    python "%~dp0testing\performance-benchmark.py" -d 60
    pause
    goto :menu
)
if "%CHOICE%"=="12" (
    call "%~dp0ci-cd\local-ci-test.bat"
    pause
    goto :menu
)

REM Git Operations
if "%CHOICE%"=="13" (
    call "%~dp0scripts\git-workflow-helper.bat"
    goto :menu
)
if "%CHOICE%"=="14" (
    call "%~dp0scripts\configure-git.bat"
    pause
    goto :menu
)
if "%CHOICE%"=="15" (
    cls
    echo =========================================================================
    echo    PROJECT STATUS
    echo =========================================================================
    echo.
    git status
    echo.
    echo =========================================================================
    pause
    goto :menu
)

REM System Optimization
if "%CHOICE%"=="16" (
    call "%~dp0scripts\optimize-laptop.bat"
    pause
    goto :menu
)
if "%CHOICE%"=="17" (
    call "%~dp0scripts\clean-temp.bat"
    pause
    goto :menu
)
if "%CHOICE%"=="18" (
    call "%~dp0scripts\monitor-resources.bat"
    goto :menu
)
if "%CHOICE%"=="19" (
    call "%~dp0scripts\setup-dev-environment.bat"
    pause
    goto :menu
)

REM Documentation
if "%CHOICE%"=="20" (
    start "" "%~dp0README.md"
    goto :menu
)
if "%CHOICE%"=="21" (
    start "" "%~dp0docs\QUICK_REFERENCE.md"
    goto :menu
)

REM Invalid choice
echo.
echo [ERROR] Invalid choice
timeout /t 2 /nobreak >nul
goto :menu
