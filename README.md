# CC - AGENTIC CHATIT.CLOUD CODE ASSISTANT

**Chatit** is a fork of Claude Code — a terminal-based AI coding assistant that helps you edit files, run commands, search codebases, and manage git workflows.

---

## ⚡ ONE-COMMAND INSTALLATION

### Linux / macOS
```bash
git clone https://github.com/loayabdalslam/chatitcloud.git ~/chatit && cd ~/chatit && chmod +x install.sh && ./install.sh
```

### Windows (PowerShell - Run as Administrator)
```powershell
git clone https://github.com/loayabdalslam/chatitcloud.git $env:USERPROFILE\chatit; cd $env:USERPROFILE\chatit; .\install.bat
```

**⏱️ Takes ~2-3 minutes**  
**✅ Automatically adds to PATH**  
**✅ Sets up all configuration**  
**✅ Ready to use immediately**

---

## Quick Usage After Installation

```bash
# First run (interactive setup)
chatit

# Ask questions
chatit "Help me with this code"

# Change theme
chatit /theme

# Switch provider
chatit /provider

# View all commands
chatit /help
```

---

## What's Different in Chatit

✨ **Rebranded** — From "Claude Code" to "CC - Agentic Chatit"  
🎨 **New Theme** — Added "white" theme with Chatit blue accent (rgb(0,120,212))  
🔌 **Multi-Provider Support** — Use Anthropic, OpenCode, or OpenRouter free tier models  
💰 **Free Tier Models** — Gemini Flash, Mistral, Llama, Qwen without API keys  
📦 **Simplified** — One-command install, automatic PATH setup  

---

## Prerequisites

- **Node.js** 18+ or **Bun** runtime
- **Git** (for cloning)
- Administrator access (Windows) or sudo if installing globally (Linux/macOS)
- An API key for one of the supported providers (or use free tier models)

**Don't have Node.js?**
- Download: https://nodejs.org (18+)
- Or install Bun: https://bun.sh (faster alternative)

---

## Repository Link

📍 **GitHub**: https://github.com/loayabdalslam/chatitcloud.git 
📍 **Issues**: https://github.com/loayabdalslam/chatitcloud/issues  
📍 **Discussions**: https://github.com/loayabdalslam/chatitcloud/discussions

---

## Installation Options

### Option 1: Automated Installation (Recommended)

**Linux/macOS:**
```bash
git clone https://github.com/loayabdalslam/chatitcloud.git ~/chatit && \
cd ~/chatit && \
chmod +x install.sh && \
./install.sh
```

**Windows:**
```powershell
git clone https://github.com/loayabdalslam/chatitcloud.git $env:USERPROFILE\chatit; `
cd $env:USERPROFILE\chatit; `
.\install.bat
```

**What the installer does:**
- ✅ Checks Node.js 18+ or Bun
- ✅ Installs dependencies
- ✅ Creates `~/.claude/` config directory
- ✅ **Adds to PATH automatically**
- ✅ Sets up global `chatit` command
- ✅ Optionally configures API provider

### Option 2: Manual Installation

```bash
# 1. Clone
git clone https://github.com/loayabdalslam/chatitcloud.git
cd chatit

# 2. Install dependencies
bun install
# OR
npm install

# 3. Run
bun run src/main.tsx "Your prompt"
```

---

## Verify Installation

After installation, verify everything works:

```bash
# Check if chatit command is available
chatit --version

# Run first time setup
chatit

# Test with a simple prompt
chatit "Hello, what can you do?"
```

---

## Configure Your Machine

### Add to PATH (If Not Already Done)

**Linux/macOS:**
```bash
# Check if already in PATH
echo $PATH | grep .local/bin

# If not, add to ~/.bashrc or ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Windows:**
The installer automatically adds `%USERPROFILE%\.chatit` to PATH.  
Restart PowerShell or CMD after installation.

### Set API Key

```bash
# Anthropic (requires API key)
export ANTHROPIC_API_KEY="sk-ant-..."

# Or use interactive login
chatit /login

# Verify it works
chatit "Hello!"
```

---

## First Run

---

## Provider Configuration

First run will prompt you to choose a provider. You can also reconfigure anytime:

```bash
chatit /provider
```

### Anthropic (Default)

**Setup:**
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
chatit "analyze this code"
```

**Or interactive login:**
```bash
chatit /login
```

**Available models:**
- `claude-opus-4-6` (most capable)
- `claude-sonnet-4-6` (balanced)
- `claude-haiku-4-5` (fast)

**Pricing:** Usage-based ($20 per million input tokens, $60 per million output tokens)

---

### OpenRouter (Free Tier - No API Key)

**Setup (completely free):**
```bash
chatit --provider openrouter
chatit /model  # Select free model
```

**Free models available:**
- **Gemini Flash 1.5** (Google - fastest)
- **Mistral 7B** (Mistral - capable)
- **Llama 3 8B** (Meta - open source)
- **Qwen 2 7B** (Alibaba - high performance)

