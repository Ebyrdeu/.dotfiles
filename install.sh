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

header() {
    echo "----------------------------------------"
    say "$1"
    echo "----------------------------------------"
}

safe_source() {
    local script="$1"
    if [[ -f "$script" ]]; then
        say "Sourcing: $(basename "$script")"
        # shellcheck disable=SC1090
        source "$script"
    else
        warn "Script not found, skipping: $script"
    fi
}

# --- Distribution Guardrail ---
if [[ ! -f /etc/fedora-release ]]; then
    err "This script requires Fedora Linux."
    exit 1
fi

DOTFILES_INSTALL="$HOME/.dotfiles/install/fedora"

# ============================================================
# FEDORA INIT SETUP
# ============================================================
header "Starting Fedora Setup"
fedora_init=(
    "$DOTFILES_INSTALL/init/00-base.sh"
    "$DOTFILES_INSTALL/init/00-stow.sh"
    "$DOTFILES_INSTALL/init/01-codecs.sh"
    "$DOTFILES_INSTALL/init/02-base-devel.sh"
    "$DOTFILES_INSTALL/init/03-other-packages.sh"
    "$DOTFILES_INSTALL/init/04-fonts.sh"
    "$DOTFILES_INSTALL/init/05-hostname.sh"
    "$DOTFILES_INSTALL/init/06-bin.sh"
)
for script in "${fedora_init[@]}"; do
    safe_source "$script"
done

# ============================================================
# FEDORA DEVELOPER SETUP
# ============================================================
header "Starting Fedora Developer Setup"
fedora_dev=(
    "$DOTFILES_INSTALL/dev/00-dev-env.sh"
    "$DOTFILES_INSTALL/dev/01-docker.sh"
    "$DOTFILES_INSTALL/dev/02-jetbrains-ide.sh"
    "$DOTFILES_INSTALL/dev/03-code-dir.sh"
)
for script in "${fedora_dev[@]}"; do
    safe_source "$script"
done

# ============================================================
# CLEANUP & FINALIZE
# ============================================================
header "Fedora Post-Install Cleanup"
sudo dnf autoremove -y
sudo dnf clean all

echo "------------------------------------------------------------"
say "Reloading shell configuration..."
set +u
if [[ -f "$HOME/.bashrc" ]]; then
    # shellcheck disable=SC1090
    source "$HOME/.bashrc"
fi
set -u

ok "System setup completed successfully!"
