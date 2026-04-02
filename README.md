# Chatit.Cloud (CC) - Terminal AI Coding Assistant

**An advanced agentic AI coding assistant for the terminal with support for multiple AI providers, intelligent code analysis, and seamless GitHub integration.**

[![Node.js Compatible](https://img.shields.io/badge/Node.js-%3E%3D18.0.0-339933?style=flat-square&logo=node.js)](https://nodejs.org/)
[![Bun Compatible](https://img.shields.io/badge/Bun-%3E%3D1.0.0-000000?style=flat-square&logo=bun)](https://bun.sh/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.6-3178c6?style=flat-square&logo=typescript)](https://www.typescriptlang.org/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](#license)

---

## Overview

**Chatit.Cloud (CC)** is a powerful terminal-based AI coding assistant designed to augment your development workflow. It provides intelligent code analysis, real-time assistance, and seamless integration with GitHub, all accessible directly from your terminal.

### Key Features

- 🤖 **Multi-Provider AI Support** - Works with Claude, OpenAI, and other AI providers
- 🔧 **Rich Command Set** - 100+ specialized commands for different coding tasks
- 📊 **Code Analysis** - Security reviews, performance analysis, and code optimization
- 🌿 **Git Integration** - Native GitHub support for commits, PRs, branches, and reviews
- 💰 **Cost Tracking** - Monitor and track API usage and costs
- 🔐 **Secure Authentication** - OAuth, MDM, and keychain support for secure credentials
- 🎨 **Beautiful TUI** - Terminal UI powered by React and Ink
- 🚀 **Fast & Efficient** - Built with Bun for optimal performance
- 🔌 **Extensible** - Plugin system with MCP (Model Context Protocol) support
- 🎯 **Context-Aware** - Intelligent context management for better responses

---

## Quick Start

### Installation

Choose one of the following installation methods:

#### Option 1: Fast Installation Script (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash
```

Or on Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.ps1 | iex
```

#### Option 2: Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/loayabdalslam/chatitcloud.git
   cd chatitcloud
   ```

2. **Install dependencies:**
   ```bash
   # Using Bun (recommended for better performance)
   bun install
   
   # Or using npm
   npm install
   ```

3. **Build the project:**
   ```bash
   bun run build
   # Or with npm
   npm run build
   ```

4. **Add to PATH:**
   ```bash
   # Install globally
   npm install -g .
   
   # Or create a symlink
   sudo ln -s $(pwd)/dist/chatit.js /usr/local/bin/chatit
   chmod +x dist/chatit.js
   ```

### First Run

After installation, initialize Chatit with:

```bash
chatit init
```

This will guide you through:
- API provider selection (Claude, OpenAI, etc.)
- API key configuration
- GitHub authentication setup
- Preferences and settings

---

## Core Commands

### Session & Configuration

| Command | Description |
|---------|-------------|
| `chatit init` | Initialize and configure Chatit |
| `chatit login` | Authenticate with your AI provider |
| `chatit logout` | Sign out and clear credentials |
| `chatit config` | View and modify settings |
| `chatit status` | Check system status and configuration |
| `chatit doctor` | Diagnose configuration and environment issues |

### Code Analysis & Review

| Command | Description |
|---------|-------------|
| `chatit review` | Review code for improvements and best practices |
| `chatit security-review` | Perform security-focused code analysis |
| `chatit brief` | Get a quick summary of code functionality |
| `chatit diff` | Analyze code changes with AI assistance |
| `chatit advisor [model]` | Set an advisor model for real-time guidance |
| `chatit insights` | Generate insights about your codebase |

### Git & GitHub Integration

| Command | Description |
|---------|-------------|
| `chatit commit` | Generate intelligent commit messages |
| `chatit commit-push-pr` | Commit, push, and create PR in one command |
| `chatit branch` | Create and manage Git branches intelligently |
| `chatit pr` | Create and manage pull requests |
| `chatit issue` | Create and manage GitHub issues |
| `chatit tag` | Create version tags with descriptions |

### Development Tools

| Command | Description |
|---------|-------------|
| `chatit plan` | Break down and plan development tasks |
| `chatit tasks` | Track and manage project tasks |
| `chatit bughunter` | Identify and analyze potential bugs |
| `chatit autofix-pr` | Automatically fix issues in pull requests |
| `chatit effort` | Estimate effort for tasks and features |
| `chatit performance` | Analyze performance bottlenecks |

### Context & Project Management

| Command | Description |
|---------|-------------|
| `chatit context` | Manage AI context and conversation history |
| `chatit add-dir` | Add directories to project context |
| `chatit memory` | Access and manage persistent memory |
| `chatit summary` | Generate project summaries |
| `chatit session` | Manage chat sessions |
| `chatit export` | Export conversations and sessions |

### Cost & Usage Tracking

| Command | Description |
|---------|-------------|
| `chatit cost` | View API usage and costs |
| `chatit usage` | Check resource usage statistics |
| `chatit rate-limit-options` | Configure rate limiting |
| `chatit reset-limits` | Reset usage limits |

### Utility Commands

| Command | Description |
|---------|-------------|
| `chatit help` | Display command help |
| `chatit version` | Show version information |
| `chatit update` | Check for and install updates |
| `chatit clear` | Clear terminal and history |
| `chatit theme` | Customize terminal theme |
| `chatit vim` | Toggle Vim keybindings |

---

## Configuration

### Environment Variables

Key environment variables for Chatit configuration:

```bash
# AI Provider Configuration
CLAUDE_API_KEY              # Anthropic Claude API key
OPENAI_API_KEY              # OpenAI API key
OPENCODE_API_KEY            # OpenCode AI API key

# GitHub Configuration
GITHUB_TOKEN                # GitHub personal access token
GITHUB_OAUTH_TOKEN          # GitHub OAuth token

# Application Settings
CC_HOME                     # Chatit home directory (~/.chatit by default)
CC_DEBUG                    # Enable debug mode
CC_PROFILE                  # Enable performance profiling
CC_REMOTE_SESSION_URL       # Custom remote session URL
```

### Configuration Files

Chatit stores configuration in:

- **Linux/macOS:** `~/.chatit/`
- **Windows:** `%APPDATA%\.chatit\`

Key configuration files:
- `settings.json` - User preferences
- `sessions.db` - Chat session history
- `credentials.json` - Stored API keys (encrypted)

---

## Architecture

### Project Structure

```
┌─ src/
│  ├─ commands/              # 100+ command implementations
│  ├─ components/            # React components for TUI
│  ├─ services/              # Business logic (git, API, etc.)
│  ├─ bridge/                # Remote session management
│  ├─ tools/                 # Tool definitions and handlers
│  ├─ plugins/               # Plugin system
│  ├─ hooks/                 # React hooks
│  ├─ utils/                 # Utility functions
│  ├─ schemas/               # Zod validation schemas
│  ├─ types/                 # TypeScript type definitions
│  └─ main.tsx               # Application entry point
│
├─ dist/                     # Compiled output
├─ package.json              # Dependencies and scripts
└─ README.md                 # This file
```

### Technology Stack

- **Runtime:** Node.js 18+ or Bun 1.0+
- **Language:** TypeScript 5.6
- **UI Framework:** React 19 with Ink
- **CLI Framework:** Commander.js
- **Validation:** Zod
- **AI Providers:** OpenAI SDK, Anthropic SDK
- **Styling:** Chalk, Ink

---

## Development

### Prerequisites

- Node.js >= 18.0.0 or Bun >= 1.0.0
- TypeScript 5.6
- Git 2.0+

### Setup

```bash
# Clone repository
git clone https://github.com/loayabdalslam/chatitcloud.git
cd chatitcloud

# Install dependencies
bun install

# Start development mode
bun run dev

# Run linting
bun run lint

# Format code
bun run format

# Run tests
bun run test
```

### Build

```bash
# Build for production
bun run build

# Output is in dist/chatit.js
```

### Scripts

| Script | Purpose |
|--------|---------|
| `dev` | Start development mode with hot reload |
| `build` | Build production bundle |
| `start` | Run built application |
| `test` | Run test suite |
| `lint` | Check code with Biome linter |
| `format` | Format code with Biome formatter |

---

## Advanced Usage

### Custom AI Models

Configure different AI models for different tasks:

```bash
# Set main model
chatit /model opus

# Set advisor model
chatit /advisor sonnet

# List available models
chatit /model list
```

### Plugin Development

Extend Chatit with custom plugins:

```bash
# Install a plugin
chatit plugin install <plugin-url>

# List installed plugins
chatit plugin list

# Develop a plugin
# See plugins/ directory for examples
```

### Remote Sessions

Use Chatit with remote development environments:

```bash
# Create remote session
chatit remote-setup

# List remote sessions
chatit session list

# Connect to remote environment
chatit teleport <session-id>
```

### Context Management

Optimize AI context for better responses:

```bash
# Add directory context
chatit add-dir src/

# View current context
chatit context show

# Clear context
chatit context clear

# Export context
chatit context export
```

---

## Troubleshooting

### Common Issues

**Issue: "API key not found"**
```bash
# Re-authenticate
chatit login
# Or set environment variable
export CLAUDE_API_KEY="your-key-here"
```

**Issue: "GitHub authentication failed"**
```bash
# Re-authorize GitHub
chatit logout
chatit login
# Or manually set token
export GITHUB_TOKEN="your-token-here"
```

**Issue: "Command not found after installation"**
```bash
# Verify installation
which chatit

# Reinstall globally
npm install -g .

# Or add to PATH manually
export PATH="$PATH:$(pwd)/dist"
```

**Issue: Slow performance**
```bash
# Use Bun instead of npm for better performance
curl -fsSL https://bun.sh/install | bash
bun install
bun run build
```

### Diagnostic Commands

```bash
# Check system status
chatit doctor

# View debug information
chatit debug-tool-call

# Check API connectivity
chatit status

# View logs
chatit --debug

# Profile startup performance
CC_PROFILE=1 chatit init
```

---

## API Integration

### Supported Providers

- **Anthropic Claude** - Primary support for Claude Opus, Sonnet, Haiku models
- **OpenAI** - Support for GPT-4, GPT-4 Turbo, GPT-3.5 Turbo
- **Custom Providers** - Via OpenCode AI SDK

### Rate Limiting

```bash
# Configure rate limits
chatit rate-limit-options

# View current usage
chatit cost

# Reset usage counters
chatit reset-limits
```

---

## Security

### Best Practices

1. **Never commit API keys** - Use environment variables
2. **Use encrypted credentials** - Chatit encrypts stored API keys
3. **Enable trusted device verification** - For added security
4. **Keep updated** - Run `chatit update` regularly
5. **Review permissions** - Check GitHub app permissions before authorizing

### Data Privacy

- Chat history stored locally in encrypted database
- No telemetry without opt-in
- Credentials stored securely using system keychain
- MDM (Mobile Device Management) support for enterprise

---

## Performance

### Optimization Tips

1. **Use Bun runtime** - 2-3x faster than Node.js
2. **Minimize context** - Include only relevant files in context
3. **Use session caching** - Reuse sessions to avoid re-authentication
4. **Enable model-specific optimizations** - Use `advisor` for real-time feedback
5. **Monitor costs** - Run `chatit cost` to track expensive operations

### Profiles

View startup performance:

```bash
CC_PROFILE=1 chatit init
```

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes and test thoroughly
4. Run linter (`bun run lint`) and formatter (`bun run format`)
5. Commit with clear messages
6. Push to your fork and create a Pull Request

### Code Standards

- TypeScript with strict mode
- Functional React components with hooks
- Comprehensive error handling
- JSDoc comments for public APIs
- Tests for new features

---

## Documentation

- [Installation Guide](docs/installation.md)
- [Configuration Reference](docs/config.md)
- [Command Reference](docs/commands.md)
- [Plugin Development](docs/plugins.md)
- [API Reference](docs/api.md)
- [Troubleshooting Guide](docs/troubleshooting.md)

---

## Roadmap

### Upcoming Features

- 🔮 Vision model support for screenshot analysis
- 📱 Mobile app integration
- 🌐 Web UI dashboard
- 🔄 Real-time collaboration features
- 📈 Advanced analytics and insights
- 🎓 Built-in tutorials and learning paths

---

## FAQ

**Q: Do I need to pay to use Chatit?**
A: Chatit is free, but requires API keys from AI providers (Claude, OpenAI, etc.) which may have associated costs.

**Q: Can I use multiple AI providers?**
A: Yes, configure different models with `/model` command and use `/advisor` for secondary models.

**Q: Is my code sent to external servers?**
A: Only the code you explicitly share is sent to AI providers. Local configuration and history are stored encrypted locally.

**Q: Can I use Chatit in CI/CD pipelines?**
A: Yes, Chatit supports automated workflows via environment variables and non-interactive mode.

**Q: How do I report bugs?**
A: Please open an issue on [GitHub Issues](https://github.com/loayabdalslam/chatitcloud/issues).

---

## Support

- 📚 **Documentation:** [docs/](docs/)
- 🐛 **Bug Reports:** [GitHub Issues](https://github.com/loayabdalslam/chatitcloud/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/loayabdalslam/chatitcloud/discussions)
- 📧 **Email Support:** support@chatit.cloud

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

Built with modern web technologies and inspired by the best practices of terminal-first development tools.

- Powered by [Anthropic Claude](https://www.anthropic.com/)
- Built with [React](https://react.dev/) and [Ink](https://github.com/vadimdemedes/ink)
- CLI framework: [Commander.js](https://commander.js.org/)
- Runtime: [Bun](https://bun.sh/) / [Node.js](https://nodejs.org/)

---

### Made with ❤️ by the Chatit.Cloud Team

**Last Updated:** April 2, 2026  
**Version:** 0.1.0

For the latest updates, visit [https://github.com/loayabdalslam/chatitcloud](https://github.com/loayabdalslam/chatitcloud)
