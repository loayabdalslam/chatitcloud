#!/bin/bash

###############################################################################
#
# Chatit.Cloud (CC) Installation Script
# Fast installation with GitHub integration and PATH configuration
#
# Usage: curl -fsSL https://raw.githubusercontent.com/loayabdalslam/chatitcloud/main/install.sh | bash
#
###############################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/loayabdalslam/chatitcloud"
REPO_NAME="chatitcloud"
INSTALL_DIR="${HOME}/.local/bin"
BIN_NAME="chatit"
VERSION_FILE=".version_installed"

###############################################################################
# Logging Functions
###############################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

###############################################################################
# System Check Functions
###############################################################################

check_required_tools() {
    log_info "Checking required tools..."
    
    local missing_tools=()
    
    # Check for git
    if ! command -v git &> /dev/null; then
        missing_tools+=("git")
    fi
    
    # Check for node or bun
    if ! command -v node &> /dev/null && ! command -v bun &> /dev/null; then
        missing_tools+=("node (or bun)")
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        echo ""
        echo "Please install:"
        for tool in "${missing_tools[@]}"; do
            case $tool in
                git)
                    echo "  • Git: https://git-scm.com/downloads"
                    ;;
                node*)
                    echo "  • Node.js (>= 18.0.0): https://nodejs.org/"
                    echo "    OR Bun (>= 1.0.0): https://bun.sh/"
                    ;;
            esac
        done
        return 1
    fi
    
    log_success "All required tools found"
    return 0
}

check_node_version() {
    if command -v node &> /dev/null; then
        local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$node_version" -lt 18 ]; then
            log_error "Node.js version 18.0.0 or higher required (current: $(node -v))"
            return 1
        fi
    fi
    return 0
}

###############################################################################
# Installation Functions
###############################################################################

create_install_dir() {
    log_info "Setting up installation directory..."
    
    if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p "$INSTALL_DIR"
        log_success "Created $INSTALL_DIR"
    fi
    
    return 0
}

clone_or_update_repo() {
    local temp_dir=$(mktemp -d)
    local repo_dir="$temp_dir/$REPO_NAME"
    
    log_info "Downloading Chatit.Cloud from GitHub..."
    
    if git clone --depth=1 "$REPO_URL.git" "$repo_dir" 2>/dev/null; then
        log_success "Repository cloned"
    else
        log_error "Failed to clone repository from $REPO_URL"
        rm -rf "$temp_dir"
        return 1
    fi
    
    echo "$repo_dir"
}

detect_runtime() {
    if command -v bun &> /dev/null; then
        echo "bun"
    elif command -v npm &> /dev/null; then
        echo "npm"
    else
        return 1
    fi
}

build_project() {
    local repo_dir="$1"
    local runtime="$2"
    
    log_info "Installing dependencies..."
    cd "$repo_dir"
    
    case "$runtime" in
        bun)
            if ! bun install --frozen-lockfile 2>/dev/null; then
                log_warning "Bun install failed, retrying without frozen-lockfile..."
                bun install
            fi
            ;;
        npm)
            if ! npm ci 2>/dev/null; then
                log_warning "npm ci failed, using npm install..."
                npm install
            fi
            ;;
    esac
    
    log_success "Dependencies installed"
    
    log_info "Building project..."
    case "$runtime" in
        bun)
            bun run build
            ;;
        npm)
            npm run build
            ;;
    esac
    
    log_success "Project built successfully"
}

install_binary() {
    local repo_dir="$1"
    local dist_file="$repo_dir/dist/chatit.js"
    
    if [ ! -f "$dist_file" ]; then
        log_error "Build output not found at $dist_file"
        return 1
    fi
    
    log_info "Installing binary to $INSTALL_DIR/$BIN_NAME..."
    
    cp "$dist_file" "$INSTALL_DIR/$BIN_NAME"
    chmod +x "$INSTALL_DIR/$BIN_NAME"
    
    log_success "Binary installed"
}

