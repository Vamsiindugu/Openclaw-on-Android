#!/usr/bin/env bash
# setup-paths.sh - Create required directories and symlinks for Termux
set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

echo "=== Setting Up Paths ==="
echo ""

# Create TMPDIR
mkdir -p "$PREFIX/tmp/openclaw"
echo -e "${GREEN}[OK]${NC}   Created $PREFIX/tmp/openclaw"

# Create openclaw-android config directory
mkdir -p "$HOME/.openclaw-android/patches"
echo -e "${GREEN}[OK]${NC}   Created $HOME/.openclaw-android/patches"

# Create openclaw data directory
mkdir -p "$HOME/.openclaw"
echo -e "${GREEN}[OK]${NC}   Created $HOME/.openclaw"

echo ""
echo "Standard path mappings (via \$PREFIX):"
echo "  /bin/sh      -> $PREFIX/bin/sh"
echo "  /usr/bin/env -> $PREFIX/bin/env"
echo "  /tmp         -> $PREFIX/tmp"

echo ""
echo -e "${GREEN}Path setup complete.${NC}"
