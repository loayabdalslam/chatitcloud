@echo off
REM ============================================================================
REM CC - AGENTIC CHATIT.CLOUD CODE ASSISTANT
REM Installation & Setup Script for Windows
REM ============================================================================

setlocal enabledelayedexpansion
color 0A

REM Configuration
set REPO_NAME=chatit
set INSTALL_DIR=%USERPROFILE%\.chatit
set CONFIG_DIR=%USERPROFILE%\.claude

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  CC - AGENTIC CHATIT.CLOUD CODE ASSISTANT                 ║
echo ║  Windows Installation Script                               ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM ============================================================================
REM Check Prerequisites
REM ============================================================================

echo [*] Checking Prerequisites...
echo.

REM Check for Node.js
where node >nul 2>nul
if %errorlevel% == 0 (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [OK] Node.js found: !NODE_VERSION!
    set RUNTIME=node
) else (
    echo [ERROR] Node.js not found!
    echo.
    echo Install Node.js from: https://nodejs.org (18+ required)
    echo Or install Bun from: https://bun.sh
    pause
    exit /b 1
)

REM Check for Git
where git >nul 2>nul
if %errorlevel% == 0 (
    for /f "tokens=*" %%i in ('git --version') do set GIT_VERSION=%%i
    echo [OK] Git found: !GIT_VERSION!
) else (
    echo [WARN] Git not found - manual setup may be required
)

echo.

REM ============================================================================
REM Create Installation Directory
REM ============================================================================

echo [*] Setting up Installation Directory...
echo.

if exist "%INSTALL_DIR%" (
    echo [INFO] Installation directory already exists: %INSTALL_DIR%
    set /p UPDATE="Do you want to update? (y/n): "
    if /i not "!UPDATE!"=="y" (
        echo [INFO] Keeping existing installation
        goto :skip_setup
    )
) else (
    mkdir "%INSTALL_DIR%"
    echo [OK] Created installation directory: %INSTALL_DIR%
)

:skip_setup

REM ============================================================================
REM Install Dependencies
REM ============================================================================

echo.
echo [*] Installing Dependencies...
echo.

cd /d "%INSTALL_DIR%"

if "!RUNTIME!"=="node" (
    echo [INFO] Using npm for package management...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] npm install failed!
        pause
        exit /b 1
    )
)

echo [OK] Dependencies installed successfully
echo.

REM ============================================================================
REM Setup Configuration Directory
REM ============================================================================

echo [*] Setting up Configuration Directory...
echo.

if not exist "%CONFIG_DIR%" (
    mkdir "%CONFIG_DIR%"
    echo [OK] Created config directory: %CONFIG_DIR%
)

if not exist "%CONFIG_DIR%\settings.json" (
    (
        echo {
        echo   "theme": "white",
        echo   "model": "claude-opus-4-6",
        echo   "syntaxHighlighting": true,
        echo   "apiKeyHelper": null
        echo }
    ) > "%CONFIG_DIR%\settings.json"
    echo [OK] Created default settings.json
) else (
    echo [INFO] settings.json already exists
)

echo.

REM ============================================================================
REM Create Batch Wrapper
REM ============================================================================

echo [*] Creating Executable Command...
echo.

set "CHATIT_BATCH=%INSTALL_DIR%\chatit.bat"

(
    echo @echo off
    echo cd /d "%INSTALL_DIR%"
    echo %RUNTIME% run src/main.tsx %%%%*
) > "!CHATIT_BATCH!"

echo [OK] Created wrapper script: !CHATIT_BATCH!
echo.

REM ============================================================================
REM Add to PATH (Optional)
REM ============================================================================

echo [*] Adding to PATH...
echo.

setx PATH "%INSTALL_DIR%;%PATH%" >nul
echo [OK] Added installation directory to PATH
echo.

REM ============================================================================
REM Provider Setup
REM ============================================================================

echo.
set /p SETUP_PROVIDER="Would you like to configure a provider now? (y/n): "

if /i "!SETUP_PROVIDER!"=="y" (
    cls
    echo.
    echo Choose your AI provider:
    echo.
    echo 1) Anthropic (requires API key^)
    echo 2) OpenRouter (free tier available^)
    echo 3) OpenCode (local server^)
    echo 4) Skip for now
    echo.
    set /p PROVIDER_CHOICE="Select option (1-4): "

    if "!PROVIDER_CHOICE!"=="1" (
        echo.
        set /p API_KEY="Enter your Anthropic API key: "
        setx ANTHROPIC_API_KEY "!API_KEY!"
        echo [OK] API key configured
    ) else if "!PROVIDER_CHOICE!"=="2" (
        echo.
        echo [INFO] OpenRouter selected (free tier^)
        echo [INFO] Free models available without API key
        set /p OPENROUTER_KEY="Enter OpenRouter API key (optional, press Enter to skip^): "
        if not "!OPENROUTER_KEY!"=="" (
            setx OPENROUTER_API_KEY "!OPENROUTER_KEY!"
            echo [OK] OpenRouter key configured
        ) else (
            echo [INFO] Using OpenRouter free tier
        )
    ) else if "!PROVIDER_CHOICE!"=="3" (
        echo.
        set /p OPENCODE_URL="Enter OpenCode server URL (default: http://localhost:4096^): "
        if "!OPENCODE_URL!"=="" set "OPENCODE_URL=http://localhost:4096"
        setx OPENCODE_ENDPOINT "!OPENCODE_URL!"
        echo [OK] OpenCode endpoint configured
    ) else (
        echo [INFO] Skipping provider setup for now
    )
)

REM ============================================================================
REM Summary
REM ============================================================================

cls
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  Installation Complete! 🎉                                ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

echo Installation Details:
echo   - Install Directory: %INSTALL_DIR%
echo   - Config Directory: %CONFIG_DIR%
echo   - Runtime: !RUNTIME!
echo.

echo Next Steps:
echo.
echo 1. Try Chatit:
echo    chatit "Hello, help me with this code"
echo.
echo 2. View available commands:
echo    chatit /help
echo.
echo 3. Change theme:
echo    chatit /theme
echo.
echo 4. Switch providers:
echo    chatit /provider
echo.
echo 5. View usage guide:
echo    type "%INSTALL_DIR%\CHATIT_README.md"
echo.

echo Documentation:
echo   - Full Guide: %INSTALL_DIR%\CHATIT_README.md
echo   - Quick Start: %INSTALL_DIR%\QUICK_START.md
echo   - Implementation: %INSTALL_DIR%\IMPLEMENTATION_SUMMARY.md
echo.

echo Press any key to close...
pause >nul
