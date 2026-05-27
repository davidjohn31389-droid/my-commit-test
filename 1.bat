@echo off
setlocal

REM Get last commit datetime
for /f "delims=" %%A in ('git log -1 --date^=format-local:"%%Y-%%m-%%d %%H:%%M:%%S" --format^=%%cd') do (
    set LAST_COMMIT_DATETIME=%%A
)

REM Get last commit message
for /f "delims=" %%A in ('git log -1 --format^=%%s') do (
    set LAST_COMMIT_TEXT=%%A
)

REM Get username
for /f "delims=" %%A in ('git log -1 --format^=%%an') do (
    set USER_NAME=%%A
)

REM Get email
for /f "delims=" %%A in ('git log -1 --format^=%%ae') do (
    set USER_EMAIL=%%A
)

REM Get current branch
for /f "delims=" %%A in ('git rev-parse --abbrev-ref HEAD') do (
    set CURRENT_BRANCH=%%A
)

echo ==========================================
echo Last Commit DateTime: %LAST_COMMIT_DATETIME%
echo Last Commit Message : %LAST_COMMIT_TEXT%
echo User                : %USER_NAME% ^(%USER_EMAIL%^)
echo Branch              : %CURRENT_BRANCH%
echo ==========================================

REM Configure local git identity
git config --local user.name "%USER_NAME%"
git config --local user.email "%USER_EMAIL%"

REM Stage files
git add .

REM Preserve old commit date
set GIT_AUTHOR_DATE=%LAST_COMMIT_DATETIME%
set GIT_COMMITTER_DATE=%LAST_COMMIT_DATETIME%

REM Amend commit
git commit --amend -m "%LAST_COMMIT_TEXT%" --no-verify

IF ERRORLEVEL 1 (
    echo.
    echo Commit amend failed!
    pause
    exit /b 1
)

REM Push changes
git push -u origin "%CURRENT_BRANCH%" --force --no-verify

IF ERRORLEVEL 1 (
    echo.
    echo Push failed!
    pause
    exit /b 1
)

echo.
echo Done successfully!
pause