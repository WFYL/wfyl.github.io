@echo off

set "target=W:\java\SoftwareGraduationDesign\ACNiuOJ\wfyl.github.io"
set "remote=https://github.com/WFYL/wfyl.github.io.git"
set "interval=60"
set "logFile=%target%\auto-git.log"

color 0A
echo.
echo ==========================================================
echo [AUTO-GIT]
echo dir  : %target%
echo time : %interval% 秒
echo home : %remote%
echo log  : %logFile%
echo ==========================================================
echo.

:loop
echo [%date% %time%] [INFO] ifdir...
echo [%date% %time%] [INFO] ifdir... >> "%logFile%"

if not exist "%target%" (
    color 0C
    echo [%date% %time%] [ERROR] ifdir !!NO!!: %target%
    echo [%date% %time%] [ERROR] ifdir !!NO!!: %target% >> "%logFile%"
    echo [%date% %time%] [WARN] 5s time to run...
    echo [%date% %time%] [WARN] 5s time to run... >> "%logFile%"
    ping -n 5 127.0.0.1 > nul
    goto loop
)

cd /d "%target%"

if not exist ".git" (
    color 0E
    echo [%date% %time%] [INFO] into Git home...
    echo [%date% %time%] [INFO] into Git home... >> "%logFile%"
    git init >> "%logFile%" 2>&1
    git remote add origin %remote% >> "%logFile%" 2>&1
)

echo [%date% %time%] [INFO] if GitHub web had ERR...
echo [%date% %time%] [INFO] if GitHub web had ERR... >> "%logFile%"

nslookup github.com >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [%date% %time%] [WARN] ping GitHub is had ERR...
    echo [%date% %time%] [WARN] ping GitHub is had ERR... >> "%logFile%"
    echo [%date% %time%] [INFO] ERR had %interval% s time to run...
    echo [%date% %time%] [INFO] ERR had %interval% s time to run... >> "%logFile%"
    ping -n %interval% 127.0.0.1 > nul
    goto loop
)

git diff --quiet --cached
if %errorlevel%==0 (
    git diff --quiet
    if %errorlevel%==0 (
        color 0B
        echo [%date% %time%] [WARN] new Info never again
        echo [%date% %time%] [WARN] new Info never again >> "%logFile%"
    ) else (
        color 0A
        echo [%date% %time%] [INFO] new Info , GO!GO!GO! HeiKaFeiPingWeiYouDuoNong ...
        echo [%date% %time%] [INFO] new Info , GO!GO!GO! HeiKaFeiPingWeiYouDuoNong ... >> "%logFile%"
        git add . >> "%logFile%" 2>&1

        for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (
            set "year=%%c"
            set "month=%%a"
            set "day=%%b"
        )
        set "nowtime=%time:~0,8%"
        set "nowtime=!nowtime: =0!"

        git commit -m "Auto commit - !year!/!month!/!day! !nowtime!" >> "%logFile%" 2>&1
        echo [%date% %time%] [INFO] Going Git Home ! GO!GO!GO! HeiKaFeiPingWeiYouDuoNong ......
        echo [%date% %time%] [INFO] Going Git Home ! GO!GO!GO! HeiKaFeiPingWeiYouDuoNong ...... >> "%logFile%"

        git config --global http.lowSpeedLimit 0
        git config --global http.lowSpeedTime 999999
        git config --global http.postBuffer 1048576000

        git push origin HEAD >> "%logFile%" 2>&1
        if errorlevel 1 (
            color 0C
            echo [%date% %time%] [ERROR] never into GitHome, %interval% s time to run...
            echo [%date% %time%] [ERROR] never into GitHome, %interval% s time to run... >> "%logFile%"
        ) else (
            color 0A
            echo [%date% %time%] [SUCCESS] ✅ YES!
            echo [%date% %time%] [SUCCESS] ✅ YES! >> "%logFile%"
        )
    )
)

color 07
echo ----------------------------------------------------------
git status -s
echo ----------------------------------------------------------
echo [%date% %time%] [INFO] had %interval% s time to run Next GO!GO!GO!...
echo [%date% %time%] [INFO] had %interval% s time to run Next GO!GO!GO!... >> "%logFile%"
ping -n %interval% 127.0.0.1 > nul
echo.
goto loop
