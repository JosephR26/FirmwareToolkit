@echo off
REM Git Configuration for Embedded Development
REM Optimizes Git settings for firmware projects

setlocal enabledelayedexpansion

echo ========================================
echo   Git Configuration for Embedded Dev
echo ========================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Git is not installed
    echo [ERROR] Install Git first: winget install Git.Git
    exit /b 1
)

echo [INFO] Configuring Git for firmware development...
echo.

REM Core settings
echo [STEP 1/8] Core Settings...
git config --global core.autocrlf true
git config --global core.longpaths true
git config --global core.editor "code --wait"
git config --global init.defaultBranch main
echo [SUCCESS] Core settings configured

REM Pull/Push settings
echo.
echo [STEP 2/8] Pull/Push Settings...
git config --global pull.rebase false
git config --global push.default simple
git config --global push.followTags true
echo [SUCCESS] Pull/push settings configured

REM Diff and merge settings
echo.
echo [STEP 3/8] Diff and Merge Settings...
git config --global diff.tool vscode
git config --global difftool.vscode.cmd "code --wait --diff \$LOCAL \$REMOTE"
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait \$MERGED"
git config --global merge.conflictStyle diff3
echo [SUCCESS] Diff/merge tools configured

REM Commit settings
echo.
echo [STEP 4/8] Commit Settings...
git config --global commit.gpgSign false
git config --global commit.template "%USERPROFILE%\.gitmessage"
echo [SUCCESS] Commit settings configured

REM Branch settings
echo.
echo [STEP 5/8] Branch Settings...
git config --global branch.autoSetupRebase always
echo [SUCCESS] Branch settings configured

REM Performance settings
echo.
echo [STEP 6/8] Performance Settings...
git config --global pack.threads 0
git config --global pack.windowMemory 256m
git config --global core.preloadIndex true
git config --global core.fscache true
git config --global gc.auto 256
echo [SUCCESS] Performance settings configured

REM Aliases for common operations
echo.
echo [STEP 7/8] Git Aliases...
git config --global alias.st "status -sb"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.lg "log --graph --pretty=format:'%%Cred%%h%%Creset -%%C(yellow)%%d%%Creset %%s %%Cgreen(%%cr) %%C(bold blue)<%%an>%%Creset' --abbrev-commit"
git config --global alias.amend "commit --amend --no-edit"
git config --global alias.undo "reset --soft HEAD~1"
echo [SUCCESS] Aliases configured

REM Create commit message template
echo.
echo [STEP 8/8] Commit Template...
(
echo # Conventional Commits Format
echo # type(scope^): description
echo #
echo # Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
echo #
echo # Example:
echo #   feat(esp32^): add deep sleep mode
echo #   fix(wifi^): correct reconnection logic
echo #   perf(bluetooth^): optimize BLE advertising
echo.
echo.
echo.
echo # --- COMMIT END ---
echo # Remember:
echo #  - Use imperative mood ("add" not "added"^)
echo #  - Keep first line under 72 characters
echo #  - Reference issues/PRs in body
) > %USERPROFILE%\.gitmessage
echo [SUCCESS] Commit template created

echo.
echo ========================================
echo   Configuration Complete!
echo ========================================
echo.
echo [INFO] Git Aliases Available:
echo   git st        - Short status
echo   git lg        - Pretty log graph
echo   git amend     - Amend last commit
echo   git undo      - Undo last commit (soft)
echo   git unstage   - Unstage files
echo.
echo [INFO] Your Git configuration:
git config --global --list | findstr "user\|core\|alias"
echo.

pause
