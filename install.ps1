# Chatit.Cloud (CC) Installation Script for Windows PowerShell
# Fast installation with GitHub integration and PATH configuration
#
# Usage: irm https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.ps1 | iex

#Requires -Version 5.1

param(
    [switch]$Force = $false,
    [string]$InstallDirectory = "$env:LOCALAPPDATA\chatit"
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Configuration
$REPO_URL = "https://github.com/loayabdalslam/chatitcloud"
$REPO_NAME = "chatitcloud"
$BIN_NAME = "chatit"

# Color output helper
class ConsoleWriter {
    static [void] Info([string]$Message) {
        Write-Host "[INFO] $Message" -ForegroundColor Cyan
    }
    
    static [void] Success([string]$Message) {
        Write-Host "[✓] $Message" -ForegroundColor Green
    }
    
    static [void] Error([string]$Message) {
        Write-Host "[ERROR] $Message" -ForegroundColor Red
    }
    
    static [void] Warning([string]$Message) {
        Write-Host "[!] $Message" -ForegroundColor Yellow
    }
}

# System Check Functions
function Test-RequiredTools {
    [ConsoleWriter]::Info("Checking required tools...")
    
    $missingTools = @()
    
    # Check for Git
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        $missingTools += "Git"
    }
    
    # Check for Node or npm
    if (-not (Get-Command node -ErrorAction SilentlyContinue) -and `
        -not (Get-Command npm -ErrorAction SilentlyContinue)) {
        $missingTools += "Node.js (npm)"
    }
    
    if ($missingTools.Count -gt 0) {
        [ConsoleWriter]::Error("Missing required tools: $($missingTools -join ', ')")
        Write-Host ""
        Write-Host "Please install:"
        foreach ($tool in $missingTools) {
            switch ($tool) {
                "Git" {
                    Write-Host "  • Git: https://git-scm.com/download/win"
                }
                "Node.js (npm)" {
                    Write-Host "  • Node.js (>= 18.0.0): https://nodejs.org/"
                }
            }
        }
        return $false
    }
    
    [ConsoleWriter]::Success("All required tools found")
    return $true
}

function Test-NodeVersion {
    $nodeVersion = node -v 2>$null
    if ($nodeVersion) {
        $majorVersion = $nodeVersion -replace 'v(\d+)\..*', '$1'
        if ([int]$majorVersion -lt 18) {
            [ConsoleWriter]::Error("Node.js version 18.0.0 or higher required (current: $nodeVersion)")
            return $false
        }
    }
    return $true
}

# Installation Functions
function New-InstallDirectory {
    [ConsoleWriter]::Info("Setting up installation directory...")
    
    if (-not (Test-Path $InstallDirectory)) {
        New-Item -ItemType Directory -Path $InstallDirectory -Force | Out-Null
        [ConsoleWriter]::Success("Created $InstallDirectory")
    }
    
    return $true
}

function Get-RepositoryClone {
    [ConsoleWriter]::Info("Downloading Chatit.Cloud from GitHub...")
    
    $tempDir = [System.IO.Path]::GetTempPath()
    $uniqueDir = "chatit_install_$(Get-Random)"
    $repoDir = Join-Path $tempDir $uniqueDir $REPO_NAME
    
    try {
        git clone --depth=1 "$REPO_URL.git" "$repoDir" 2> $null
        [ConsoleWriter]::Success("Repository cloned")
        return $repoDir
    }
    catch {
        [ConsoleWriter]::Error("Failed to clone repository from $REPO_URL")
        return $null
    }
}

function Get-RuntimeEngine {
    if (Get-Command bun -ErrorAction SilentlyContinue) {
        return "bun"
    }
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        return "npm"
    }
    return $null
}

function Build-Project {
    param([string]$RepoDir)
    
    Push-Location $RepoDir
    try {
        [ConsoleWriter]::Info("Installing dependencies...")

        # npm install with dependency conflict avoidance
        if (-not (npm install --legacy-peer-deps 2>&1 | Write-Verbose)) {
            if ($LASTEXITCODE -ne 0) {
                [ConsoleWriter]::Error("npm install --legacy-peer-deps failed. Please inspect npm output and fix dependencies.")
                return $false
            }
        }

        [ConsoleWriter]::Success("Dependencies installed")

        [ConsoleWriter]::Info("Building project...")

        if (Get-Command bun -ErrorAction SilentlyContinue) {
            if (-not (bun run build 2>&1 | Write-Verbose)) {
                if ($LASTEXITCODE -ne 0) {
                    [ConsoleWriter]::Error("bun build failed. Please install or update Bun from https://bun.sh/")
                    return $false
                }
            }
        }
        else {
            [ConsoleWriter]::Warning("Bun not found. Attempting npm run build. If this fails, install Bun from https://bun.sh/")
            if (-not (npm run build 2>&1 | Write-Verbose)) {
                if ($LASTEXITCODE -ne 0) {
                    [ConsoleWriter]::Error("npm run build failed. Ensure Bun is installed or run 'npm run build' manually after installing Bun.")
                    return $false
                }
            }
        }

        [ConsoleWriter]::Success("Project built successfully")
        return $true
    }
    finally {
        Pop-Location
    }
}

function Install-Binary {
    param([string]$RepoDir)
    
    $distFile = Join-Path $RepoDir "dist" "chatit.js"
    
    if (-not (Test-Path $distFile)) {
        [ConsoleWriter]::Error("Build output not found at $distFile")
        return $false
    }
    
    [ConsoleWriter]::Info("Installing binary to $InstallDirectory...")
    
    Copy-Item $distFile -Destination (Join-Path $InstallDirectory "$BIN_NAME.js") -Force
    
    # Create batch wrapper for Windows command line
    $batchContent = @"
@echo off
node "$InstallDirectory\$BIN_NAME.js" %*
"@
    
    $batchFile = Join-Path $InstallDirectory "$BIN_NAME.cmd"
    Set-Content -Path $batchFile -Value $batchContent -Encoding ASCII
    
    [ConsoleWriter]::Success("Binary installed")
    return $true
}

function Update-PathEnvironment {
    [ConsoleWriter]::Info("Updating system PATH...")
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    
    if ($currentPath -notlike "*$InstallDirectory*") {
        $newPath = "$InstallDirectory;$currentPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        [ConsoleWriter]::Success("PATH updated in User environment")

        # Also update for current session
        $env:Path = $newPath
        
        Write-Host ""
        [ConsoleWriter]::Info("You may need to restart your terminal for changes to take effect")
    }
    else {
        [ConsoleWriter]::Warning("$InstallDirectory already in PATH")
    }
    
    return $true
}

function Test-Installation {
    [ConsoleWriter]::Info("Verifying installation...")
    
    # Reload Path from registry
    $newPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = $newPath
    
    $chatitCmd = Join-Path $InstallDirectory "$BIN_NAME.cmd"
    
    if (Test-Path $chatitCmd) {
        [ConsoleWriter]::Success("Installation verified")
        return $true
    }
    
    [ConsoleWriter]::Error("Installation verification failed")
    return $false
}

function Show-NextSteps {
    Write-Host ""
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "Installation Complete!" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host ""
    Write-Host "1. Restart your PowerShell/Command Prompt (or reload PATH):"
    Write-Host "   `$env:Path = [Environment]::GetEnvironmentVariable('Path','User')"
    Write-Host ""
    Write-Host "2. Initialize Chatit.Cloud:"
    Write-Host "   chatit init"
    Write-Host ""
    Write-Host "3. Configure your AI provider (Claude, OpenAI, etc.):"
    Write-Host "   chatit login"
    Write-Host ""
    Write-Host "4. Start using Chatit.Cloud:"
    Write-Host "   chatit help"
    Write-Host ""
    Write-Host "5. Get started with basic commands:"
    Write-Host "   chatit review         - Review code"
    Write-Host "   chatit commit         - Generate commit messages"
    Write-Host "   chatit brief          - Summarize code"
    Write-Host ""
    Write-Host "For more info: https://github.com/loayabdalslam/chatitcloud" -ForegroundColor Yellow
    Write-Host ""
}

function Remove-TempDirectory {
    param([string]$RepoDir)
    
    $parentDir = Split-Path (Split-Path $RepoDir)
    if (Test-Path $parentDir) {
        Remove-Item -Path $parentDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Main Installation Workflow
function Invoke-Installation {
    Write-Host ""
    Write-Host @"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║        Chatit.Cloud (CC) - Terminal AI Coding Assistant        ║
║                 Windows Installation Script                    ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan
    Write-Host ""
    
    # Step 1: Check requirements
    if (-not (Test-RequiredTools)) {
        exit 1
    }
    
    if (-not (Test-NodeVersion)) {
        exit 1
    }
    
    # Step 2: Setup
    if (-not (New-InstallDirectory)) {
        exit 1
    }
    
    # Step 3: Clone repository
    $repoDir = Get-RepositoryClone
    if (-not $repoDir) {
        exit 1
    }
    
    # Step 4: Detect runtime
    $runtime = Get-RuntimeEngine
    if (-not $runtime) {
        [ConsoleWriter]::Error("npm not found")
        Remove-TempDirectory $repoDir
        exit 1
    }
    
    [ConsoleWriter]::Success("Using $runtime for build")

    # Step 5: Build
    if (-not (Build-Project $repoDir)) {
        Remove-TempDirectory $repoDir
        exit 1
    }
    
    # Step 6: Install binary
    if (-not (Install-Binary $repoDir)) {
        Remove-TempDirectory $repoDir
        exit 1
    }
    
    # Step 7: Update PATH
    Update-PathEnvironment
    
    # Step 8: Verify
    Test-Installation | Out-Null
    
    # Step 9: Next steps
    Show-NextSteps
    
    # Cleanup
    Remove-TempDirectory $repoDir
}

# Run installation
Invoke-Installation
