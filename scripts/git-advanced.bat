@echo off
REM Advanced Git Automation Tools

setlocal enabledelayedexpansion

:menu
cls
echo ========================================
echo   Advanced Git Tools
echo ========================================
echo.
echo   1. Clean merged branches
echo   2. Setup Git LFS (Large File Storage)
echo   3. Create release tag
echo   4. Generate changelog
echo   5. Branch analytics
echo   6. Stale branch cleanup
echo   7. Setup Git attributes
echo   8. Repo health check
echo   0. Exit
echo.
echo ========================================
set /p CHOICE="Select option (0-8): "

if "%CHOICE%"=="0" goto :eof
if "%CHOICE%"=="1" goto :clean_branches
if "%CHOICE%"=="2" goto :setup_lfs
if "%CHOICE%"=="3" goto :create_release
if "%CHOICE%"=="4" goto :generate_changelog
if "%CHOICE%"=="5" goto :branch_analytics
if "%CHOICE%"=="6" goto :stale_cleanup
if "%CHOICE%"=="7" goto :setup_attributes
if "%CHOICE%"=="8" goto :health_check
goto :menu

:clean_branches
echo.
echo [CLEAN MERGED BRANCHES]
echo ========================================
echo.
echo [INFO] Finding merged branches...
git branch --merged main | findstr /v "main master develop"

set /p CONFIRM="Delete these branches? (Y/N): "
if /i "%CONFIRM%"=="Y" (
    for /f "tokens=*" %%b in ('git branch --merged main ^| findstr /v "main master develop"') do (
        git branch -d %%b
    )
    echo [SUCCESS] Merged branches deleted
) else (
    echo [INFO] Cleanup cancelled
)
pause
goto :menu

:setup_lfs
echo.
echo [SETUP GIT LFS]
echo ========================================
echo.
git lfs install
git lfs track "*.bin"
git lfs track "*.elf"
git lfs track "*.hex"
echo [SUCCESS] Git LFS configured for binary files
pause
goto :menu

:create_release
echo.
echo [CREATE RELEASE TAG]
echo ========================================
echo.
set /p VERSION="Version (e.g., v1.0.0): "
set /p MESSAGE="Release message: "
git tag -a %VERSION% -m "%MESSAGE%"
echo [SUCCESS] Tag created: %VERSION%
echo [INFO] Push with: git push origin %VERSION%
pause
goto :menu

:generate_changelog
echo.
echo [GENERATE CHANGELOG]
echo ========================================
echo.
echo # Changelog> CHANGELOG.md
echo.>> CHANGELOG.md
git log --pretty=format:"- %%s (%%h)" --reverse >> CHANGELOG.md
echo.>> CHANGELOG.md
echo [SUCCESS] CHANGELOG.md generated
pause
goto :menu

:branch_analytics
echo.
echo [BRANCH ANALYTICS]
echo ========================================
echo.
echo Total branches:
git branch -a | find /c "/"
echo.
echo Recent branches:
git for-each-ref --sort=-committerdate --format='%%(refname:short) - %%(committerdate:relative)' refs/heads | more
pause
goto :menu

:stale_cleanup
echo.
echo [STALE BRANCH CLEANUP]
echo ========================================
echo.
echo Branches older than 90 days:
git for-each-ref --sort=-committerdate --format='%%(refname:short) - %%(committerdate:relative)' refs/heads | findstr "months\|year"
pause
goto :menu

:setup_attributes
echo.
echo [SETUP GIT ATTRIBUTES]
echo ========================================
echo.
echo # Git Attributes> .gitattributes
echo # Binary files>> .gitattributes
echo *.bin binary>> .gitattributes
echo *.elf binary>> .gitattributes
echo *.hex binary>> .gitattributes
echo.>> .gitattributes
echo # Text files>> .gitattributes
echo *.cpp text eol=lf>> .gitattributes
echo *.h text eol=lf>> .gitattributes
echo *.c text eol=lf>> .gitattributes
echo *.ini text eol=lf>> .gitattributes
echo [SUCCESS] .gitattributes created
pause
goto :menu

:health_check
echo.
echo [REPOSITORY HEALTH CHECK]
echo ========================================
echo.
echo [CHECK 1] Large files:
git ls-files | xargs ls -lh | sort -k5 -h -r | head -10
echo.
echo [CHECK 2] Uncommitted changes:
git status -s
echo.
echo [CHECK 3] Unpushed commits:
git log @{u}.. --oneline
echo.
pause
goto :menu
