#!/bin/bash
#
# ██████╗ ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗     ███████╗
# ██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██╔════╝██║     ██╔════╝
# ██║   ██║██╔██╗ ██║██║     ██║   ██║█████╗  ██║     █████╗  
# ██║   ██║██║╚██╗██║██║     ██║   ██║██╔══╝  ██║     ██╔══╝  
# ╚██████╔╝██║ ╚████║╚██████╗╚██████╔╝███████╗███████╗███████╗
#  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
#                                                             
#            OpenClaw Android/Termux Installer v1.1
#            Easiest way to run OpenClaw on Android
#
# ============================================================
# USAGE: curl -sL https://raw.githubusercontent.com/Vamsiindugu/Openclaw-on-Android/main/install.sh | bash
# ============================================================

set -e  # Exit on error

# ========================
# VERSION
# ========================
VERSION="1.1.1"

# ========================
# COLOR CODES
# ========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ========================
# HELPER FUNCTIONS
# ========================
print_banner() {
    echo -e "${CYAN}"
    echo "██████╗ ███╗   ██╗ ██████╗ ██████╗ ███████╗██╗     ███████╗"
    echo "██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██╔════╝██║     ██╔════╝"
    echo "██║   ██║██╔██╗ ██║██║     ██║   ██║█████╗  ██║     █████╗  "
    echo "██║   ██║██║╚██╗██║██║     ██║   ██║██╔══╝  ██║     ██╔══╝  "
    echo "╚██████╔╝██║ ╚████║╚██████╗╚██████╔╝███████╗███████╗███████╗"
    echo " ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝"
    echo -e "${NC}"
    echo -e "${BOLD}        OpenClaw Android/Termux Installer v${VERSION}${NC}"
    echo -e "${YELLOW}        Easiest way to run OpenClaw on Android${NC}"
    echo ""
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Safe file append - prevents duplicates
safe_append_to_file() {
    local content="$1"
    local file="$2"
    local marker="$3"  # Unique marker comment
    
    # Create file if it doesn't exist
    touch "$file" 2>/dev/null || return 1
    
    # Check if marker exists
    if ! grep -q "$marker" "$file" 2>/dev/null; then
        echo "$content" >> "$file"
        return 0
    fi
    return 2  # Already exists
}

# ========================
# PRE-FLIGHT CHECKS
# ========================
preflight_checks() {
    log_step "🔍 PRE-FLIGHT CHECKS"
    
    # Check if running in Termux
    if [ -z "$TERMUX_VERSION" ]; then
        log_error "This script must be run in Termux!"
        log_info "Install Termux from F-Droid: https://f-droid.org/packages/com.termux/"
        exit 1
    fi
    log_success "Running in Termux v$TERMUX_VERSION"
    
    # Check architecture
    ARCH=$(uname -m)
    if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
        log_warning "Architecture: $ARCH (not officially tested)"
    else
        log_success "Architecture: $ARCH (ARM64 supported)"
    fi
    
    # Check Android version
    ANDROID_VER=$(getprop ro.build.version.release 2>/dev/null || echo "unknown")
    log_info "Android version: $ANDROID_VER"
    
    # Check available storage (need at least 500MB)
    STORAGE_AVAIL_KB=$(df -k "$HOME" | awk 'NR==2 {print $4}')
    if [ "$STORAGE_AVAIL_KB" -lt 512000 ]; then
        log_warning "Low storage: $(df -h "$HOME" | awk 'NR==2 {print $4}') - recommend 500MB+"
    else
        log_info "Available storage: $(df -h "$HOME" | awk 'NR==2 {print $4}')"
    fi
    
    # Check if node is already installed
    if check_command node; then
        NODE_VER=$(node -v)
        log_info "Node.js already installed: $NODE_VER"
    fi
    
    log_success "Pre-flight checks passed!"
}

# ========================
# PACKAGE INSTALLATION
# ========================
install_packages() {
    log_step "📦 INSTALLING PACKAGES"
    
    # Update package lists with better error handling
    log_info "Updating package lists..."
    if ! pkg update -y 2>/dev/null; then
        log_warning "pkg update failed, trying pkg upgrade..."
        pkg upgrade -y || {
            log_error "Failed to update packages"
            log_info "Try manually: pkg update && pkg upgrade"
            log_info "Then re-run this installer"
            exit 1
        }
    fi
    
    # Required packages (FIXED: added cmake for koffi native builds)
    PACKAGES=(
        "nodejs"
        "git"
        "curl"
        "wget"
        "python"
        "clang"           # Required for native npm builds
        "cmake"           # FIXED: Required for koffi/native module builds
        "make"            # Build tool
        "pkg-config"      # Required for some npm packages
        "binutils"
        "libjpeg-turbo"
        "libpng"
        "zlib"
        "openssl"
        "openssh"
        "tmux"
        "nano"
        "vim"
        "jq"
        "fzf"
        "ripgrep"
        "fd"
    )
    
    log_info "Installing ${#PACKAGES[@]} packages..."
    
    # Try bulk install first
    if pkg install -y "${PACKAGES[@]}" 2>/dev/null; then
        log_success "All packages installed successfully!"
    else
        log_warning "Bulk installation had issues. Installing packages individually..."
        FAILED_PKGS=()
        for PKG in "${PACKAGES[@]}"; do
            log_info "Installing $PKG..."
            if ! pkg install -y "$PKG" 2>/dev/null; then
                log_warning "Failed to install: $PKG"
                FAILED_PKGS+=("$PKG")
            fi
        done
        
        if [ ${#FAILED_PKGS[@]} -gt 0 ]; then
            log_warning "Failed packages: ${FAILED_PKGS[*]}"
            log_info "These may be optional. Continuing..."
        fi
    fi
}

# ========================
# NODE.JS VERIFICATION
# ========================
verify_nodejs() {
    log_step "🔷 VERIFYING NODE.JS"
    
    if ! check_command node; then
        log_error "Node.js installation failed!"
        exit 1
    fi
    
    NODE_VER=$(node -v)
    NPM_VER=$(npm -v)
    
    log_success "Node.js: $NODE_VER"
    log_success "npm: $NPM_VER"
    
    # Check Node.js version (need 18+)
    NODE_MAJOR=$(echo "$NODE_VER" | sed 's/v//; s/\..*//')
    if [[ "$NODE_MAJOR" =~ ^[0-9]+$ ]] && [ "$NODE_MAJOR" -lt 18 ]; then
        log_warning "Node.js version < 18 may cause issues"
        log_info "Recommended: Node.js 20+ or 24+"
    fi
    
    # Configure npm for Termux
    log_info "Configuring npm for Termux..."
    npm config set python python3 2>/dev/null || true
    npm config set scripts-prepend-node-path true 2>/dev/null || true
    
    log_success "Node.js ready!"
}

# ========================
# TERMUX CONFIGURATION
# ========================
configure_termux() {
    log_step "⚙️ CONFIGURING TERMUX"
    
    # Enable wake lock to prevent background kills
    log_info "Enabling wake lock..."
    if command -v termux-wake-lock &> /dev/null; then
        termux-wake-lock
        log_success "Wake lock enabled"
    else
        log_warning "termux-tools not installed, skipping wake lock"
    fi
    
    # FIXED: Better alias configuration with duplicate prevention
    log_info "Configuring aliases..."
    
    ALIAS_BLOCK='
# ═══════════════════════════════════════════════════════════════
# OpenClaw aliases - DO NOT EDIT THIS BLOCK (auto-generated)
# ═══════════════════════════════════════════════════════════════
alias oa="openclaw"
alias ocl="openclaw"
alias jarvis="openclaw chat"
alias claw-status="openclaw status"
alias claw-start="openclaw gateway start"
alias claw-stop="openclaw gateway stop"

# Node.js memory optimization for Android
export NODE_OPTIONS="--max-old-space-size=4096"

# OpenClaw aliases end
# ═══════════════════════════════════════════════════════════════'
    
    # Configure bashrc
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "OpenClaw aliases - DO NOT EDIT" "$HOME/.bashrc" 2>/dev/null; then
            echo "$ALIAS_BLOCK" >> "$HOME/.bashrc"
            log_success "Added OpenClaw aliases to .bashrc"
        else
            log_info "Aliases already configured in .bashrc"
        fi
    else
        echo "$ALIAS_BLOCK" > "$HOME/.bashrc"
        log_success "Created .bashrc with OpenClaw aliases"
    fi
    
    # Configure zshrc ONLY if it exists (user has zsh installed)
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "OpenClaw aliases - DO NOT EDIT" "$HOME/.zshrc" 2>/dev/null; then
            echo "$ALIAS_BLOCK" >> "$HOME/.zshrc"
            log_success "Added OpenClaw aliases to .zshrc"
        else
            log_info "Aliases already configured in .zshrc"
        fi
    fi
    
    # Create workspace directory
    mkdir -p "$HOME/.openclaw/workspace"
    log_success "Created workspace: ~/.openclaw/workspace"
    
    log_success "Termux configuration complete!"
}

# ========================
# OPENCLAW INSTALLATION
# ========================
install_openclaw() {
    log_step "🚀 INSTALLING OPENCLAW"
    
    log_info "Installing OpenClaw from npm..."
    
    # Try installation with retry logic
    MAX_RETRIES=3
    RETRY_COUNT=0
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        RETRY_COUNT=$((RETRY_COUNT + 1))
        log_info "Attempt $RETRY_COUNT of $MAX_RETRIES..."
        
        if npm install -g openclaw 2>/dev/null; then
            log_success "OpenClaw installed successfully!"
            break
        else
            if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
                log_error "Failed to install OpenClaw after $MAX_RETRIES attempts"
                log_info "Try manually: npm install -g openclaw --verbose"
                log_info "Or check npm logs: npm cache clean --force && npm install -g openclaw"
                exit 1
            fi
            log_warning "Installation failed, retrying in 5 seconds..."
            npm cache clean --force 2>/dev/null || true
            sleep 5
        fi
    done
    
    # Verify installation
    if ! check_command openclaw; then
        log_error "OpenClaw command not found in PATH"
        log_info "Try: hash -r && openclaw --version"
        exit 1
    fi
    
    OCL_VER=$(openclaw --version 2>/dev/null || echo "unknown")
    log_success "OpenClaw version: $OCL_VER"
    
    log_success "OpenClaw installation complete!"
}

# ========================
# SETUP WIZARD
# ========================
run_setup_wizard() {
    log_step "🧙 SETUP WIZARD"
    
    echo ""
    log_info "Would you like to run the initial setup? (y/n)"
    read -p "> " RUN_SETUP < /dev/tty
    
    if [ "$RUN_SETUP" = "y" ] || [ "$RUN_SETUP" = "Y" ]; then
        log_info "Running 'openclaw init'..."
        openclaw init 2>/dev/null || log_warning "init had issues (may be already configured)"
        log_success "Initial setup complete!"
    else
        log_info "Skipping initial setup. Run 'openclaw init' later."
    fi
    
    # FIXED: Correct Telegram setup instructions
    echo ""
    log_info "Would you like to set up a Telegram bot? (y/n)"
    read -p "> " SETUP_TELEGRAM < /dev/tty
    
    if [ "$SETUP_TELEGRAM" = "y" ] || [ "$SETUP_TELEGRAM" = "Y" ]; then
        echo ""
        log_info "═══════════════════════════════════════════════════════════════"
        log_info "TELEGRAM BOT SETUP"
        log_info "═══════════════════════════════════════════════════════════════"
        echo ""
        log_info "Step 1: Create a bot"
        echo "  1. Open Telegram and search for @BotFather"
        echo "  2. Send: /newbot"
        echo "  3. Follow prompts and save the BOT TOKEN"
        echo ""
        log_info "Step 2: Add token to OpenClaw config"
        echo "  Edit: ~/.openclaw/openclaw.json"
        echo "  Add under channels.telegram.botToken:"
        echo ""
        echo '  "channels": {'
        echo '    "telegram": {'
        echo '      "enabled": true,'
        echo '      "botToken": "YOUR_BOT_TOKEN_HERE",'
        echo '      "dmPolicy": "pairing"'
        echo '    }'
        echo '  }'
        echo ""
        log_info "Step 3: Start gateway and pair"
        echo "  openclaw gateway start"
        echo "  openclaw pairing list telegram"
        echo "  openclaw pairing approve telegram <CODE>"
        echo ""
        log_info "Your Telegram User ID can be found by messaging @userinfobot"
        log_info "═══════════════════════════════════════════════════════════════"
    fi
}

# ========================
# BROWSER EXTENSION INFO
# ========================
show_browser_info() {
    log_step "🌐 BROWSER EXTENSION SETUP"
    
    echo ""
    log_info "For browser automation, install the OpenClaw Browser Extension:"
    echo ""
    echo "  1. Install Lemur Browser (or Kiwi Browser) from Play Store"
    echo "  2. Install the extension:"
    echo "     ${CYAN}openclaw browser extension install${NC}"
    echo "     ${CYAN}openclaw browser extension path${NC}  # Shows installed path"
    echo ""
    echo "  3. In browser, go to: chrome://extensions"
    echo "  4. Enable 'Developer mode' (toggle in top-right)"
    echo "  5. Click 'Load unpacked' → Select the extension directory"
    echo "  6. Configure gateway port (default: 18792) and token"
    echo ""
    log_info "Lemur Browser supports Chrome extensions on Android!"
    echo "  Play Store: com.lemurbrowser.exts"
    echo ""
}

# ========================
# FINAL SUMMARY
# ========================
show_summary() {
    log_step "✅ INSTALLATION COMPLETE!"
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║            OpenClaw is ready to use!                       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}Quick Start Commands:${NC}"
    echo ""
    echo "  ${CYAN}source ~/.bashrc${NC}      - Activate aliases now"
    echo "  ${CYAN}openclaw status${NC}       - Check system status"
    echo "  ${CYAN}openclaw init${NC}         - Run initial setup"
    echo "  ${CYAN}openclaw gateway start${NC} - Start the gateway server"
    echo "  ${CYAN}openclaw chat${NC}         - Start interactive chat"
    echo "  ${CYAN}openclaw --help${NC}       - Show all commands"
    echo ""
    echo -e "${BOLD}Aliases (added to .bashrc):${NC}"
    echo ""
    echo "  ${CYAN}oa${NC}         = openclaw"
    echo "  ${CYAN}ocl${NC}        = openclaw"
    echo "  ${CYAN}jarvis${NC}     = openclaw chat"
    echo "  ${CYAN}claw-status${NC} = openclaw status"
    echo ""
    echo -e "${BOLD}Useful Links:${NC}"
    echo ""
    echo "  📖 Docs:    https://docs.openclaw.ai"
    echo "  🐙 GitHub:  https://github.com/openclaw/openclaw"
    echo "  💬 Discord: https://discord.gg/clawd"
    echo "  🛒 Skills:  https://clawhub.com"
    echo ""
    echo -e "${YELLOW}⚠️  Restart Termux or run 'source ~/.bashrc' to activate aliases!${NC}"
    echo ""
}

# ========================
# ERROR HANDLER
# ========================
show_troubleshooting() {
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                  TROUBLESHOOTING GUIDE                     ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}Common Issues:${NC}"
    echo ""
    echo "1. ${YELLOW}npm install fails with 'cmake not found'${NC}"
    echo "   → Install cmake: pkg install cmake"
    echo "   → Then retry: npm install -g openclaw"
    echo ""
    echo "2. ${YELLOW}npm install fails (general)${NC}"
    echo "   → Try: pkg upgrade && npm cache clean --force"
    echo "   → Then: npm install -g openclaw --verbose"
    echo ""
    echo "2. ${YELLOW}Node.js memory error${NC}"
    echo "   → Check: echo \$NODE_OPTIONS"
    echo "   → Should show: --max-old-space-size=4096"
    echo ""
    echo "3. ${YELLOW}Gateway won't start${NC}"
    echo "   → Check port: lsof -i :18789"
    echo "   → Kill process: kill -9 <PID>"
    echo ""
    echo "4. ${YELLOW}Termux killed in background${NC}"
    echo "   → Enable wake lock: termux-wake-lock"
    echo "   → Disable battery optimization for Termux"
    echo ""
    echo "5. ${YELLOW}Permission denied${NC}"
    echo "   → Run: termux-setup-storage"
    echo ""
    echo "6. ${YELLOW}command not found: openclaw${NC}"
    echo "   → Run: hash -r"
    echo "   → Or: source ~/.bashrc"
    echo ""
    echo -e "${BOLD}Get Help:${NC}"
    echo "  Discord: https://discord.gg/clawd"
    echo "  Docs:    https://docs.openclaw.ai"
    echo ""
}

# ========================
# MAIN EXECUTION
# ========================
main() {
    # Clear screen and show banner
    clear
    print_banner
    
    # Run all steps
    preflight_checks
    install_packages
    verify_nodejs
    configure_termux
    install_openclaw
    run_setup_wizard
    show_browser_info
    show_summary
    
    log_success "Installation completed successfully!"
    log_info "Restart Termux or run 'source ~/.bashrc' to apply changes."
}

# Run with error handling
trap 'log_error "Installation failed at line $LINENO"; show_troubleshooting' ERR
main "$@"
