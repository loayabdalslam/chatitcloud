# Chatit Installation & Usage Guide

**CC - AGENTIC CHATIT.CLOUD CODE ASSISTANT**

Complete guide to install and use Chatit on your local machine.

---

## Quick Install (One Command)

### macOS / Linux
```bash
git clone https://github.com/yourusername/chatit.git ~/chatit && cd ~/chatit && chmod +x install.sh && ./install.sh
```

### Windows (PowerShell)
```powershell
git clone https://github.com/yourusername/chatit.git $env:USERPROFILE\chatit; cd $env:USERPROFILE\chatit; .\install.bat
```

---

## Step-by-Step Installation

### Prerequisites
- **Node.js 18+** or **Bun** runtime
- **Git** (optional, for cloning)
- **npm** or **Bun** (comes with Node.js)

### Step 1: Clone Repository
```bash
# macOS/Linux
git clone https://github.com/yourusername/chatit.git
cd chatit

# Or download as ZIP and extract
```

### Step 2: Run Installer
```bash
# macOS/Linux
chmod +x install.sh
./install.sh

# Windows (PowerShell, run as Admin)
.\install.bat
```

The installer will:
- ✅ Check Node.js/Bun installation
- ✅ Install npm dependencies
- ✅ Create config directories
- ✅ Create global `chatit` command
- ✅ Optionally set up API provider

### Step 3: Verify Installation
```bash
chatit --version
chatit /help
```

---

## Installation Scripts

### install.sh (macOS/Linux)

**Features:**
- Checks Node.js 18+ or Bun
- Installs dependencies
- Creates ~/.claude/ config directory
- Creates ~/.chatit/ installation directory
- Sets up /usr/local/bin/chatit or ~/.local/bin/chatit
- Interactive provider setup
- Creates startup scripts

**Usage:**
```bash
chmod +x install.sh
./install.sh

# Options
./install.sh --help
./install.sh --provider anthropic
./install.sh --provider openrouter
./install.sh --provider opencode
```

### install.bat (Windows)

**Features:**
- Checks Node.js installation
- Installs with npm
- Creates ~/.claude/ and ~/.chatit/ directories
- Creates chatit.bat wrapper
- Adds to Windows PATH
- Interactive provider setup
- Colored output

**Usage:**
```cmd
install.bat

# Then follow prompts
```

### Manual Installation

```bash
# 1. Clone
git clone https://github.com/yourusername/chatit.git
cd chatit

# 2. Install dependencies
bun install
# OR
npm install

# 3. Create directories
mkdir -p ~/.claude
mkdir -p ~/.chatit

# 4. Copy files
cp -r . ~/.chatit/

# 5. Create executable (macOS/Linux)
cat > ~/.local/bin/chatit << EOF
#!/bin/bash
cd ~/.chatit && bun run src/main.tsx "\$@"
EOF
chmod +x ~/.local/bin/chatit

# 6. Add to PATH (if not already)
export PATH="$HOME/.local/bin:$PATH"
```

---

## First Run

### Interactive Mode
```bash
chatit
```

First launch will prompt:
1. **Theme** — Choose color scheme (white, dark, light, etc.)
2. **Provider** — Select API provider (Anthropic, OpenRouter, OpenCode, skip)
3. **Authentication** — API key or OAuth login

### Direct Command
```bash
chatit "Your prompt here"
```

### Set Provider Env Vars
```bash
# Anthropic
export ANTHROPIC_API_KEY="sk-ant-..."
chatit "Your prompt"

# OpenRouter (free tier - no key needed)
chatit --provider openrouter

# OpenCode (local server)
export OPENCODE_ENDPOINT="http://localhost:4096"
chatit --provider opencode
```

---

## Usage Commands

### Basic Prompts
```bash
# Ask a question
chatit "What does this code do?"

# Request refactoring
chatit "Refactor this for readability"

# Pipe file content
cat myfile.js | chatit "Add error handling"

# Multi-line input
chatit << EOF
Analyze this code:
function foo() { }
EOF
```

### Interactive Session
```bash
# Start session
chatit

# Type prompts:
> /theme
> /model
> /provider
> /help
> exit
```

### In-Session Commands
```
/help          - Show all commands
/theme         - Change color theme
/model         - Switch AI model
/provider      - Switch provider
/config        - View/edit settings
/commit        - AI-assisted git commit
/diff          - Review changes
/cost          - Check token usage
/memory        - Manage persistent memory
/doctor        - Diagnose issues
/login         - Authenticate
/logout        - Sign out
```

---

## Configuration

### Location
- **macOS/Linux**: `~/.claude/` and `~/.chatit/`
- **Windows**: `%USERPROFILE%\.claude\` and `%USERPROFILE%\.chatit\`

### Files
- **settings.json** — User preferences (theme, model, provider)
- **config.json** — Global configuration and state
- **cache/** — Temporary caches
- **memory/** — Persistent memory storage

### Edit Configuration
```bash
# View settings
cat ~/.claude/settings.json

