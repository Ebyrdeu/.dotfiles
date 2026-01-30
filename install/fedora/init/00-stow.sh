#!/usr/bin/env bash
set -euo pipefail


# Configuration
DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors
C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_RESET='\033[0m'

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }

# 1. Dependency Check
if ! command -v stow &>/dev/null; then
    say "Installing GNU Stow..."
    sudo dnf install -y stow
fi

# 2. Cleanup Legacy Files
say "Cleaning up existing configuration files..."

for file in ".bashrc" ".bash_profile"; do
    if [[ -f "$HOME/$file" && ! -L "$HOME/$file" ]]; then
        echo "  [-] Removing local file: $HOME/$file"
        rm "$HOME/$file"
    fi
done

# KDE-specific configs
kde_configs=("kglobalshortcutsrc" "kwinrulesrc" "konsolerc")
for file in "${kde_configs[@]}"; do
    target="$CONFIG_DIR/$file"
    if [[ -f "$target" && ! -L "$target" ]]; then
        echo "  [-] Removing local config: $file"
        rm "$target"
    fi
done

# 3. Execution
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${C_ERR}Error: $DOTFILES_DIR not found.${C_RESET}"
    exit 1
fi

cd "$DOTFILES_DIR"

say "Stowing dotfiles..."
stow_cmd="stow --target=$HOME --verbose=1 --ignore=(i3|paru|rofi|hypr|waybar|alacritty|dunst|install|README.md|.git) ."

# Run the command
if $stow_cmd; then
    echo -e "${C_OK}------------------------------------------------${C_RESET}"
    echo -e "Success! Your environment is now stowed."
    echo -e "Symlinks created in $HOME pointing to $DOTFILES_DIR"
    echo -e "${C_OK}------------------------------------------------${C_RESET}"
else
    echo -e "${C_WARN}Stow encountered conflicts. Check the output above.${C_RESET}"
    exit 1
fi
