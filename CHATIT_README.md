# CC - AGENTIC CHATIT.CLOUD CODE ASSISTANT

**Chatit** is a fork of Claude Code — a terminal-based AI coding assistant that helps you edit files, run commands, search codebases, and manage git workflows.

## What's Different in Chatit

✨ **Rebranded** — From "Claude Code" to "CC - Agentic Chatit"  
🎨 **New Theme** — Added "white" theme with Chatit blue accent (rgb(0,120,212))  
🔌 **Multi-Provider Support** — Use Anthropic, OpenCode, or OpenRouter free tier models  
💰 **Free Tier Models** — Gemini Flash, Mistral, Llama, Qwen without API keys  
📦 **Simplified** — Cleaner config, added package.json, ready to build and run

---

## Quick Start

### Prerequisites
- **Node.js** 18+ or **Bun** runtime
- An API key for one of the supported providers (or use free tier models)

### Installation

```bash
# Clone the repository
git clone <chatit-repo>
cd chatit

# Install dependencies (with Bun)
bun install

# Or with npm
npm install
```

### Run

```bash
# Using Bun
bun run src/main.tsx

# Or with Node.js
npm run dev
```

---

## Configuration

First run will prompt you to:
1. **Choose a provider** — Anthropic, OpenCode, OpenRouter, or skip
2. **Pick a theme** — dark, light, white, or ANSI variants
3. **Configure authentication** — API key, OAuth, or environment variables

### Provider Options

#### Anthropic (Default)
Use Claude models with an Anthropic API key.
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
chatit "analyze this code"
```

#### OpenRouter (Free Tier)
Use free models like Gemini Flash, Mistral, Llama.
```bash
# No API key needed for free tier
chatit --provider openrouter
```

#### OpenCode (Local)
Connect to a local OpenCode server running 75+ provider integrations.
```bash
# Start OpenCode server separately
opencode server
# Then connect
chatit --provider opencode
```

---

## Commands

### Core Commands
- `/model` — Switch AI model
- `/theme` — Change color theme
- `/provider` — Switch AI provider
- `/commit` — Create a git commit
- `/memory` — Manage persistent memory
- `/config` — Edit settings

### Tools
Available tools for the AI:
- **Read/Write/Edit** — File operations
- **Bash** — Shell command execution
- **Glob/Grep** — Code search
- **WebFetch** — Fetch web content
- **Agent** — Spawn sub-agents for parallel tasks

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

## Free Tier Models (OpenRouter)

Chatit includes built-in support for free tier models without requiring an API key:

- **Gemini Flash 1.5** — Google's fast model (free quota)
- **Mistral 7B** — Open-source instruction model (free)
- **Llama 3 8B** — Meta's open-source model (free)
- **Qwen 2 7B** — Alibaba's high-performance model (free)

To use free models:
```bash
chatit --provider openrouter
> /model
> Choose: "Gemini Flash 1.5 (Google — free)"
```

---

## Environment Variables

```bash
# Provider selection
CHATIT_PROVIDER=openrouter|opencode|anthropic

# Anthropic API key
ANTHROPIC_API_KEY=sk-ant-...

# OpenRouter API key (optional for free tier)
OPENROUTER_API_KEY=...

# OpenCode server URL
OPENCODE_ENDPOINT=http://localhost:4096

# Additional settings
ANTHROPIC_MODEL=claude-opus-4-6
DEBUG=1  # Enable debug logging
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
