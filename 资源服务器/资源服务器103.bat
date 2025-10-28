@echo off

chcp 65001 >nul
setlocal enabledelayedexpansion

:: ==========================================================
:: atuo Git
:: wfyl 2025/10/28 13:54:30
:: ==========================================================

echo ##########################################################
echo GO!GO!GO!... started wfyl.github.io
echo ##########################################################
set target=w:\java\SoftwareGraduationDesign\ACNiuOJ\wfyl.github.io
set interval=1
set num=1

:loop
echo + 
echo +++++++++++++++++++++++++++++%num%+++++++++++++++++++++++++++++
echo + 
set /a num+=1
echo ----------------------------------------------------------
echo Checking if new Info

if not exist "%target%" (
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!NO!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo Error: ifdir!!NO!! dir not found
    ping -n 5 127.0.0.1 > nul
    goto loop
)

cd /d "%target%"

echo ---------------------------HOME---------------------------
if not exist ".git" (
    echo into Git home... Initializing git repository... YES YES YES YES YES YES YES YES
    git init
)

echo ---------------------------AND----------------------------
git add .
git commit -m "Auto commit - %date% %time%"
echo ---------------------------PUSH---------------------------
echo Going Git Home ! GO!GO!GO! HeiKaFeiPingWeiYouDuoNong ......
git push origin HEAD

:: 检查推送是否成功
if %errorlevel% neq 0 (
    echo 推送失败！正在重新尝试提交并推送...
    git add .
    git commit -m "Retry commit - %date% %time%"
    echo 重新提交完成，再次尝试推送...
    git push origin HEAD
    if %errorlevel% neq 0 (
        echo 二次推送也失败了，请检查网络或仓库配置。
    ) else (
        echo 二次推送成功！
    )
) else (
    echo 推送成功！
)

echo -------------------------Waiting--------------------------
echo Waiting %interval% s time to run Next GO!GO!GO!...
ping -n %interval% 127.0.0.1 > nul
goto loop