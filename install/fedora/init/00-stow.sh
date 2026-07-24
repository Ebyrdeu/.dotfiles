#!/usr/bin/env bash
set -euo pipefail

# Configuration
DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors
C_RESET='\033[0m'
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_ERR='\033[0;31m'
C_HEAD='\033[1;36m'

# Helpers
say()  { printf "%b[INFO]%b %s\n" "$C_HEAD" "$C_RESET" "$*"; }
ok()   { printf "%b[OK]%b %s\n" "$C_OK"   "$C_RESET" "$*"; }
warn() { printf "%b[WARN]%b %s\n" "$C_WARN" "$C_RESET" "$*"; }
err()  { printf "%b[ERR]%b %s\n" "$C_ERR"  "$C_RESET" "$*" >&2; }

# Guard check
if [[ ! -d "$DOTFILES_DIR" ]]; then
    err "Dotfiles directory '$DOTFILES_DIR' does not exist."
    exit 1
fi

# 1. Dependency Check
if ! command -v stow >/dev/null 2>&1; then
    say "Installing GNU Stow..."
    sudo dnf install -y stow
    ok "GNU Stow installed."
fi

# 2. Cleanup Legacy Non-Symlink Files
say "Cleaning up existing target configuration files..."

legacy_home_files=(".bashrc" ".bash_profile")
for file in "${legacy_home_files[@]}"; do
    target="$HOME/$file"
    if [[ -f "$target" && ! -L "$target" ]]; then
        warn "Removing non-symlink file: $target"
        rm -f "$target"
    fi
done

kde_configs=("kglobalshortcutsrc" "kwinrulesrc" "konsolerc")
for file in "${kde_configs[@]}"; do
    target="$CONFIG_DIR/$file"
    if [[ -f "$target" && ! -L "$target" ]]; then
        warn "Removing non-symlink config: $target"
        rm -f "$target"
    fi
done

# 3. Stow Execution
say "Stowing dotfiles from $DOTFILES_DIR..."

stow_cmd=(
    stow
    --dir="$DOTFILES_DIR"
    --target="$HOME"
    --verbose=1
    --ignore='(install|\.git)'
    .
)

if "${stow_cmd[@]}"; then
    echo "------------------------------------------------------------"
    ok "Success! Your dotfiles environment is now stowed."
    say "Symlinks created in $HOME pointing to $DOTFILES_DIR"
else
    err "Stow encountered conflicts or errors. Check the output above."
    exit 1
fi
