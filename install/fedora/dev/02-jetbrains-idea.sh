#!/usr/bin/env bash
set -euo pipefail

# Configuration
IDEA_URL="https://data.services.jetbrains.com/products/download?code=IIU&platform=linux"
INSTALL_DIR="/opt/idea"
BIN_LINK="/usr/local/bin/idea"
EXEC_PATH="$INSTALL_DIR/bin/idea"

# Colors
C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_RESET='\033[0m'

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }

# Check existing installation
if [[ -f "$EXEC_PATH" ]]; then
    echo -e "${C_OK}IntelliJ IDEA already installed. Skipping...${C_RESET}"
else
    # 1. Dependency Check
    if ! command -v wget &>/dev/null; then
        sudo dnf install -y wget tar
    fi

    # 2. Download and Extract
    say "Downloading latest IntelliJ IDEA Ultimate..."
    wget -q --show-progress -O /tmp/idea.tar.gz "$IDEA_URL"

    say "Extracting to $INSTALL_DIR..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo rm -rf "${INSTALL_DIR:?}"/*
    sudo tar -xzf /tmp/idea.tar.gz -C "$INSTALL_DIR" --strip-components=1
    rm /tmp/idea.tar.gz

    # 3. Ownership and Symlink
    say "Finalizing installation..."
    sudo chown -R "$(whoami):$(whoami)" "$INSTALL_DIR"
    sudo ln -sf "$EXEC_PATH" "$BIN_LINK"

    echo -e "${C_OK}IntelliJ IDEA installation complete!${C_RESET}"
fi