# Edit with text editor
nano ~/.claude/settings.json

# Or use Chatit UI
chatit /config
```

### Example settings.json
```json
{
  "theme": "white",
  "model": "claude-opus-4-6",
  "provider": "anthropic",
  "syntaxHighlighting": true,
  "apiKeyHelper": null
}
```

---

## Provider Setup

### Anthropic (Default)
```bash
# Set API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Or use login
chatit /login

# Models available
chatit /model
```

**Pricing:** Usage-based billing
**Setup Time:** < 1 minute

### OpenRouter (Free Tier)
```bash
# No key needed for free models
chatit --provider openrouter

# Optional: Set key for higher limits
export OPENROUTER_API_KEY="..."
```

**Free Models:**
- Gemini Flash 1.5 (Google)
- Mistral 7B (Mistral)
- Llama 3 8B (Meta)
- Qwen 2 7B (Alibaba)

**Pricing:** Free tier available  
**Setup Time:** < 1 minute

### OpenCode (Local)
```bash
# Install OpenCode
npm install -g opencode

# Start server
opencode server

# Configure endpoint
export OPENCODE_ENDPOINT="http://localhost:4096"

# Use with Chatit
chatit --provider opencode
```

**Benefits:** 75+ providers, local, privacy-friendly  
**Pricing:** Free for local models  
**Setup Time:** 5-10 minutes

---

## Environment Variables

```bash
# API Keys
export ANTHROPIC_API_KEY="..."
export OPENROUTER_API_KEY="..."

# Provider
export CHATIT_PROVIDER="anthropic|openrouter|opencode"
export OPENCODE_ENDPOINT="http://localhost:4096"

# Model
export ANTHROPIC_MODEL="claude-opus-4-6"

# Behavior
export DEBUG=1                      # Debug mode
export CHATIT_AUTOACCEPT=1         # Auto-accept suggestions
export CHATIT_SIMPLE_MODE=1        # Simplified UI
```

**Make Permanent:**
```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
source ~/.bashrc
```

---

## Troubleshooting

### "Command not found: chatit"
```bash
# Check PATH
echo $PATH | grep ".local/bin"

# If not found, add to shell profile:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Or use full path:
~/.chatit/chatit "Your prompt"
```

### "Node.js 18+ required"
```bash
# Check version
node --version

# Install/upgrade Node
# Visit: https://nodejs.org (select 18+)
# Or use nvm: nvm install node

# Or install Bun (faster):
curl -fsSL https://bun.sh/install | bash
```

### "API key not working"
```bash
# Verify key is set
echo $ANTHROPIC_API_KEY

# Check it's valid
chatit /doctor

# Re-authenticate
chatit /login
```

### "Out of memory/context"
```bash
# Compact context
chatit /compact

# Or start fresh
chatit --no-history "New conversation"
```

---

## Updating Chatit

```bash
# Pull latest changes
cd ~/.chatit
git pull origin main

# Reinstall dependencies
bun install  # or: npm install

# Verify
chatit --version
```

---

## Uninstalling

```bash
# macOS/Linux
rm -rf ~/.chatit
rm /usr/local/bin/chatit  # or ~/.local/bin/chatit
# Keep config: rm -rf ~/.claude

# Windows
rmdir /S %USERPROFILE%\.chatit
del %USERPROFILE%\.local\bin\chatit.bat
# Keep config: rmdir /S %USERPROFILE%\.claude
```

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| npm install fails | Update Node.js, try `npm cache clean --force` |
| Command not found | Add ~/.local/bin to PATH |
| API key rejected | Check key is valid, try `/login` |
| Theme looks wrong | Update terminal color support, try different theme |
| Slow performance | Use `/compact`, switch to faster model |
| Out of context | Use `/compact` or start new session |

---

## Getting Help

```bash
# In-app help
chatit /help

# View documentation
cat ~/.chatit/CHATIT_README.md
cat ~/.chatit/QUICK_START.md
cat ~/.chatit/COMMANDS_REFERENCE.md

# Run diagnostics
chatit /doctor

# Enable debug mode
export DEBUG=1
chatit "Your prompt"
```

---

## Next Steps

1. ✅ Install with: `./install.sh`
2. ✅ Run first time: `chatit`
3. ✅ Configure provider: `/provider`
4. ✅ Pick theme: `/theme`
5. ✅ Start using: `chatit "Your prompt"`

---

## Support

- **Documentation**: `~/.chatit/CHATIT_README.md`
- **Quick Start**: `~/.chatit/QUICK_START.md`
- **Commands**: `~/.chatit/COMMANDS_REFERENCE.md`
- **Issues**: GitHub Issues
- **Discussions**: GitHub Discussions
- **Contributing**: Pull Requests welcome

---

**Welcome to Chatit! Happy coding! 🚀**

For the latest information, visit: https://github.com/yourusername/chatit
