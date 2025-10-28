@echo off

:: ==========================================================
:: atuo Git
:: wfyl 2025/10/28 13:54:30
:: ==========================================================

echo Auto git commit script started
set target=w:\java\SoftwareGraduationDesign\ACNiuOJ\wfyl.github.io
set interval=50

:loop
echo Checking for changes...

if not exist "%target%" (
    echo Error: Target directory not found
    ping -n 5 127.0.0.1 > nul
    goto loop
)

cd /d "%target%"

if not exist ".git" (
    echo Initializing git repository...
    git init
)

git add .
git commit -m "Auto commit - %date% %time%"
git push origin HEAD

echo Waiting %interval% seconds...
ping -n %interval% 127.0.0.1 > nul
goto loop