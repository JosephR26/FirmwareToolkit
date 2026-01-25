@echo off
REM Git Workflow Helper for Firmware Development
REM Interactive helper for common Git workflows

setlocal enabledelayedexpansion

:menu
cls
echo ========================================
echo   Git Workflow Helper
echo ========================================
echo.
echo Current Branch:
git branch --show-current 2>nul
echo.
echo Status:
git status -sb
echo.
echo ========================================
echo   Available Actions
echo ========================================
echo.
echo   1. Create new feature branch
echo   2. Commit current changes
echo   3. Push to remote
echo   4. Create Pull Request (via gh)
echo   5. Sync with main/develop
echo   6. View commit history
echo   7. Undo last commit
echo   8. Stash changes
echo   9. View diff
echo   0. Exit
echo.
set /p CHOICE="Select action (0-9): "

if "%CHOICE%"=="1" goto :create_branch
if "%CHOICE%"=="2" goto :commit
if "%CHOICE%"=="3" goto :push
if "%CHOICE%"=="4" goto :create_pr
if "%CHOICE%"=="5" goto :sync
if "%CHOICE%"=="6" goto :history
if "%CHOICE%"=="7" goto :undo
if "%CHOICE%"=="8" goto :stash
if "%CHOICE%"=="9" goto :diff
if "%CHOICE%"=="0" goto :eof
goto :menu

:create_branch
echo.
echo [CREATE BRANCH]
set /p BRANCH_TYPE="Branch type (feature/fix/refactor): "
set /p BRANCH_NAME="Branch name (e.g., esp32-sleep-mode): "
set "FULL_BRANCH=%BRANCH_TYPE%/%BRANCH_NAME%"
echo Creating branch: %FULL_BRANCH%
git checkout -b %FULL_BRANCH%
pause
goto :menu

:commit
echo.
echo [COMMIT CHANGES]
echo.
echo Staged files:
git diff --cached --name-only
echo.
set /p COMMIT_TYPE="Commit type (feat/fix/docs/refactor/perf): "
set /p COMMIT_SCOPE="Scope (e.g., esp32/wifi/bluetooth): "
set /p COMMIT_MSG="Description: "
set "FULL_MSG=%COMMIT_TYPE%(%COMMIT_SCOPE%): %COMMIT_MSG%"
echo.
echo Commit message: %FULL_MSG%
set /p CONFIRM="Confirm? (Y/N): "
if /i "%CONFIRM%"=="Y" (
    git commit -m "%FULL_MSG%"
    echo [SUCCESS] Changes committed
) else (
    echo [INFO] Commit cancelled
)
pause
goto :menu

:push
echo.
echo [PUSH TO REMOTE]
git push -u origin HEAD
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Pushed to remote
) else (
    echo [ERROR] Push failed
)
pause
goto :menu

:create_pr
echo.
echo [CREATE PULL REQUEST]
gh pr create --web
pause
goto :menu

:sync
echo.
echo [SYNC WITH MAIN]
echo.
echo Select base branch:
echo   1. main
echo   2. develop
set /p BASE_CHOICE="Choice: "
if "%BASE_CHOICE%"=="1" set "BASE_BRANCH=main"
if "%BASE_CHOICE%"=="2" set "BASE_BRANCH=develop"
echo.
echo Syncing with %BASE_BRANCH%...
git fetch origin
git merge origin/%BASE_BRANCH%
pause
goto :menu

:history
echo.
echo [COMMIT HISTORY]
git log --graph --pretty=format:'%%Cred%%h%%Creset -%%C(yellow)%%d%%Creset %%s %%Cgreen(%%cr) %%C(bold blue)<%%an>%%Creset' --abbrev-commit -10
echo.
pause
goto :menu

:undo
echo.
echo [UNDO LAST COMMIT]
git log -1
echo.
set /p CONFIRM="Undo this commit? (Y/N): "
if /i "%CONFIRM%"=="Y" (
    git reset --soft HEAD~1
    echo [SUCCESS] Last commit undone (changes preserved)
)
pause
goto :menu

:stash
echo.
echo [STASH CHANGES]
echo.
echo   1. Stash changes
echo   2. List stashes
echo   3. Apply latest stash
echo   4. Pop latest stash
set /p STASH_CHOICE="Choice: "
if "%STASH_CHOICE%"=="1" (
    set /p STASH_MSG="Stash message: "
    git stash push -m "!STASH_MSG!"
)
if "%STASH_CHOICE%"=="2" git stash list
if "%STASH_CHOICE%"=="3" git stash apply
if "%STASH_CHOICE%"=="4" git stash pop
pause
goto :menu

:diff
echo.
echo [VIEW DIFF]
echo.
echo   1. Unstaged changes
echo   2. Staged changes
echo   3. Last commit
set /p DIFF_CHOICE="Choice: "
if "%DIFF_CHOICE%"=="1" git diff
if "%DIFF_CHOICE%"=="2" git diff --cached
if "%DIFF_CHOICE%"=="3" git show HEAD
pause
goto :menu