**Cost:** Completely FREE for free tier models  
**Get started in:** < 1 minute

---

### OpenCode (Local Server - 75+ Providers)

**Install and setup:**
```bash
# Install OpenCode globally
npm install -g opencode

# Start server
opencode server

# In another terminal, configure Chatit
export OPENCODE_ENDPOINT="http://localhost:4096"
chatit --provider opencode
```

**Benefits:**
- Support for 75+ LLM providers
- Run completely locally (no internet required)
- Privacy-friendly (data stays local)
- Free with local models

---

## Environment Variables

```bash
# Anthropic
export ANTHROPIC_API_KEY="sk-ant-..."
export ANTHROPIC_MODEL="claude-opus-4-6"

# OpenRouter (optional)
export OPENROUTER_API_KEY="..."

# Provider selection
export CHATIT_PROVIDER="anthropic|openrouter|opencode"

# OpenCode server
export OPENCODE_ENDPOINT="http://localhost:4096"

# Behavior
export DEBUG=1
export CHATIT_AUTOACCEPT=1
```

**Make permanent (add to `~/.bashrc`, `~/.zshrc`, or `~/.profile`):**
```bash
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
source ~/.bashrc
```

---

## Common Commands

```bash
chatit /help              # Show all commands
chatit /theme             # Change color theme
chatit /model             # Switch AI model
chatit /provider          # Switch AI provider
chatit /config            # View/edit settings
chatit /commit            # AI-assisted git commit
chatit /diff              # Review recent changes
chatit /memory            # Manage persistent memory
chatit /cost              # Check token usage/costs
chatit /login             # Authenticate (OAuth or API key)
chatit /doctor            # Diagnose issues
```

---

## Troubleshooting

### "chatit: command not found"

**Solution 1: Add to PATH**
```bash
# Check if in PATH
echo $PATH | grep ".local/bin"

# If not, add it
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Restart terminal and try again
chatit --version
```

**Solution 2: Use full path**
```bash
~/.chatit/chatit "Your prompt"
# or
~/.local/bin/chatit "Your prompt"
```

### "Node.js 18+ required"

**Install Node.js:**
```bash
# Visit https://nodejs.org and download 18+
# Or use a package manager:

# macOS (with Homebrew)
brew install node

# Ubuntu/Debian
sudo apt update
sudo apt install nodejs npm

# Windows (with Chocolatey)
choco install nodejs
```

**Or install Bun (faster alternative):**
```bash
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

# Test connection
chatit "Hello, can you see me?"
```

### "npm install fails"

```bash
# Clear npm cache
npm cache clean --force

# Update npm
npm install -g npm@latest

# Try again
npm install
```

### "Out of context / Too many tokens"

```bash
# Compress context
chatit /compact

# Or start fresh conversation
chatit --no-history "New topic"
```

### Windows PATH Issues

If `chatit` is not found in PowerShell after installation:

```powershell
# Restart PowerShell or cmd as Administrator
# Then try:
chatit --version

# If still not found, manually add to PATH:
$env:Path += ";$env:USERPROFILE\.chatit"
chatit --version
```

---

## Features & Tools

### AI Tools
- **Read/Write/Edit** — File operations
- **Bash** — Shell command execution
- **Glob/Grep** — Code search
- **WebFetch** — Fetch web content
- **Agent** — Spawn sub-agents for parallel tasks

### Themes

| Theme | Style | Accent |
|-------|-------|--------|
| `dark` | Dark background | Orange |
| `light` | Light background | Orange |
| **white** | Pure white ⭐ NEW | **Chatit Blue** |
| `light-ansi` | Light ANSI only | ANSI colors |
| `dark-ansi` | Dark ANSI only | ANSI colors |
| `light-daltonized` | Color-blind friendly | Adjusted colors |
| `dark-daltonized` | Color-blind friendly | Adjusted colors |

Switch themes:
```bash
chatit /theme
```

---

## Themes

| Theme | Style | Accent |
|-------|-------|--------|
| `dark` | Dark background, light text | Orange |
| `light` | Light background, dark text | Orange |
| **white** | Pure white, black text | **Chatit Blue** |
| `light-ansi` | Light ANSI colors only | ANSI Red |
| `dark-ansi` | Dark ANSI colors only | ANSI Red |

Switch themes with `/theme` command:
```
chatit
> /theme
Choose the text style that looks best with your terminal:
  ○ Dark
  ○ Light
  ○ White (Chatit)
  ○ Light Daltonized
  ○ Dark Daltonized
  ○ Light ANSI
  ○ Dark ANSI
```

---

## Documentation

After installation, read these guides for detailed information:

| Document | Purpose | Read with |
|----------|---------|-----------|
| **QUICK_START.md** | Getting started quickly | `cat ~/.chatit/QUICK_START.md` |
| **INSTALLATION_GUIDE.md** | Detailed setup instructions | `cat ~/.chatit/INSTALLATION_GUIDE.md` |
| **COMMANDS_REFERENCE.md** | Complete command reference | `cat ~/.chatit/COMMANDS_REFERENCE.md` |
| **CHATIT_README.md** | Full user guide | `cat ~/.chatit/CHATIT_README.md` |
| **FILES_CREATED_SUMMARY.md** | What was created | `cat ~/.chatit/FILES_CREATED_SUMMARY.md` |

