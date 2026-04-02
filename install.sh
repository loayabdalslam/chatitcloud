#!/bin/bash

# ============================================================================
# CC - AGENTIC CHATIT.CLOUD CODE ASSISTANT
# Installation & Setup Script
# ============================================================================

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="chatit"
INSTALL_DIR="${HOME}/.chatit"
CONFIG_DIR="${HOME}/.claude"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# Prerequisite Checks
# ============================================================================

check_prerequisites() {
    print_header "Checking Prerequisites"

    # Check for Node.js or Bun
    if command -v bun &> /dev/null; then
        BUN_VERSION=$(bun --version)
        print_success "Bun found: $BUN_VERSION"
        RUNTIME="bun"
    elif command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_MAJOR" -lt 18 ]; then
            print_error "Node.js 18+ required, found $NODE_VERSION"
            exit 1
        fi
        print_success "Node.js found: $NODE_VERSION"
        RUNTIME="node"
    else
        print_error "Neither Bun nor Node.js 18+ found!"
        echo ""
        echo "Install options:"
        echo "  • Bun: https://bun.sh (recommended)"
        echo "  • Node.js: https://nodejs.org (18+)"
        exit 1
    fi

    # Check for git
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        print_success "Git found: $GIT_VERSION"
    else
        print_warning "Git not found - will copy files instead of cloning"
    fi
}

# ============================================================================
# Installation
# ============================================================================

setup_installation_dir() {
    print_header "Setting Up Installation Directory"

    if [ -d "$INSTALL_DIR" ]; then
        print_info "Installation directory exists: $INSTALL_DIR"
        read -p "Do you want to update existing installation? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Updating existing installation..."
        else
            print_info "Keeping existing installation"
            return
        fi
    else
        mkdir -p "$INSTALL_DIR"
        print_success "Created installation directory: $INSTALL_DIR"
    fi
}

install_dependencies() {
    print_header "Installing Dependencies"

    cd "$INSTALL_DIR"

    if [ "$RUNTIME" = "bun" ]; then
        print_info "Using Bun for package management..."
        bun install
    else
        print_info "Using npm for package management..."
        npm install
    fi

    print_success "Dependencies installed successfully"
}

setup_config_directory() {
    print_header "Setting Up Configuration Directory"

    mkdir -p "$CONFIG_DIR"
    print_success "Created config directory: $CONFIG_DIR"

    # Create default settings if they don't exist
    if [ ! -f "$CONFIG_DIR/settings.json" ]; then
        cat > "$CONFIG_DIR/settings.json" << 'EOF'
{
  "theme": "white",
  "model": "claude-opus-4-6",
  "syntaxHighlighting": true,
  "apiKeyHelper": null
}
EOF
        print_success "Created default settings.json"
    else
        print_info "settings.json already exists"
    fi
}

create_executable() {
    print_header "Creating Executable"

    # Create chatit executable in /usr/local/bin
    if [ -w "/usr/local/bin" ]; then
        cat > /usr/local/bin/chatit << EOF
#!/bin/bash
cd "$INSTALL_DIR" && ${RUNTIME} run src/main.tsx "\$@"
EOF
        chmod +x /usr/local/bin/chatit
        print_success "Created /usr/local/bin/chatit executable"
    else
        # Alternative: create in ~/.local/bin
        mkdir -p "$HOME/.local/bin"
        cat > "$HOME/.local/bin/chatit" << EOF
#!/bin/bash
cd "$INSTALL_DIR" && ${RUNTIME} run src/main.tsx "\$@"
EOF
        chmod +x "$HOME/.local/bin/chatit"
        print_success "Created ~/.local/bin/chatit executable"

        # Check if ~/.local/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            print_warning "~/.local/bin not in PATH"
            echo ""
            echo "Add to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
            echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
            echo ""
        fi
    fi
}

# ============================================================================
# Provider Setup
# ============================================================================

