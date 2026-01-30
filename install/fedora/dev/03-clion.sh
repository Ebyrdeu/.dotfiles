#!/usr/bin/env bash
set -euo pipefail

# Configuration
CLION_URL="https://data.services.jetbrains.com/products/download?code=CL&platform=linux"
INSTALL_DIR="/opt/clion"
BIN_LINK="/usr/local/bin/clion"
EXEC_PATH="$INSTALL_DIR/bin/clion.sh"

# Colors
C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_RESET='\033[0m'

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }

# Check existing installation
if [[ -f "$EXEC_PATH" ]]; then
    echo -e "${C_OK}CLion already installed. Skipping...${C_RESET}"
else
    # 1. Dependency Check
    for cmd in wget tar; do
        if ! command -v "$cmd" &>/dev/null; then
            sudo dnf install -y "$cmd"
        fi
    done

    # 2. Download and Extract
    say "Downloading latest CLion..."
    wget -q --show-progress -O /tmp/clion.tar.gz "$CLION_URL"

    say "Extracting to $INSTALL_DIR..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo rm -rf "${INSTALL_DIR:?}"/*
    sudo tar -xzf /tmp/clion.tar.gz -C "$INSTALL_DIR" --strip-components=1
    rm /tmp/clion.tar.gz

    # 3. Ownership and Symlink
    say "Finalizing installation..."
    sudo chown -R "$(whoami):$(whoami)" "$INSTALL_DIR"
    sudo ln -sf "$EXEC_PATH" "$BIN_LINK"

    echo -e "${C_OK}CLion installation complete!${C_RESET}"
fi
