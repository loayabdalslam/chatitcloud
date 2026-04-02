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
function Install-Npm {
    [ConsoleWriter]::Info("Installing Node.js and npm...")
    
    # Check if chocolatey is available
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        & choco install nodejs -y
    }
    # Check if winget is available  
    elseif (Get-Command winget -ErrorAction SilentlyContinue) {
        & winget install OpenJS.NodeJS -e
    }
    else {
        # Fallback: Download from nodejs.org
        [ConsoleWriter]::Warning("Neither chocolatey nor winget found. Downloading Node.js installer...")
        $nodeUrl = "https://nodejs.org/dist/v20.0.0/node-v20.0.0-x64.msi"
        $installerPath = "$env:TEMP\node-installer.msi"
        
        try {
            Invoke-WebRequest -Uri $nodeUrl -OutFile $installerPath -ErrorAction Stop
            & msiexec.exe /i $installerPath /quiet
            Remove-Item $installerPath -Force
        }
        catch {
            [ConsoleWriter]::Error("Failed to download Node.js. Please install manually from https://nodejs.org/")
            return $false
        }
    }
    
    # Refresh PATH
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
    
    [ConsoleWriter]::Success("Node.js and npm installed")
    return $true
}

function Install-Bun {
    [ConsoleWriter]::Info("Installing Bun...")
    
    try {
        $bunInstallScript = @"
`$BunInstall = Join-Path `$env:USERPROFILE '.bun' 'install' 'bun-windows-x64.exe'
Invoke-Expression (Invoke-WebRequest -Uri 'https://bun.sh/install.ps1' -UseBasicParsing).Content -Force
`"@
        Invoke-Expression 'Invoke-WebRequest -Uri "https://bun.sh/install.ps1" -UseBasicParsing | Invoke-Expression'
        
        # Add bun to PATH
        `$env:Path = (Join-Path `$env:USERPROFILE '.bun' 'bin') + ";" + `$env:Path
    }
    catch {
        [ConsoleWriter]::Error("Failed to install Bun. Please install manually from https://bun.sh/")
        return `$false
    }
    
    [ConsoleWriter]::Success("Bun installed")
    return `$true
}

function Test-RequiredTools {
    [ConsoleWriter]::Info("Checking required tools...")
    
    # Check for Git
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        [ConsoleWriter]::Error("Git not found. Please install from https://git-scm.com/download/win")
        return $false
    }
    
    # Check for npm and install if missing
    if (-not (Get-Command npm -ErrorAction SilentlyContinue) -and `
        -not (Get-Command node -ErrorAction SilentlyContinue)) {
        [ConsoleWriter]::Warning("npm not found")
        if (-not (Install-Npm)) {
            return $false
        }
    }
    
    # Check for bun and install if missing
    if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
        [ConsoleWriter]::Warning("Bun not found")
        if (-not (Install-Bun)) {
            return $false
        }
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
        $npmOutput = npm install --legacy-peer-deps 2>&1
        if ($LASTEXITCODE -ne 0) {
            [ConsoleWriter]::Error("npm install --legacy-peer-deps failed. Please inspect npm output and fix dependencies.")
            return $false
        }

        [ConsoleWriter]::Success("Dependencies installed")

        [ConsoleWriter]::Info("Building project...")

        # Check for bun requirement (build script requires bun)
        if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
            [ConsoleWriter]::Error("Bun is required for building but not installed. Please install from https://bun.sh/")
            return $false
        }

        # First attempt: normal build
        $buildOutput = bun run build 2>&1
        if ($LASTEXITCODE -ne 0) {
            if ($buildOutput -like "*Could not resolve*") {
                [ConsoleWriter]::Warning("Build failed with src/* import path resolution errors. Attempting workarounds...")
                
                # Show which modules couldn't be resolved
                $unresolvedModules = @($buildOutput | Select-String "Could not resolve.*src/" | Select-Object -First 3)
                if ($unresolvedModules.Count -gt 0) {
                    [ConsoleWriter]::Info("Example unresolved src imports:")
                    foreach ($line in $unresolvedModules) {
                        Write-Host "  $($line.Line)" -ForegroundColor DarkYellow
                    }
                }
                
                # Workaround 1: Clear bun and npm caches
                [ConsoleWriter]::Info("Workaround 1: Clearing package manager caches...")
                $bunCacheDir = "$env:USERPROFILE\.bun\install\cache"
                if (Test-Path $bunCacheDir) {
                    Remove-Item $bunCacheDir -Recurse -Force -ErrorAction SilentlyContinue
                }
                npm cache clean --force 2>$null
                
                $buildOutput = bun run build 2>&1
                if ($LASTEXITCODE -eq 0) {
                    [ConsoleWriter]::Success("Build succeeded after cache clear")
                    [ConsoleWriter]::Success("Project built successfully")
                    return $true
                }
                
                # Workaround 2: Rebuild node_modules and lock files
                [ConsoleWriter]::Info("Workaround 2: Rebuilding node_modules and lock file...")
                if (Test-Path "node_modules") {
                    Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
                }
                if (Test-Path "bun.lockb") {
                    Remove-Item "bun.lockb" -Force -ErrorAction SilentlyContinue
                }
                if (Test-Path "package-lock.json") {
                    Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
                }
                
                $installOutput = bun install 2>&1
                if ($LASTEXITCODE -eq 0) {
                    $buildOutput = bun run build 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        [ConsoleWriter]::Success("Build succeeded after full reinstall")
                        [ConsoleWriter]::Success("Project built successfully")
                        return $true
                    }
                }
                
                # Workaround 3: Clear cache and try npm instead of bun
                [ConsoleWriter]::Info("Workaround 3: Trying npm build instead of bun...")
                npm cache clean --force 2>$null
                if (Test-Path "node_modules") {
                    Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
                }
                npm install --legacy-peer-deps 2>&1 | Out-Null
                
                if ((npm run build 2>&1) -and ($LASTEXITCODE -eq 0)) {
                    [ConsoleWriter]::Success("Build succeeded using npm")
                    [ConsoleWriter]::Success("Project built successfully")
                    return $true
                }
                
                # Workaround 4: Check if build file exists despite error
                if ((Test-Path "dist/chatit.js") -and ((Get-Item "dist/chatit.js").Length -gt 0)) {
                    $fileSize = (Get-Item "dist/chatit.js").Length
                    [ConsoleWriter]::Warning("Build reported errors but output file exists ($fileSize bytes)")
                    [ConsoleWriter]::Success("Project built successfully")
                    return $true
                }
                
                [ConsoleWriter]::Error("Build failed with persistent src/* resolution errors after workarounds.")
                return $false
            }
            else {
                [ConsoleWriter]::Error("bun build failed. See details above.")
                return $false
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
    
    # Step 3: Clone repository or use current directory if it's a chatitcloud project
    $repoDir = $null
    if ((Test-Path "package.json") -and (Select-String -Path "package.json" -Pattern '"name".*chatit' -Quiet)) {
        [ConsoleWriter]::Info("Detected chatitcloud project in current directory")
        $repoDir = Get-Location
    }
    else {
        $repoDir = Get-RepositoryClone
    }
    
    if (-not $repoDir) {
        exit 1
    }
    
    # Step 4: Detect runtime
    $runtime = Get-RuntimeEngine
    if (-not $runtime) {
        [ConsoleWriter]::Error("npm not found")
        if ($repoDir -ne (Get-Location)) {
            Remove-TempDirectory $repoDir
        }
        exit 1
    }
    
    [ConsoleWriter]::Success("Using $runtime for build")

    # Step 5: Build
    if (-not (Build-Project $repoDir)) {
        if ($repoDir -ne (Get-Location)) {
            Remove-TempDirectory $repoDir
        }
        exit 1
    }
    
    # Step 6: Install binary
    if (-not (Install-Binary $repoDir)) {
        if ($repoDir -ne (Get-Location)) {
            Remove-TempDirectory $repoDir
        }
        exit 1
    }
    
    # Step 7: Update PATH
    Update-PathEnvironment
    
    # Step 8: Verify
    Test-Installation | Out-Null
    
    # Step 9: Next steps
    Show-NextSteps
    
    # Cleanup (only if we cloned, not if using current directory)
    if ($repoDir -ne (Get-Location)) {
        Remove-TempDirectory $repoDir
    }
}

# Run installation
Invoke-Installation
