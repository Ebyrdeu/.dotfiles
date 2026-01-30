#!/bin/bash
set -euo pipefail

# Colors
C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_RESET='\033[0m'

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }

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



say "Installing software suite..."
if sudo dnf install -y "${packages[@]}"; then
    echo -e "${C_OK}------------------------------------------------${C_RESET}"
    echo -e "Success! All packages installed."
    echo -e "${C_OK}------------------------------------------------${C_RESET}"
else
    echo -e "${C_WARN}Some packages failed to install. Check output above.${C_RESET}"
    exit 1
fi

# 5. Post-Install: TLDR Update
if command -v tldr &>/dev/null; then
    say "Updating tldr cache..."
    tldr --update || true
fi