update_shell_profile() {
    log_info "Updating shell configuration..."
    
    local shell_profiles=()
    
    # Determine shell and profile files
    case "$SHELL" in
        */bash)
            shell_profiles=("$HOME/.bashrc" "$HOME/.bash_profile")
            ;;
        */zsh)
            shell_profiles=("$HOME/.zshrc")
            ;;
        */fish)
            shell_profiles=("$HOME/.config/fish/config.fish")
            ;;
        *)
            log_warning "Unknown shell: $SHELL"
            log_info "Please manually add $INSTALL_DIR to your PATH"
            return 0
            ;;
    esac
    
    local path_entry="export PATH=\"$INSTALL_DIR:\$PATH\""
    local added=false
    
    for profile in "${shell_profiles[@]}"; do
        if [ -f "$profile" ]; then
            if ! grep -q "$INSTALL_DIR" "$profile"; then
                echo "" >> "$profile"
                echo "# Chatit.Cloud PATH" >> "$profile"
                echo "$path_entry" >> "$profile"
                log_success "Updated $profile"
                added=true
            else
                log_warning "$INSTALL_DIR already in $profile"
            fi
        fi
    done
    
    if [ "$added" = true ]; then
        log_info "Please run: source \$HOME/$(basename "${shell_profiles[0]}")"
    fi
}

verify_installation() {
    log_info "Verifying installation..."
    
    if ! command -v "$BIN_NAME" &> /dev/null; then
        # Try with explicit path
        if "$INSTALL_DIR/$BIN_NAME" --version &> /dev/null; then
            log_success "Installation verified (please reload shell)"
            return 0
        else
            log_error "Installation verification failed"
            return 1
        fi
    fi
    
    local version=$("$BIN_NAME" --version 2>/dev/null || echo "unknown")
    log_success "Chatit.Cloud installed successfully! Version: $version"
}

print_next_steps() {
    echo ""
    echo -e "${BLUE}=================================${NC}"
    echo -e "${GREEN}Installation Complete!${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Reload your shell configuration:"
    echo "   source \$HOME/.${SHELL##*/}rc"
    echo ""
    echo "2. Initialize Chatit.Cloud:"
    echo "   chatit init"
    echo ""
    echo "3. Configure your AI provider (Claude, OpenAI, etc.):"
    echo "   chatit login"
    echo ""
    echo "4. Start using Chatit.Cloud:"
    echo "   chatit help"
    echo ""
    echo "5. Get started with basic commands:"
    echo "   chatit review         - Review code"
    echo "   chatit commit         - Generate commit messages"
    echo "   chatit brief          - Summarize code"
    echo ""
    echo -e "${BLUE}For more info: ${YELLOW}https://github.com/loayabdalslam/chatitcloud${NC}"
    echo ""
}

cleanup() {
    local repo_dir="$1"
    # Remove temporary directory
    rm -rf "$(dirname "$repo_dir")"
}

###############################################################################
# Main Installation Workflow
###############################################################################

main() {
    echo -e "${BLUE}"
    cat << "EOF"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║        Chatit.Cloud (CC) - Terminal AI Coding Assistant        ║
║                    Installation Script                         ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    
    # Step 1: Check requirements
    if ! check_required_tools; then
        exit 1
    fi
    
    if ! check_node_version; then
        exit 1
    fi
    
    # Step 2: Setup
    if ! create_install_dir; then
        exit 1
    fi
    
    # Step 3: Clone repository
    local repo_dir
    if ! repo_dir=$(clone_or_update_repo); then
        exit 1
    fi
    
    # Step 4: Detect runtime
    local runtime
    if ! runtime=$(detect_runtime); then
        log_error "Neither Bun nor npm found"
        cleanup "$repo_dir"
        exit 1
    fi
    
    log_success "Using $runtime for build"
    
    # Step 5: Build
    if ! build_project "$repo_dir" "$runtime"; then
        log_error "Build failed"
        cleanup "$repo_dir"
        exit 1
    fi
    
    # Step 6: Install binary
    if ! install_binary "$repo_dir"; then
        cleanup "$repo_dir"
        exit 1
    fi
    
    # Step 7: Update shell profile
    update_shell_profile
    
    # Step 8: Verify
    verify_installation || true
    
    # Step 9: Print next steps
    print_next_steps
    
    # Cleanup
    cleanup "$repo_dir"
}

# Run main function
main "$@"
