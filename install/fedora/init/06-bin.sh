#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/.dotfiles/install/.bins"
TARGET_DIR="/usr/local/bin"

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

# Pre-flight checks
if [[ ! -d "$SOURCE_DIR" ]]; then
    err "Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
    warn "Target directory '$TARGET_DIR' not found. Creating..."
    sudo mkdir -p "$TARGET_DIR"
fi

# Request sudo credentials up front & keep refreshed in background
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

say "Linking scripts from '$SOURCE_DIR' to '$TARGET_DIR'..."
echo "------------------------------------------------------------"

shopt -s nullglob

count=0
for script in "$SOURCE_DIR"/*; do
    # Skip directories
    [[ -f "$script" ]] || continue

    script_name=$(basename "$script")
    target_link="$TARGET_DIR/$script_name"

    # Ensure source file is executable
    [[ -x "$script" ]] || chmod +x "$script"

    # Skip if already linked to the exact source
    if [[ -L "$target_link" && "$(readlink "$target_link")" == "$script" ]]; then
        continue
    fi

    # Create the symlink
    printf "  Linking %-25s " "$script_name..."
    if sudo ln -sf "$script" "$target_link"; then
        printf "%bOK%b\n" "$C_OK" "$C_RESET"
        ((count++))
    else
        printf "%bFAILED%b\n" "$C_ERR" "$C_RESET"
    fi
done

echo "------------------------------------------------------------"
if [[ $count -gt 0 ]]; then
    ok "Successfully linked $count new script(s)!"
else
    ok "All scripts are already up to date."
fi
