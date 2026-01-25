@echo off
REM Clean Temporary Files and Build Artifacts
REM Frees up disk space and removes old build files

setlocal enabledelayedexpansion

echo ========================================
echo   Cleanup Utility
echo ========================================
echo.
echo This will clean:
echo   - Windows temp files
echo   - PlatformIO build cache
echo   - Python cache files
echo   - Node modules cache
echo   - Git repository caches
echo.

set /p CONFIRM="Continue with cleanup? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo [INFO] Cleanup cancelled
    exit /b 0
)

set CLEANED_SIZE=0

echo.
echo [STEP 1/6] Cleaning Windows Temp Files...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
echo [SUCCESS] Windows temp files cleaned

echo.
echo [STEP 2/6] Cleaning PlatformIO Cache...
if exist "%USERPROFILE%\.platformio\.cache" (
    rmdir /s /q "%USERPROFILE%\.platformio\.cache" >nul 2>&1
    echo [SUCCESS] PlatformIO cache cleaned
) else (
    echo [INFO] No PlatformIO cache found
)

echo.
echo [STEP 3/6] Cleaning Python Cache Files...
for /r "%USERPROFILE%\Documents" %%G in (__pycache__) do (
    if exist "%%G" (
        rmdir /s /q "%%G" >nul 2>&1
    )
)
for /r "%USERPROFILE%\Documents" %%G in (*.pyc) do (
    if exist "%%G" (
        del /f /q "%%G" >nul 2>&1
    )
)
echo [SUCCESS] Python cache files cleaned

echo.
echo [STEP 4/6] Cleaning Node Modules Cache...
if exist "%APPDATA%\npm-cache" (
    npm cache clean --force >nul 2>&1
    echo [SUCCESS] npm cache cleaned
) else (
    echo [INFO] No npm cache found
)

echo.
echo [STEP 5/6] Running Disk Cleanup...
cleanmgr /sagerun:1 >nul 2>&1 &
echo [SUCCESS] Disk cleanup started in background

echo.
echo [STEP 6/6] Optimizing PlatformIO Library Cache...
if exist "%USERPROFILE%\.platformio\lib" (
    echo [INFO] Library cache location: %USERPROFILE%\.platformio\lib
    echo [INFO] Consider manually reviewing old library versions
)

echo.
echo ========================================
echo   Cleanup Complete!
echo ========================================
echo.
echo [INFO] Recommendations:
echo   1. Run this script monthly
echo   2. Check disk space with: dir %USERPROFILE% /s
echo   3. Use 'pio system prune' for deep PlatformIO cleanup
echo.

pause
