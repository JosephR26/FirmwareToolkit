@echo off
REM Local CI Test - Simulates GitHub Actions locally
REM Run this before pushing to catch issues early

setlocal enabledelayedexpansion

echo ========================================
echo   Local CI Test
echo ========================================
echo This simulates GitHub Actions workflow locally
echo ========================================

REM Get environment from platformio.ini
set DEFAULT_ENV=esp32dev
if exist "platformio.ini" (
    for /f "tokens=2 delims==" %%a in ('findstr "default_envs" platformio.ini') do (
        set DEFAULT_ENV=%%a
    )
)

set ENV=%1
if "%ENV%"=="" set "ENV=%DEFAULT_ENV%"

echo Environment: %ENV%
echo ========================================

set FAILED=0

REM Step 1: Clean build
echo.
echo [1/5] Clean Build Test...
echo ----------------------------------------
pio run --target clean --environment %ENV% >nul 2>&1
pio run --environment %ENV%
if %ERRORLEVEL% NEQ 0 (
    echo [FAIL] Build failed
    set FAILED=1
    goto :summary
) else (
    echo [PASS] Build successful
)

REM Step 2: Size check
echo.
echo [2/5] Firmware Size Check...
echo ----------------------------------------
pio run --target size --environment %ENV%

REM Step 3: Tests
echo.
echo [3/5] Unit Tests...
echo ----------------------------------------
if exist "test" (
    pio test --environment %ENV%
    if %ERRORLEVEL% NEQ 0 (
        echo [FAIL] Tests failed
        set FAILED=1
    ) else (
        echo [PASS] Tests passed
    )
) else (
    echo [SKIP] No tests found
)

REM Step 4: Static analysis
echo.
echo [4/5] Static Code Analysis...
echo ----------------------------------------
pio check --environment %ENV% --severity=medium
if %ERRORLEVEL% NEQ 0 (
    echo [WARN] Static analysis found issues
) else (
    echo [PASS] Static analysis clean
)

REM Step 5: Security check
echo.
echo [5/5] Security Check...
echo ----------------------------------------
findstr /s /i "password.*=.*\"" src\*.cpp src\*.h >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [FAIL] Hardcoded credentials detected!
    set FAILED=1
) else (
    echo [PASS] No hardcoded secrets found
)

:summary
echo.
echo ========================================
echo   Test Summary
echo ========================================

if %FAILED% EQU 0 (
    echo [SUCCESS] All checks passed!
    echo Ready to push to GitHub
    exit /b 0
) else (
    echo [FAILED] Some checks failed
    echo Please fix issues before pushing
    exit /b 1
)