setup_provider() {
    print_header "Provider Configuration"

    echo "Choose your AI provider:"
    echo ""
    echo "1) Anthropic (requires API key)"
    echo "2) OpenRouter (free tier available)"
    echo "3) OpenCode (local server)"
    echo "4) Skip for now"
    echo ""
    read -p "Select option (1-4): " PROVIDER_CHOICE

    case $PROVIDER_CHOICE in
        1)
            print_info "Anthropic selected"
            read -s -p "Enter your Anthropic API key: " API_KEY
            echo ""
            export ANTHROPIC_API_KEY="$API_KEY"
            print_success "API key configured"
            ;;
        2)
            print_info "OpenRouter selected (free tier)"
            print_info "Free models available without API key"
            read -p "Enter OpenRouter API key (optional, press Enter to skip): " OPENROUTER_KEY
            if [ -n "$OPENROUTER_KEY" ]; then
                export OPENROUTER_API_KEY="$OPENROUTER_KEY"
                print_success "OpenRouter key configured"
            else
                print_info "Using OpenRouter free tier"
            fi
            ;;
        3)
            print_info "OpenCode selected"
            read -p "Enter OpenCode server URL (default: http://localhost:4096): " OPENCODE_URL
            export OPENCODE_ENDPOINT="${OPENCODE_URL:-http://localhost:4096}"
            print_success "OpenCode endpoint configured"
            ;;
        4)
            print_info "Skipping provider setup for now"
            print_info "You can configure it later with: chatit /provider"
            ;;
        *)
            print_warning "Invalid option, skipping provider setup"
            ;;
    esac
}

# ============================================================================
# Post-Installation
# ============================================================================

create_startup_script() {
    print_header "Creating Quick Start Script"

    cat > "$INSTALL_DIR/chatit-start.sh" << 'EOF'
#!/bin/bash
# Quick start script for Chatit

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$INSTALL_DIR"

echo "Starting Chatit..."
echo ""

# Detect runtime
if command -v bun &> /dev/null; then
    bun run src/main.tsx "$@"
else
    npm run dev -- "$@"
fi
EOF
    chmod +x "$INSTALL_DIR/chatit-start.sh"
    print_success "Created quick start script"
}

# ============================================================================
# Summary
# ============================================================================

print_summary() {
    print_header "Installation Complete! 🎉"

    echo "Chatit has been successfully installed!"
    echo ""
    echo -e "${GREEN}Installation Details:${NC}"
    echo "  • Install Directory: $INSTALL_DIR"
    echo "  • Config Directory: $CONFIG_DIR"
    echo "  • Runtime: $RUNTIME"
    echo ""
    echo -e "${GREEN}Next Steps:${NC}"
    echo ""
    echo "1. Try Chatit:"
    echo -e "   ${BLUE}chatit \"Hello, help me with this code\"${NC}"
    echo ""
    echo "2. View available commands:"
    echo -e "   ${BLUE}chatit /help${NC}"
    echo ""
    echo "3. Change theme:"
    echo -e "   ${BLUE}chatit /theme${NC}"
    echo ""
    echo "4. Switch providers:"
    echo -e "   ${BLUE}chatit /provider${NC}"
    echo ""
    echo "5. View usage guide:"
    echo -e "   ${BLUE}cat $INSTALL_DIR/CHATIT_README.md${NC}"
    echo ""
    echo -e "${YELLOW}Documentation:${NC}"
    echo "  • Full Guide: $INSTALL_DIR/CHATIT_README.md"
    echo "  • Implementation: $INSTALL_DIR/IMPLEMENTATION_SUMMARY.md"
    echo ""
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  CC - AGENTIC CHATIT.CLOUD CODE ASSISTANT                 ║"
    echo "║  Installation Script                                       ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    check_prerequisites
    setup_installation_dir
    install_dependencies
    setup_config_directory
    create_executable
    create_startup_script

    read -p "Would you like to configure a provider now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_provider
    fi

    print_summary
}

# Run main installation
main "$@"
