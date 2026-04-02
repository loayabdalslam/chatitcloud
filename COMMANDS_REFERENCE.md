# Chatit Commands Reference

Complete guide to all Chatit commands and their usage.

---

## Installation & Setup

### Initial Installation

**macOS/Linux:**
```bash
git clone https://github.com/yourusername/chatit.git ~/chatit
cd ~/chatit
chmod +x install.sh
./install.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/yourusername/chatit.git $env:USERPROFILE\chatit
cd $env:USERPROFILE\chatit
.\install.bat
```

**Manual Installation:**
```bash
# Clone
git clone https://github.com/yourusername/chatit.git
cd chatit

# Install dependencies
bun install  # or: npm install

# Run directly
bun run src/main.tsx "Your prompt"
```

---

## Usage Patterns

### Basic Prompts
```bash
# Ask a simple question
chatit "What does this code do?"

# Request an action
chatit "Refactor this function for readability"

# Multi-line with piped input
cat myfile.js | chatit "Add error handling to this code"

# With multiple files
chatit "Compare these two implementations" < file1.js < file2.js
```

### Interactive Mode
```bash
# Start interactive session
chatit

# Then type prompts directly:
> Analyze this code for bugs
> /theme
> /model
> exit
```

### Direct Commands
```bash
# View help
chatit /help

# Change theme
chatit /theme

# Switch model
chatit /model

# Switch provider
chatit /provider

# View/edit configuration
chatit /config

# Check costs
chatit /cost

# View memory
chatit /memory

# Create a git commit
chatit /commit

# Review code diff
chatit /diff

# View recent activity
chatit /resume
```

---

## Slash Commands (In-Session)

Run these commands during a Chatit session by typing `/command`:

### Theme & Display

| Command | Description | Example |
|---------|-------------|---------|
| `/theme` | Change color theme | `/theme` then select White, Dark, Light, etc. |
| `/fast` | Toggle fast mode | `/fast` for faster responses (may be less thorough) |

### Models & Providers

| Command | Description | Example |
|---------|-------------|---------|
| `/model` | Switch AI model | `/model` then select Opus, Sonnet, Haiku, etc. |
| `/provider` | Switch provider | `/provider` then select Anthropic, OpenRouter, OpenCode |
| `/cost` | Check token usage/costs | `/cost` shows usage statistics |

### Project & Files

| Command | Description | Example |
|---------|-------------|---------|
| `/commit` | Create git commit | `/commit` for AI-assisted commit messages |
| `/diff` | Review recent changes | `/diff` shows what changed |
| `/context` | View context window | `/context` shows current token usage |
| `/memory` | Manage persistent memory | `/memory add "Important fact"` |
| `/resume` | Resume previous session | `/resume` loads last conversation |

### Configuration

| Command | Description | Example |
|---------|-------------|---------|
| `/config` | View/edit settings | `/config` opens settings editor |
| `/login` | Authenticate with Anthropic | `/login` for OAuth or API key |
| `/logout` | Sign out | `/logout` removes authentication |
| `/settings` | Show current settings | `/settings` displays config values |

### Help & Support

| Command | Description | Example |
|---------|-------------|---------|
| `/help` | Show help menu | `/help` displays all commands |
| `/doctor` | Diagnose issues | `/doctor` checks your setup |
| `/version` | Show version | `/version` or `--version` |

### Advanced

| Command | Description | Example |
|---------|-------------|---------|
| `/compact` | Compress context | `/compact` reduces conversation size |
| `/agent` | Spawn sub-agent | `/agent "Task description"` for parallel work |
| `/mcp` | Manage MCP servers | `/mcp list` shows connected servers |
| `/skills` | Manage skills | `/skills list` shows available skills |
| `/tasks` | Manage background tasks | `/tasks` shows running/completed tasks |

---

## Environment Variables

Set these to configure Chatit behavior:

