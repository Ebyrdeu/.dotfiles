#!/usr/bin/env bash
set -euo pipefail

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
if ! command -v dnf >/dev/null 2>&1; then
    err "This script requires Fedora (dnf)."
    exit 1
fi

packages=(
    tldr
    fcitx5
    fcitx5-mozc
    tmux
    neovim
    mpv
    qbittorrent
    telegram-desktop
    thunderbird
)

say "Checking software suite dependencies..."

to_install=()
for pkg in "${packages[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        to_install+=("$pkg")
    fi
done

if [[ ${#to_install[@]} -gt 0 ]]; then
    say "Installing packages: ${to_install[*]}"
    if sudo dnf install -y "${to_install[@]}"; then
        ok "All packages installed successfully."
    else
        err "Some packages failed to install. Check output above."
        exit 1
    fi
else
    ok "All requested packages are already installed."
fi

# Post-Install Setup
if command -v tldr &>/dev/null; then
    echo "------------------------------------------------------------"
    say "Updating tldr cache..."
    tldr --update || warn "Failed to update tldr cache."
fi

echo "------------------------------------------------------------"
ok "Software installation complete!"
