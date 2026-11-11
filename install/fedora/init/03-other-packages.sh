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
    xdd
    hexdump
    chromium
    tldr
    fcitx5
    fcitx5-mozc
    tmux
    neovim
    mpv
    qbittorrent
    telegram-desktop
)

# Helper function to check and install a package array
install_pkg_list() {
    local list_label="$1"
    shift
    local pkg_array=("$@")
    local to_install=()

    say "Checking $list_label..."

    for pkg in "${pkg_array[@]}"; do
        # Strip leading '@' for group checks via rpm or dnf group list check
        if [[ "$pkg" == @* ]]; then
            local group_name="${pkg#@}"
            if ! dnf group list installed "$group_name" &>/dev/null; then
                to_install+=("$pkg")
            fi
        else
            if ! rpm -q "$pkg" &>/dev/null; then
                to_install+=("$pkg")
            fi
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        say "Installing $list_label: ${to_install[*]}"
        if sudo dnf install -y "${to_install[@]}"; then
            ok "$list_label installed successfully."
        else
            err "Some packages in $list_label failed to install."
            return 1
        fi
    else
        ok "All items in $list_label are already installed."
    fi
}

# Run installation loops
install_pkg_list "software suite dependencies" "${packages[@]}"
echo "------------------------------------------------------------"

# Post-Install Setup
if command -v tldr &>/dev/null; then
    echo "------------------------------------------------------------"
    say "Updating tldr cache..."
    tldr --update || warn "Failed to update tldr cache."
fi

echo "------------------------------------------------------------"
ok "Software installation complete!"
