# Installation Guide

Comprehensive installation instructions for Chatit.Cloud on all platforms.

## Table of Contents

1. [Quick Installation](#quick-installation)
2. [Platform-Specific Installation](#platform-specific-installation)
3. [Manual Installation](#manual-installation)
4. [Verification](#verification)
5. [Troubleshooting](#troubleshooting)
6. [Uninstallation](#uninstallation)

---

## Quick Installation

### Linux/macOS (Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.ps1 | iex
```

After installation, reload your shell configuration:
```bash
source ~/.bashrc  # or ~/.zshrc for zsh
```

---

## Platform-Specific Installation

### macOS

#### Prerequisites

```bash
# Using Homebrew
brew install node git

# Or using MacPorts
sudo port install nodejs18 git
```

#### Installation Steps

```bash
# Method 1: Fast installation script
curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash

# Method 2: Manual installation
git clone https://github.com/loayabdalslam/chatitcloud.git
cd chatitcloud
npm install
npm run build
sudo npm install -g .
```

#### Verify Installation

```bash
chatit --version
chatit init
```

---

### Linux (Ubuntu/Debian)

#### Prerequisites

```bash
# Update package manager
sudo apt update

# Install Node.js (version 18+)
sudo apt install nodejs npm git

# Or using NodeSource repository for latest version
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs git
```

#### Installation Steps

```bash
# Fast installation
curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash

# Update PATH if needed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Verify Installation

```bash
which chatit
chatit --version
```

---

### Linux (Fedora/RHEL/CentOS)

#### Prerequisites

```bash
sudo dnf install nodejs npm git
# or for older systems
sudo yum install nodejs npm git
```

#### Installation Steps

```bash
curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash
```

---

### Windows 10/11

#### Prerequisites

1. **Install Git for Windows**
   - Download from https://git-scm.com/download/win
   - Use default installation settings

2. **Install Node.js**
   - Download from https://nodejs.org/ (LTS version, 18+)
   - Run installer and follow prompts

3. **Install PowerShell 7+ (recommended)**
   - Download from https://github.com/PowerShell/PowerShell
   - Or use Windows PowerShell 5.1 (built-in)

#### Installation Steps

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.ps1 | iex
```

#### Windows Subsystem for Linux (WSL2)

For better compatibility, install in WSL2:

```bash
# In WSL2 terminal
curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash
```

---

## Manual Installation

For developers or advanced users who want more control:

### Step 1: Clone Repository

```bash
git clone https://github.com/loayabdalslam/chatitcloud.git
cd chatitcloud
```

### Step 2: Install Dependencies

Using npm (default):
```bash
npm install
```

Or using Bun (faster, optional):
```bash
# Install Bun first: https://bun.sh/
bun install
```

### Step 3: Build the Project

```bash
npm run build
# or with Bun
bun run build
```

Output will be in `dist/chatitcloud.js`

### Step 4: Install Globally

**Option A: Using npm**
```bash
npm install -g .
```

**Option B: Manual PATH setup (Linux/macOS)**
```bash
# Create symlink
sudo ln -s "$(pwd)/dist/chatitcloud.js" /usr/local/bin/chatit
chmod +x dist/chatitcloud.js

# Make executable
chmod +x /usr/local/bin/chatit
```

**Option C: Manual PATH setup (macOS only)**
```bash
# Using homebrew cellar
brew link chatit --force
# Or add to PATH
echo 'export PATH="/usr/local/opt/chatit/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Option D: Windows (Manual)**
```powershell
# Create wrapper script in Program Files
$InstallDir = "C:\Program Files\chatit"
mkdir $InstallDir -Force

# Copy binary
Copy-Item "dist/chatitcloud.js" -Destination "$InstallDir/chatitcloud.js"

# Create batch wrapper
$Wrapper = @"
@echo off
node "$InstallDir\chatitcloud.js" %*
"@
Set-Content -Path "$InstallDir/chatit.cmd" -Value $Wrapper

# Add to PATH (run as Administrator)
[Environment]::SetEnvironmentVariable(
    "Path",
    "$([Environment]::GetEnvironmentVariable("Path","Machine"));$InstallDir",
    "Machine"
)
```

### Step 5: Verify Installation

```bash
chatit --version
which chatit  # Should show installed location
```

---

## Verification

### Test Basic Functionality

```bash
# Check if chatit is accessible
chatit --version

# Initialize and configure
chatit init

# Run help command
chatit help

# Check system status
chatit doctor
```

### Environment Check

```bash
# Verify Node.js
node --version

# Verify npm
npm --version

# Verify git
git --version

# Verify chatit
chatit status
```

---

## Troubleshooting

### Issue: "Command not found: chatit"

**Solution 1: Reload shell configuration**
```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc

# For fish
source ~/.config/fish/config.fish
```

**Solution 2: Check installation directory**
```bash
# Verify binary exists
ls -la ~/.local/bin/chatit

# Or check PATH
echo $PATH
```

**Solution 3: Manual PATH addition**
```bash
# Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export PATH="$HOME/.local/bin:$PATH"
```

### Issue: "Node.js version too old"

```bash
# Check current version
node --version

# Install latest Node.js
# macOS
brew install node@20

# Linux (Ubuntu/Debian)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs

# Or use NVM for version management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20
```

### Issue: Permission denied on Linux/macOS

```bash
# Make binary executable
chmod +x ~/.local/bin/chatit

# Or reinstall with proper permissions
npm install -g .
```

### Issue: npm install fails

```bash
# Clear npm cache
npm cache clean --force

# Retry installation
npm install

# Or use npm ci for clean installation
npm ci
```

### Issue: Git clone fails

```bash
# Check git configuration
git config --global user.name
git config --global user.email

# Verify SSH key (if using SSH)
ssh -T git@github.com

# Or use HTTPS URL
git clone https://github.com/loayabdalslam/chatitcloud.git
```

### Issue: Build fails

```bash
# Check Node.js version
node --version  # Should be >= 18.0.0

# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Try with verbose output
npm run build -- --verbose
```

---

## Uninstallation

### Using npm

```bash
npm uninstall -g chatit
```

### Manual removal (Linux/macOS)

```bash
# Remove binary
rm ~/.local/bin/chatit
rm /usr/local/bin/chatit

# Remove from PATH (edit ~/.bashrc or ~/.zshrc)
# Remove the line: export PATH="$HOME/.local/bin:$PATH"
```

### Remove configuration (optional)

```bash
# Remove Chatit configuration directory
rm -rf ~/.chatit

# Remove Chatit cache
rm -rf ~/.cache/chatit
```

### Windows removal

```powershell
# Remove installation directory
Remove-Item -Path "$env:LOCALAPPDATA\chatit" -Recurse -Force

# Remove from PATH (Settings > Environment Variables > Edit System Environment Variables)
```

---

## Advanced Installation Options

### Docker Installation

```dockerfile
FROM node:20-slim

WORKDIR /app

RUN git clone https://github.com/loayabdalslam/chatitcloud.git . && \
    npm install && \
    npm run build && \
    npm install -g .

ENTRYPOINT ["chatit"]
CMD ["init"]
```

Build and run:
```bash
docker build -t chatit .
docker run -it chatit help
```

### Development Installation

For contributors:

```bash
git clone https://github.com/loayabdalslam/chatitcloud.git
cd chatitcloud

npm install
npm run dev  # Development mode with hot reload
npm run lint
npm run format
npm run test
```

---

## Runtime Selection

### Using Bun (Faster)

```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Use Bun for installation and development
bun install
bun run build
bun run dev
```

### Using npm (Default)

```bash
npm install
npm run build
npm run dev
```

---

## Next Steps After Installation

1. **Initialize Chatit:**
   ```bash
   chatit init
   ```

2. **Configure AI Provider:**
   ```bash
   chatit login
   ```

3. **Set up GitHub Integration:**
   ```bash
   chatit config github
   ```

4. **Explore Commands:**
   ```bash
   chatit help
   chatit help review
   chatit help commit
   ```

5. **Read Documentation:**
   - Visit https://github.com/loayabdalslam/chatitcloud
   - Check `/docs` directory for detailed guides

---

## Getting Help

If you encounter issues:

1. **Check Diagnostics:**
   ```bash
   chatit doctor
   chatit status
   ```

2. **Enable Debug Mode:**
   ```bash
   CC_DEBUG=1 chatit init
   ```

3. **Report Issues:**
   - GitHub Issues: https://github.com/loayabdalslam/chatitcloud/issues
   - Include output from `chatit doctor`
   - Include OS, Node.js version, and error messages

---

## Frequently Asked Questions

**Q: Can I install multiple versions simultaneously?**
A: Use NVM (Node Version Manager) or Bun's built-in version management.

**Q: How do I update Chatit?**
```bash
npm update -g chatit
# Or reinstall
curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash
```

**Q: Do I need internet for every use?**
A: Only for initial API calls. Local functionality works offline.

**Q: Can I use Chatit in CI/CD?**
A: Yes, set environment variables and run in non-interactive mode.

**Q: How do I contribute?**
A: See CONTRIBUTING.md for development setup.

---

For more help, visit: https://github.com/loayabdalslam/chatitcloud/issues