```bash
# API Keys
export ANTHROPIC_API_KEY="sk-ant-..."       # Anthropic API key
export OPENROUTER_API_KEY="..."             # OpenRouter API key
export OPENAI_API_KEY="..."                 # OpenAI API key (if using OpenRouter)

# Provider Configuration
export CHATIT_PROVIDER="anthropic"          # Provider: anthropic|openrouter|opencode
export OPENCODE_ENDPOINT="http://..."       # OpenCode server URL
export ANTHROPIC_BASE_URL="..."             # Custom API endpoint

# Model Configuration
export ANTHROPIC_MODEL="claude-opus-4-6"    # Default model
export ANTHROPIC_MODEL_OVERRIDE="..."       # Override model

# Chatit Behavior
export DEBUG=1                              # Enable debug logging
export CHATIT_SIMPLE_MODE=1                 # Simplified UI
export CHATIT_AUTOACCEPT=1                  # Auto-accept changes
export CHATIT_NO_CONFIRMATION=1             # Skip confirmation prompts

# Display
export FORCE_COLOR=1                        # Force colored output
export NO_COLOR=1                           # Disable colors
export TERM="xterm-256color"               # Terminal type
```

**Set in shell profile (~/.bashrc, ~/.zshrc, ~/.profile):**
```bash
# Permanent configuration
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
source ~/.bashrc
```

---

## Common Workflows

### Code Review
```bash
chatit "Review this code for bugs and suggest improvements"
chatit "Check this for performance issues"
chatit "Suggest refactoring ideas for this function"
```

### Writing Code
```bash
chatit "Write a function that does X"
chatit "Generate tests for this code"
chatit "Add error handling to this function"
```

### Learning
```bash
chatit "Explain how this algorithm works"
chatit "What are the best practices for this pattern?"
chatit "Teach me about TypeScript generics"
```

### Debugging
```bash
chatit "Why is this code throwing an error?"
chatit "Debug this issue: [error message]"
chatit "My code is slow, how can I optimize it?"
```

### Git Operations
```bash
chatit /commit                    # Commit with AI-generated message
chatit /diff                      # Review recent changes
chatit "Write a detailed commit message for these changes"
```

### Project Analysis
```bash
chatit "Analyze this codebase structure"
chatit "What's the purpose of each file in this directory?"
chatit "Generate documentation for this module"
```

---

## Provider Configuration

### Anthropic (Default)

**Setup:**
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
chatit "Your prompt"
```

**Available Models:**
- `claude-opus-4-6` (most capable)
- `claude-sonnet-4-6` (balanced)
- `claude-haiku-4-5` (fast)

**Pricing:** Usage-based ($20/MTok input, $60/MTok output)

---

### OpenRouter (Free Tier)

**Setup:**
```bash
# No API key needed for free tier
chatit --provider openrouter

# Or with key for higher limits
export OPENROUTER_API_KEY="..."
chatit --provider openrouter
```

**Free Models (no API key required):**
- Gemini Flash 1.5 (Google)
- Mistral 7B (Mistral)
- Llama 3 8B (Meta)
- Qwen 2 7B (Alibaba)

**Switch model:**
```bash
chatit /model
# Select a free tier model
```

---

### OpenCode (Local Server)

**Prerequisites:**
```bash
# Install OpenCode
npm install -g opencode

