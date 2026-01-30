#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/.dotfiles/install/.bins"
TARGET_DIR="/usr/local/bin"

# Colors
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_ERR='\033[0;31m'
C_RESET='\033[0m'

# Pre-flight checks
if [[ ! -d "$SOURCE_DIR" ]]; then
    printf "${C_ERR}Error: Source %s does not exist.${C_RESET}\n" "$SOURCE_DIR"
    exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
    printf "${C_WARN}Target %s not found. Creating...${C_RESET}\n" "$TARGET_DIR"
    sudo mkdir -p "$TARGET_DIR"
fi

# Ask for sudo once up front
sudo -v

echo "Linking scripts from $SOURCE_DIR to $TARGET_DIR..."

# Use nullglob to handle empty directories gracefully
shopt -s nullglob

for script in "$SOURCE_DIR"/*; do
    # Skip directories, only process files
    [[ -d "$script" ]] && continue

    script_name=$(basename "$script")

    # 1. Ensure the source file is executable
    if [[ ! -x "$script" ]]; then
        chmod +x "$script"
    fi

    # 2. Check if a link already exists
    if [[ -L "$TARGET_DIR/$script_name" ]]; then
        # If it's already linked correctly, skip it
        if [[ "$(readlink "$TARGET_DIR/$script_name")" == "$script" ]]; then
            continue
        fi
    fi

    # 3. Create the symlink
    printf "  linking: %-20s " "$script_name"
    if sudo ln -sf "$script" "$TARGET_DIR/$script_name"; then
        printf "${C_OK}OK${C_RESET}\n"
    else
        printf "${C_ERR}FAILED${C_RESET}\n"
    fi
done

echo "------------------------------------------------------------"
echo "Done! Your scripts are now available in your PATH."
