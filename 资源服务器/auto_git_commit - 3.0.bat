@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ==========================================================
:: 智能自动 Git 提交推送脚本（UTF-8 无 BOM 版）
:: ==========================================================
set "target=W:\java\SoftwareGraduationDesign\ACNiuOJ\wfyl.github.io"
set "remote=https://github.com/WFYL/wfyl.github.io.git"
set "interval=60"
:: ==========================================================

color 0A
echo.
echo ==========================================================
echo [AUTO-GIT] 智能自动提交推送脚本已启动
echo 目标目录: %target%
echo 推送间隔: %interval% 秒
echo 远程仓库: %remote%
echo ==========================================================
echo.

:loop
echo [INFO] 检查目标目录是否存在...
if not exist "%target%" (
    color 0C
    echo [ERROR] 未找到目标目录: %target%
    echo [WARN] 5 秒后重试...
    ping -n 5 127.0.0.1 > nul
    goto loop
)

cd /d "%target%"

if not exist ".git" (
    color 0E
    echo [INFO] 初始化 Git 仓库中...
    git init
    git remote add origin %remote%
)

echo [INFO] 检查 GitHub 网络连接...
ping -n 1 github.com >nul
if errorlevel 1 (
    color 0C
    echo [WARN] 无法连接到 GitHub，请检查网络或代理。
    echo [INFO] 将在 %interval% 秒后重试...
    ping -n %interval% 127.0.0.1 > nul
    goto loop
)

git diff --quiet
if %errorlevel%==0 (
    color 0B
    echo [INFO] 没有文件变更，跳过提交。
) else (
    color 0A
    echo [INFO] 检测到文件变更，开始提交...
    git add .
    for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set today=%%a/%%b/%%c
    set nowtime=%time:~0,8%
    git commit -m "Auto commit - !today! !nowtime!"
    echo [INFO] 正在推送到远程仓库...
    git push origin HEAD
    if errorlevel 1 (
        color 0C
        echo [ERROR] 推送失败，将在 %interval% 秒后重试...
    ) else (
        color 0A
        echo [SUCCESS] ✅ 推送成功！
    )
)

color 07
echo ----------------------------------------------------------
git status -s
echo ----------------------------------------------------------
echo [INFO] 等待 %interval% 秒后再次检查...
ping -n %interval% 127.0.0.1 > nul
echo.
goto loop
