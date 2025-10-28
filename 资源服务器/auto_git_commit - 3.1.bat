@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ==========================================================
:: 智能自动 Git 提交推送脚本（UTF-8 无 BOM 版）
:: ==========================================================
set "target=W:\java\SoftwareGraduationDesign\ACNiuOJ\wfyl.github.io"
set "remote=https://github.com/WFYL/wfyl.github.io.git"
set "interval=60"
set "logFile=%target%\auto-git.log"
:: ==========================================================

color 0A
echo.
echo ==========================================================
echo [AUTO-GIT] 智能自动提交推送脚本已启动
echo 目标目录: %target%
echo 推送间隔: %interval% 秒
echo 远程仓库: %remote%
echo 日志文件: %logFile%
echo ==========================================================
echo.

:loop
echo [%date% %time%] [INFO] 检查目标目录是否存在...
echo [%date% %time%] [INFO] 检查目标目录是否存在... >> "%logFile%"

if not exist "%target%" (
    color 0C
    echo [%date% %time%] [ERROR] 未找到目标目录: %target%
    echo [%date% %time%] [ERROR] 未找到目标目录: %target% >> "%logFile%"
    echo [%date% %time%] [WARN] 5 秒后重试...
    echo [%date% %time%] [WARN] 5 秒后重试... >> "%logFile%"
    ping -n 5 127.0.0.1 > nul
    goto loop
)

cd /d "%target%"

if not exist ".git" (
    color 0E
    echo [%date% %time%] [INFO] 初始化 Git 仓库中...
    echo [%date% %time%] [INFO] 初始化 Git 仓库中... >> "%logFile%"
    git init >> "%logFile%" 2>&1
    git remote add origin %remote% >> "%logFile%" 2>&1
)

echo [%date% %time%] [INFO] 检查 GitHub 网络连接...
echo [%date% %time%] [INFO] 检查 GitHub 网络连接... >> "%logFile%"

:: 使用 nslookup 替代 ping 进行更可靠的网络检测
nslookup github.com >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [%date% %time%] [WARN] 无法连接到 GitHub，请检查网络或代理。
    echo [%date% %time%] [WARN] 无法连接到 GitHub，请检查网络或代理。 >> "%logFile%"
    echo [%date% %time%] [INFO] 将在 %interval% 秒后重试...
    echo [%date% %time%] [INFO] 将在 %interval% 秒后重试... >> "%logFile%"
    ping -n %interval% 127.0.0.1 > nul
    goto loop
)

:: 检查是否有未提交的更改
git diff --quiet --cached
if %errorlevel%==0 (
    git diff --quiet
    if %errorlevel%==0 (
        color 0B
        echo [%date% %time%] [INFO] 没有文件变更，跳过提交。
        echo [%date% %time%] [INFO] 没有文件变更，跳过提交。 >> "%logFile%"
    ) else (
        color 0A
        echo [%date% %time%] [INFO] 检测到文件变更，开始提交...
        echo [%date% %time%] [INFO] 检测到文件变更，开始提交... >> "%logFile%"
        git add . >> "%logFile%" 2>&1

        :: 获取当前日期和时间
        for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (
            set "year=%%c"
            set "month=%%a"
            set "day=%%b"
        )
        set "nowtime=%time:~0,8%"
        set "nowtime=!nowtime: =0!"

        git commit -m "Auto commit - !year!/!month!/!day! !nowtime!" >> "%logFile%" 2>&1
        echo [%date% %time%] [INFO] 正在推送到远程仓库...
        echo [%date% %time%] [INFO] 正在推送到远程仓库... >> "%logFile%"

        :: 设置超时和重试
        git config --global http.lowSpeedLimit 0
        git config --global http.lowSpeedTime 999999
        git config --global http.postBuffer 1048576000

        git push origin HEAD >> "%logFile%" 2>&1
        if errorlevel 1 (
            color 0C
            echo [%date% %time%] [ERROR] 推送失败，将在 %interval% 秒后重试...
            echo [%date% %time%] [ERROR] 推送失败，将在 %interval% 秒后重试... >> "%logFile%"
        ) else (
            color 0A
            echo [%date% %time%] [SUCCESS] ✅ 推送成功！
            echo [%date% %time%] [SUCCESS] ✅ 推送成功！ >> "%logFile%"
        )
    )
)

color 07
echo ----------------------------------------------------------
git status -s
echo ----------------------------------------------------------
echo [%date% %time%] [INFO] 等待 %interval% 秒后再次检查...
echo [%date% %time%] [INFO] 等待 %interval% 秒后再次检查... >> "%logFile%"
ping -n %interval% 127.0.0.1 > nul
echo.
goto loop
