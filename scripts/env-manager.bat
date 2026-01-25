@echo off
REM Environment Variables Manager for Firmware Projects
REM Secure credential and configuration management

setlocal enabledelayedexpansion

:menu
cls
echo ========================================
echo   Environment Variables Manager
echo ========================================
echo.
echo Manage credentials and configuration safely
echo.
echo ========================================
echo   MENU
echo ========================================
echo.
echo   1. Create .env file for current project
echo   2. Create .env.example template
echo   3. View current environment variables
echo   4. Add variable to .env
echo   5. Generate config.h from .env
echo   6. Verify .env is gitignored
echo   7. Create secrets manager
echo   0. Exit
echo.
echo ========================================
set /p CHOICE="Select option (0-7): "

if "%CHOICE%"=="0" goto :eof
if "%CHOICE%"=="1" goto :create_env
if "%CHOICE%"=="2" goto :create_example
if "%CHOICE%"=="3" goto :view_env
if "%CHOICE%"=="4" goto :add_var
if "%CHOICE%"=="5" goto :generate_config
if "%CHOICE%"=="6" goto :verify_gitignore
if "%CHOICE%"=="7" goto :create_secrets
goto :menu

:create_env
echo.
echo [CREATE .env FILE]
echo ========================================
echo.

if exist ".env" (
    echo [WARNING] .env file already exists
    set /p OVERWRITE="Overwrite? (Y/N): "
    if /i not "!OVERWRITE!"=="Y" goto :menu
)

echo # Environment Variables for Firmware Project> .env
echo # DO NOT COMMIT THIS FILE TO GIT>> .env
echo # Created: %date% %time%>> .env
echo.>> .env
echo # WiFi Configuration>> .env
echo WIFI_SSID=YourSSID>> .env
echo WIFI_PASSWORD=YourPassword>> .env
echo.>> .env
echo # API Keys>> .env
echo API_KEY=your_api_key_here>> .env
echo API_SECRET=your_api_secret_here>> .env
echo.>> .env
echo # MQTT Configuration>> .env
echo MQTT_SERVER=broker.example.com>> .env
echo MQTT_PORT=1883>> .env
echo MQTT_USER=username>> .env
echo MQTT_PASSWORD=password>> .env
echo.>> .env
echo # Device Configuration>> .env
echo DEVICE_ID=ESP32-001>> .env
echo FIRMWARE_VERSION=1.0.0>> .env

echo [SUCCESS] .env file created
echo [INFO] Edit .env and replace placeholder values
pause
goto :menu

:create_example
echo.
echo [CREATE .env.example TEMPLATE]
echo ========================================
echo.

echo # Environment Variables Template> .env.example
echo # Copy this to .env and fill in your values>> .env.example
echo # Created: %date%>> .env.example
echo.>> .env.example
echo # WiFi Configuration>> .env.example
echo WIFI_SSID=>> .env.example
echo WIFI_PASSWORD=>> .env.example
echo.>> .env.example
echo # API Keys>> .env.example
echo API_KEY=>> .env.example
echo API_SECRET=>> .env.example
echo.>> .env.example
echo # MQTT Configuration>> .env.example
echo MQTT_SERVER=>> .env.example
echo MQTT_PORT=1883>> .env.example
echo MQTT_USER=>> .env.example
echo MQTT_PASSWORD=>> .env.example
echo.>> .env.example
echo # Device Configuration>> .env.example
echo DEVICE_ID=>> .env.example
echo FIRMWARE_VERSION=>> .env.example

echo [SUCCESS] .env.example created
echo [INFO] This file CAN be committed to Git
pause
goto :menu

:view_env
echo.
echo [CURRENT ENVIRONMENT VARIABLES]
echo ========================================
echo.

if not exist ".env" (
    echo [ERROR] No .env file found in current directory
    pause
    goto :menu
)

type .env
echo.
echo ========================================
pause
goto :menu

:add_var
echo.
echo [ADD VARIABLE]
echo ========================================
echo.

if not exist ".env" (
    echo [ERROR] No .env file found
    echo [INFO] Create .env first (option 1)
    pause
    goto :menu
)

set /p VAR_NAME="Variable name: "
set /p VAR_VALUE="Variable value: "

