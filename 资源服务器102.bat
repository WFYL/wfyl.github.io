@echo off

:: ==========================================================
:: atuo Git
:: wfyl 2025/10/28 13:54:30
:: ==========================================================

echo ----------------------------------------------------------
echo GO!GO!GO!... started
echo ----------------------------------------------------------
set target=w:\java\SoftwareGraduationDesign\ACNiuOJ\wfyl.github.io
set interval=50

echo ----------------------------------------------------------
:loop
echo Checking if new Info

if not exist "%target%" (
    echo Error: ifdir!!NO!! dir not found
    ping -n 5 127.0.0.1 > nul
    goto loop
)

echo ----------------------------------------------------------
cd /d "%target%"

if not exist ".git" (
    echo into Git home... Initializing git repository...
    git init
)

echo ----------------------------------------------------------
git add .
git commit -m "Auto commit - %date% %time%"
echo Going Git Home ! GO!GO!GO! HeiKaFeiPingWeiYouDuoNong ......
git push origin HEAD

echo ----------------------------------------------------------

echo ----------------------------------------------------------
echo Waiting %interval% s time to run Next GO!GO!GO!...
ping -n %interval% 127.0.0.1 > nul
goto loop