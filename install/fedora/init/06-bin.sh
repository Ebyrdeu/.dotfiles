#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/.dotfiles/install/.bins"
TARGET_DIR="/usr/local/bin"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: $SOURCE_DIR does not exist."
    exit 1
fi

echo "Linking scripts from $SOURCE_DIR to $TARGET_DIR..."

for script in "$SOURCE_DIR"/*; do
    if [[ -f "$script" ]]; then
        script_name=$(basename "$script")

        echo "Linking $script_name..."

        chmod +x "$script"

        sudo ln -sf "$script" "$TARGET_DIR/$script_name"
    fi
done

echo "Done! Your scripts are now linked globally."