---

## Getting Help

### In-App Help
```bash
chatit /help              # Show all commands
chatit /doctor            # Diagnose installation issues
chatit --version          # Show version
```

### Enable Debug Mode
```bash
export DEBUG=1
chatit "Your prompt"      # Detailed logging
```

### Online Resources
- 📍 **GitHub**: https://github.com/yourusername/chatit
- 🐛 **Issues**: https://github.com/yourusername/chatit/issues
- 💡 **Discussions**: https://github.com/yourusername/chatit/discussions

---

## Configuration Files

Your configuration is stored in:

**Linux/macOS:**
```bash
~/.claude/              # Global config directory
~/.chatit/              # Installation directory
```

**Windows:**
```
%USERPROFILE%\.claude\
%USERPROFILE%\.chatit\
```

**Key files:**
```bash
~/.claude/settings.json    # Your preferences
~/.claude/config.json      # Global configuration
~/.claude/cache/           # Temporary caches
~/.claude/memory/          # Persistent memory
```

---

## Updating Chatit

```bash
# Navigate to installation
cd ~/.chatit

# Pull latest changes
git pull origin main

# Reinstall dependencies
bun install  # or: npm install

# Verify update
chatit --version
```

---

## Uninstalling

```bash
# Remove installation
rm -rf ~/.chatit

# Remove global command
sudo rm /usr/local/bin/chatit
# or
rm ~/.local/bin/chatit

# (Optional) Remove config files
rm -rf ~/.claude
```

---

## Usage Examples

### Ask for Code Review
```bash
chatit "Review this code for bugs and performance issues"
```

### Refactor Code
```bash
chatit "Refactor this function to be more readable"
```

### Write Tests
```bash
chatit "Write unit tests for this function"
```

### Pipe File Content
```bash
cat myfile.js | chatit "Explain what this code does"
```

### Interactive Session
```bash
chatit
> /theme
> white
> chatit "Analyze this codebase"
> /model
> /provider
> exit
```

### Git Operations
```bash
chatit /commit         # AI-assisted commit message
chatit /diff           # Review recent changes
```

---

## Project Structure

```
.
├── src/
│   ├── main.tsx                           # CLI entrypoint
│   ├── components/
│   │   ├── LogoV2/                        # Branding (Chatit logo)
│   │   ├── ProviderSelector.tsx           # NEW: Provider choice UI
│   │   ├── Onboarding.tsx                 # First-run setup flow
│   │   └── ModelPicker.tsx                # Model selection
│   ├── utils/
│   │   ├── theme.ts                       # Theme definitions (includes white)
│   │   ├── model/
│   │   │   ├── providers.ts               # Provider types
│   │   │   └── freeTierModels.ts          # NEW: Free model list
│   │   └── config.ts                      # Config schema
│   └── ...
├── package.json                           # NEW: Dependencies & scripts
└── README.md                              # This file
```

---

## Building

```bash
# Build with Bun
bun run build

# Output: dist/chatit.js
```

---

## Extending Chatit

### Add a New Provider
1. Update `APIProvider` type in `src/utils/model/providers.ts`
2. Add config fields in `src/utils/config.ts`
3. Update `ProviderSelector.tsx` with the new option
4. Implement API client in appropriate service module

### Add Custom Models
Edit `src/utils/model/freeTierModels.ts` or `src/utils/model/configs.ts`.

### Add a Custom Command
1. Create `src/commands/mycommand/index.ts`
2. Register in `src/commands.ts`
3. Add to command parser in `src/main.tsx`

---

## Credits & Team

### Chatit Team
- **Loaii Abdalslam** — Project Lead, Architecture & Core Development
- **Chatit Team** — UI/UX Design, Provider Integration, Documentation

### Key Contributions
- 🎨 White theme with Chatit blue accent
- 🔌 Multi-provider support (Anthropic, OpenCode, OpenRouter)
- 💰 Free tier models without API key requirement
- 📦 Simplified installation and configuration
- 🚀 Enhanced documentation and quick start guide

### Original Project

This is a fork of Claude Code source code that was leaked via npm source maps in March 2026. All original code is the property of [Anthropic](https://www.anthropic.com).

**Chatit** is a community fork adding multi-provider support, free tier models, and simplified configuration.

### Thanks to
- **Anthropic** — For creating Claude Code
- **Chaofan Shou** — For discovering the source leak
- **Open Source Community** — React, Ink, Commander.js, and all dependencies

---

## Support & Contributing

- 🐛 **Issues** — GitHub Issues
- 💡 **Ideas** — GitHub Discussions
- 🤝 **Pull Requests** — Contributions welcome!

---

## License

MIT — See LICENSE file