echo %VAR_NAME%=%VAR_VALUE%>> .env

echo [SUCCESS] Variable added to .env
pause
goto :menu

:generate_config
echo.
echo [GENERATE config.h FROM .env]
echo ========================================
echo.

if not exist ".env" (
    echo [ERROR] No .env file found
    pause
    goto :menu
)

set "CONFIG_FILE=include\config.h"

if not exist "include" mkdir include

echo // Auto-generated configuration file> %CONFIG_FILE%
echo // Generated from .env on %date% %time%>> %CONFIG_FILE%
echo // DO NOT EDIT MANUALLY - Changes will be overwritten>> %CONFIG_FILE%
echo.>> %CONFIG_FILE%
echo #ifndef CONFIG_H>> %CONFIG_FILE%
echo #define CONFIG_H>> %CONFIG_FILE%
echo.>> %CONFIG_FILE%

REM Parse .env and convert to C++ defines
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
    set "line=%%a"
    set "value=%%b"

    REM Skip comments and empty lines
    echo !line! | findstr /r "^#" >nul && (
        echo // %%a%%b>> %CONFIG_FILE%
    ) || (
        if not "!line!"=="" if not "!value!"=="" (
            echo #define !line! "!value!">> %CONFIG_FILE%
        )
    )
)

echo.>> %CONFIG_FILE%
echo #endif // CONFIG_H>> %CONFIG_FILE%

echo [SUCCESS] config.h generated: %CONFIG_FILE%
echo [INFO] Include in your code: #include "config.h"
pause
goto :menu

:verify_gitignore
echo.
echo [VERIFY .gitignore]
echo ========================================
echo.

set "GITIGNORE_OK=1"

if not exist ".gitignore" (
    echo [WARNING] No .gitignore found
    set "GITIGNORE_OK=0"
) else (
    findstr /C:".env" .gitignore >nul 2>&1
    if errorlevel 1 (
        echo [WARNING] .env not in .gitignore
        set "GITIGNORE_OK=0"
    )

    findstr /C:"config.h" .gitignore >nul 2>&1
    if errorlevel 1 (
        echo [WARNING] config.h not in .gitignore
        set "GITIGNORE_OK=0"
    )
)

if !GITIGNORE_OK!==0 (
    echo.
    echo [ACTION REQUIRED] Add these to .gitignore:
    echo   .env
    echo   .env.*
    echo   !.env.example
    echo   include/config.h
    echo   config.h
    echo.
    set /p FIX="Auto-fix .gitignore? (Y/N): "
    if /i "!FIX!"=="Y" (
        echo.>> .gitignore
        echo # Environment and credentials>> .gitignore
        echo .env>> .gitignore
        echo .env.*>> .gitignore
        echo !.env.example>> .gitignore
        echo include/config.h>> .gitignore
        echo config.h>> .gitignore
        echo [SUCCESS] .gitignore updated
    )
) else (
    echo [SUCCESS] .gitignore is properly configured
)

pause
goto :menu

:create_secrets
echo.
echo [CREATE SECRETS MANAGER]
echo ========================================
echo.

set "SECRETS_DIR=.secrets"

if not exist "%SECRETS_DIR%" mkdir "%SECRETS_DIR%"

echo # Secrets Manager> %SECRETS_DIR%\README.md
echo.>> %SECRETS_DIR%\README.md
echo This directory contains encrypted credentials.>> %SECRETS_DIR%\README.md
echo DO NOT COMMIT TO GIT.>> %SECRETS_DIR%\README.md
echo.>> %SECRETS_DIR%\README.md
echo Usage:>> %SECRETS_DIR%\README.md
echo 1. Store credentials in .env files here>> %SECRETS_DIR%\README.md
echo 2. Encrypt before sharing: gpg -c filename>> %SECRETS_DIR%\README.md
echo 3. Share .gpg files securely>> %SECRETS_DIR%\README.md

REM Add to gitignore
if exist ".gitignore" (
    findstr /C:".secrets" .gitignore >nul 2>&1
    if errorlevel 1 (
        echo.>> .gitignore
        echo # Secrets directory>> .gitignore
        echo .secrets/>> .gitignore
    )
)

echo [SUCCESS] Secrets manager created: %SECRETS_DIR%\
pause
goto :menu
