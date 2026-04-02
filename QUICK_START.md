# 🚀 Chatit Quick Start Guide

## Installation (One Command)

```bash
# Clone and install in one go
git clone https://github.com/yourusername/chatit.git ~/chatit && \
cd ~/chatit && \
chmod +x install.sh && \
./install.sh
```

**Or step-by-step:**

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/chatit.git
cd chatit

# 2. Make install script executable
chmod +x install.sh

# 3. Run the installer
./install.sh
```

---

## What the Installer Does

✅ Checks for Node.js 18+ or Bun  
✅ Installs dependencies (React, Ink, OpenCode SDK, etc.)  
✅ Creates `~/.claude/` config directory  
✅ Creates `~/.chatit/` installation directory  
✅ Sets up `chatit` command globally  
✅ Optionally configures API provider  

---

## Using Chatit on Your Local Machine

### 1. **First Run** (Interactive Setup)
```bash
chatit
```
You'll be prompted to:
- Choose a theme (dark, light, white, etc.)
- Select an AI provider (Anthropic, OpenRouter, OpenCode)
- Configure API key or endpoint

---

### 2. **Basic Usage**

#### Ask Chatit to help with code
```bash
chatit "Analyze this function for performance issues"
chatit "Write a unit test for this code"
chatit "Refactor this to be more readable"
```

#### Get help
```bash
chatit /help
```

#### View available commands
```bash
chatit /theme          # Change theme
chatit /model          # Switch AI model
chatit /provider       # Switch provider
chatit /config         # View/edit config
chatit /memory         # Manage memory
```

---

### 3. **Provider Configuration**

#### Using Anthropic (requires API key)
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
chatit "Your prompt here"
```

#### Using OpenRouter (free tier)
```bash
# No API key needed for free tier
chatit --provider openrouter "Your prompt"

# Or with API key for higher limits
export OPENROUTER_API_KEY="your-key"
chatit --provider openrouter
```

#### Using OpenCode (local server)
```bash
# Start OpenCode server first
opencode server

# Then in another terminal
export OPENCODE_ENDPOINT="http://localhost:4096"
chatit --provider opencode "Your prompt"
```

---

### 4. **Interactive Mode**

```bash
# Start interactive session
chatit

# Type your prompts directly
> Analyze this JavaScript code for bugs
> /theme
> /model
> /provider
> exit
```

---

### 5. **Configuration Files**

Your config is stored in `~/.claude/`:

```bash
# View settings
cat ~/.claude/settings.json

# View global config
cat ~/.claude/config.json

# Edit settings
nano ~/.claude/settings.json
```

**settings.json example:**
```json
{
  "theme": "white",
  "model": "claude-opus-4-6",
  "syntaxHighlighting": true,
  "provider": "openrouter",
  "apiKeyHelper": null
}
```

---

## Common Tasks

### 📝 Ask about a file
```bash
# From current directory
chatit "What does this code do? $(cat src/main.ts)"

# Or use stdin
cat src/main.ts | chatit "Explain this code"
```

### 🔍 Code analysis
```bash
chatit /grep "search pattern" src/

chatit "Find all TODO comments in this codebase"
```

### ✏️ Edit files
```bash
# Chatit will suggest changes
chatit "Add error handling to this function"

# Accept changes with /confirm
```

### 🚀 Run commands
```bash
chatit "Run npm test and tell me what fails"

chatit "Build the project and show me any warnings"
```

### 💾 Git operations
```bash
chatit /commit     # Interactive commit with AI help
chatit /diff       # Review recent changes
```

---

## Themes Available

```bash
chatit /theme

# Options:
# • Dark          (dark background, orange accent)
# • Light         (light background, orange accent)
# • White         (pure white, CHATIT BLUE accent) ⭐ NEW!
# • Light Daltonized (color-blind friendly)
# • Dark Daltonized
# • Light ANSI    (compatible terminals)
# • Dark ANSI
```

---

## Free Tier Models

Use these **without** an API key:

```bash
chatit --provider openrouter

# Select from:
# • Gemini Flash 1.5 (Google - fast)
# • Mistral 7B (Mistral - capable)
# • Llama 3 8B (Meta - open source)
# • Qwen 2 7B (Alibaba - high performance)
```

---

## Environment Variables

```bash
# API Keys
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENROUTER_API_KEY="..."

# Provider settings
export CHATIT_PROVIDER="openrouter"
export OPENCODE_ENDPOINT="http://localhost:4096"

# Chatit behavior
export ANTHROPIC_MODEL="claude-opus-4-6"
export DEBUG=1                    # Enable debug logging
export CHATIT_SIMPLE_MODE=1       # Reduced UI complexity
```

---

## Troubleshooting

### "Command not found: chatit"
```bash
# Check if ~/.local/bin is in PATH
echo $PATH | grep "\.local/bin"

# If not, add to ~/.bashrc or ~/.zshrc:
export PATH="$HOME/.local/bin:$PATH"

# Then reload:
source ~/.bashrc
```

### "Node.js 18+ required"
```bash
# Install Bun (recommended - faster):
curl -fsSL https://bun.sh/install | bash

# Or upgrade Node.js:
nvm install node  # If using nvm
# Or download from https://nodejs.org
```

### "No module named 'react'"
```bash
# Reinstall dependencies
cd ~/.chatit
bun install  # or npm install
```

### "API key not working"
```bash
# Verify API key is set
echo $ANTHROPIC_API_KEY

# Test connection
chatit "Hello"

# Check config
cat ~/.claude/config.json
```

---

## Updating Chatit

```bash
# Update to latest version
cd ~/chatit
git pull origin main

# Reinstall dependencies if needed
bun install  # or npm install

# Verify installation
chatit --version
```

---

## Uninstalling Chatit

```bash
# Remove installation
rm -rf ~/.chatit

# Remove global command
sudo rm /usr/local/bin/chatit
# Or if using ~/.local/bin:
rm ~/.local/bin/chatit

# Keep config files (optional)
# rm -rf ~/.claude
```

---

## Next Steps

1. ✅ Install with: `./install.sh`
2. ✅ Run first time: `chatit`
3. ✅ Pick a theme: `/theme`
4. ✅ Choose provider: `/provider`
5. ✅ Start using: `chatit "Your prompt"`

---

## Need Help?

```bash
# View all commands
chatit /help

# View full documentation
less ~/.chatit/CHATIT_README.md

# Check configuration
cat ~/.claude/settings.json

# Enable debug mode
export DEBUG=1
chatit "Your prompt"
```

---

## Support

- 📖 **Docs**: See `CHATIT_README.md` in installation directory
- 🐛 **Issues**: GitHub Issues
- 💡 **Ideas**: GitHub Discussions
- 🤝 **Contributing**: Pull Requests welcome!

---

**Happy coding with Chatit! 🚀**