# Start server
opencode server
```

**Setup in Chatit:**
```bash
export OPENCODE_ENDPOINT="http://localhost:4096"
chatit --provider opencode
```

**Benefits:**
- 75+ LLM providers supported
- Run locally (privacy-friendly)
- No internet required
- Free with local models

---

## Configuration Files

Config files are stored in `~/.claude/` directory:

### settings.json
User preferences:
```json
{
  "theme": "white",
  "model": "claude-opus-4-6",
  "provider": "anthropic",
  "syntaxHighlighting": true,
  "apiKeyHelper": null
}
```

**Edit with:**
```bash
nano ~/.claude/settings.json
chatit /config  # Edit with UI
```

### config.json
Global configuration and state:
```bash
cat ~/.claude/config.json
```

### cache/
Temporary caches:
```bash
ls -la ~/.claude/cache/
```

### memory/
Persistent memory storage:
```bash
ls -la ~/.claude/memory/
```

---

## Themes

Available themes:

```bash
chatit /theme
```

| Theme | Background | Text | Accent |
|-------|-----------|------|--------|
| dark | Dark gray | Light | Orange |
| light | Light gray | Dark | Orange |
| **white** | Pure white | Black | **Chatit Blue** |
| light-daltonized | Light | Dark | Color-blind friendly |
| dark-daltonized | Dark | Light | Color-blind friendly |
| light-ansi | Light | Dark | ANSI colors |
| dark-ansi | Dark | Light | ANSI colors |

**Select theme:**
```bash
chatit /theme
# Choose from menu
```

---

## Debugging & Troubleshooting

### Enable Debug Logging
```bash
export DEBUG=1
chatit "Your prompt"
```

### Run Diagnostics
```bash
chatit /doctor
```

Shows:
- Node.js/Bun version
- Python installation
- Git configuration
- API connectivity
- Storage permissions

### Check Configuration
```bash
# View current settings
chatit /config

# Show which provider is active
chatit /provider

# Check API key status
export DEBUG=1 && chatit /login
```

### Common Issues

**"Command not found: chatit"**
```bash
# Add to PATH
export PATH="$HOME/.local/bin:$PATH"
# Or use full path:
~/.chatit/chatit "Your prompt"
```

**"API key not working"**
```bash
# Verify key is set
echo $ANTHROPIC_API_KEY

# Test connection
chatit /doctor

# Re-authenticate
chatit /login
```

**"Out of context"**
```bash
# Compact context
chatit /compact

# Or start new session
chatit --no-history "New prompt"
```

---

## Advanced Usage

### Piping & Redirection

```bash
# Pipe file content
cat file.js | chatit "Analyze this code"

# Redirect output
chatit "Write a function" > output.txt

# Chain operations
chatit "Generate code" | tee code.js | chatit "Add tests"
```

### Multiple Files
```bash
# Analyze multiple files
chatit "Compare these implementations" < file1.js < file2.js

# Process directory
find src -name "*.ts" | xargs -I {} chatit "Review {}"
```

### Automation
```bash
#!/bin/bash
# Script to analyze all TypeScript files

for file in $(find . -name "*.ts"); do
    echo "Analyzing $file..."
    chatit "Review this TypeScript file" < "$file"
done
```

### Integration with Other Tools
```bash
# With git
git log --oneline | chatit "Summarize recent changes"

# With npm
npm audit | chatit "Explain these vulnerabilities"

# With linters
eslint . | chatit "Fix these linting errors"
```

---

## Keyboard Shortcuts

During interactive session:

| Key | Action |
|-----|--------|
| Enter | Send message |
| Ctrl+C | Exit |
| Ctrl+L | Clear screen |
| Up Arrow | Previous message |
| Down Arrow | Next message |
| Tab | Auto-complete |
| Ctrl+D | Exit (alternative) |

---

## Tips & Tricks

### Use `/fast` for Quick Responses
```bash
chatit
> /fast
> Summarize this article quickly
```

### Store Important Context in Memory
```bash
chatit /memory add "Our project uses TypeScript with strict mode"
chatit /memory add "We follow these code style rules: ..."
```

### Resume Previous Work
```bash
chatit /resume
# Loads your last conversation
```

### Check Cost Before Running
```bash
chatit /cost
# Shows current session costs
```

### Auto-Accept Changes
```bash
export CHATIT_AUTOACCEPT=1
chatit "Refactor this code"  # Auto-applies suggestions
```

---

## Getting Help

```bash
# View all commands
chatit /help

# Show this reference
chatit /help commands

# Get help on specific topic
chatit /help providers
chatit /help themes
chatit /help memory

# Open documentation
open ~/.chatit/CHATIT_README.md
open ~/.chatit/QUICK_START.md
```

---

## Version & Updates

```bash
# Check version
chatit --version

# Update to latest
cd ~/.chatit
git pull origin main
bun install  # or npm install

# Check for updates
chatit /doctor
```

---

**Happy coding with Chatit! 🚀**

For more info: `chatit /help`
