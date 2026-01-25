@echo off
REM Install Git Hooks for Firmware Development
REM Run this script from your project root directory

setlocal enabledelayedexpansion

echo ========================================
echo   Git Hooks Installer
echo ========================================

REM Check if we're in a git repository
if not exist ".git" (
    echo [ERROR] Not a Git repository
    echo [ERROR] Please run this script from your project root
    exit /b 1
)

set "HOOKS_SOURCE=%~dp0"
set "HOOKS_TARGET=.git\hooks"

echo [INFO] Installing hooks from: %HOOKS_SOURCE%
echo [INFO] Installing to: %HOOKS_TARGET%

REM Create hooks directory if it doesn't exist
if not exist "%HOOKS_TARGET%" mkdir "%HOOKS_TARGET%"

REM Copy hook files
echo.
echo [INFO] Copying hooks...

for %%H in (pre-commit pre-push commit-msg) do (
    if exist "%HOOKS_SOURCE%%%H" (
        echo   - Installing %%H hook...
        copy /Y "%HOOKS_SOURCE%%%H" "%HOOKS_TARGET%\%%H" >nul

        REM On Windows, hooks need to be executable (Git Bash will handle this)
        REM But we can create .bat wrappers for Windows environments
        echo @echo off > "%HOOKS_TARGET%\%%H.bat"
        echo bash "%HOOKS_TARGET%\%%H" %%* >> "%HOOKS_TARGET%\%%H.bat"
    ) else (
        echo   ${RED}[SKIP]${NC} %%H not found
    )
)

echo.
echo [SUCCESS] Git hooks installed successfully!
echo.
echo [INFO] Installed hooks:
dir /b "%HOOKS_TARGET%\pre-*" "%HOOKS_TARGET%\commit-*" 2>nul
echo.
echo [INFO] These hooks will now run automatically:
echo   - pre-commit: Before each commit (validates code)
echo   - pre-push: Before pushing (runs tests)
echo   - commit-msg: Validates commit message format
echo.
echo [INFO] To bypass hooks (not recommended):
echo   git commit --no-verify
echo   git push --no-verify
echo.
echo ========================================
