@echo off
REM Setup GitHub Actions for ESP32 Project
REM Copies CI/CD workflow to your project

setlocal enabledelayedexpansion

echo ========================================
echo   GitHub Actions Setup
echo ========================================
echo.

REM Check if we're in a git repository
if not exist ".git" (
    echo [ERROR] Not a Git repository
    echo [ERROR] Please run this script from your project root
    exit /b 1
)

echo [INFO] This will set up GitHub Actions CI/CD for your project
echo [INFO] The workflow will automatically:
echo   - Build firmware on every push
echo   - Run tests (if available)
echo   - Perform static code analysis
echo   - Create releases on tagged commits
echo.

set /p CONFIRM="Continue? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo [INFO] Setup cancelled
    exit /b 0
)

REM Create .github/workflows directory
echo.
echo [STEP 1/3] Creating workflow directory...
if not exist ".github\workflows" mkdir ".github\workflows"
echo [SUCCESS] Directory created

REM Copy workflow file
echo.
echo [STEP 2/3] Copying GitHub Actions workflow...
set "WORKFLOW_SOURCE=%~dp0github-actions-esp32.yml"
set "WORKFLOW_DEST=.github\workflows\build.yml"

copy /Y "%WORKFLOW_SOURCE%" "%WORKFLOW_DEST%" >nul
echo [SUCCESS] Workflow file copied to: %WORKFLOW_DEST%

REM Create .gitattributes for binary files
echo.
echo [STEP 3/3] Configuring Git attributes...
(
echo # Binary files
echo *.bin binary
echo *.elf binary
echo *.hex binary
echo.
echo # Line endings
echo *.cpp text eol=lf
echo *.h text eol=lf
echo *.c text eol=lf
echo *.ini text eol=lf
echo *.md text eol=lf
) > .gitattributes
echo [SUCCESS] .gitattributes created

echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo [NEXT STEPS]
echo.
echo 1. Review the workflow file:
echo    %WORKFLOW_DEST%
echo.
echo 2. Customize the PLATFORMIO_ENV variable if needed
echo.
echo 3. Commit and push to GitHub:
echo    git add .github/
echo    git add .gitattributes
echo    git commit -m "ci: add GitHub Actions workflow"
echo    git push
echo.
echo 4. The workflow will run automatically on push
echo.
echo 5. View results at:
echo    https://github.com/YOUR_USERNAME/YOUR_REPO/actions
echo.
echo ========================================

pause
