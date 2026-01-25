@echo off
REM Test Runner - Execute all firmware tests

setlocal enabledelayedexpansion

echo ========================================
echo   Firmware Test Runner
echo ========================================
echo.

set "TEST_DIR=%~dp0"

REM Check Python
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python not found
    echo [ERROR] Install Python to run tests
    exit /b 1
)

REM Install dependencies
echo [INFO] Checking test dependencies...
pip install pyserial >nul 2>&1

echo.
echo Available Tests:
echo   1. Serial Communication Test
echo   2. Performance Benchmark
echo   3. Both
echo   4. Exit
echo.
set /p CHOICE="Select test (1-4): "

if "%CHOICE%"=="1" goto :serial_test
if "%CHOICE%"=="2" goto :benchmark
if "%CHOICE%"=="3" goto :all_tests
if "%CHOICE%"=="4" goto :eof
goto :eof

:serial_test
echo.
echo [RUNNING] Serial Communication Test
echo ========================================
python "%TEST_DIR%serial-test.py"
pause
goto :eof

:benchmark
echo.
echo [RUNNING] Performance Benchmark
echo ========================================
set /p DURATION="Duration in seconds (default 60): "
if "%DURATION%"=="" set "DURATION=60"
python "%TEST_DIR%performance-benchmark.py" -d %DURATION%
pause
goto :eof

:all_tests
echo.
echo [RUNNING] All Tests
echo ========================================
python "%TEST_DIR%serial-test.py"
echo.
timeout /t 5 /nobreak
python "%TEST_DIR%performance-benchmark.py" -d 60
pause
goto :eof
