#!/usr/bin/env bash
set -eEo pipefail

# --- Colors & UI ---
C_HEAD='\033[1;36m'
C_ITEM='\033[1;34m'
C_LABEL='\033[1;32m'
C_RESET='\033[0m'

header() {
    echo -e "${C_HEAD}----------------------------------------${C_RESET}"
    echo -e "${C_HEAD} $1 ${C_RESET}"
    echo -e "${C_HEAD}----------------------------------------${C_RESET}"
}

# --- Distribution Detection ---
if [[ -f /etc/arch-release ]]; then
    DISTRO="arch"
elif [[ -f /etc/fedora-release ]]; then
    DISTRO="fedora"
else
    echo "Distribution not automatically detected."
    echo "1) Arch Linux"
    echo "2) Fedora"
    read -rp "Select [1-2]: " choice
    case $choice in
        1) DISTRO="arch" ;;
        2) DISTRO="fedora" ;;
        *) echo "Invalid choice. Exiting."; exit 1 ;;
    esac
fi

# ============================================================
# ARCH LINUX LOGIC
# ============================================================
if [[ "$DISTRO" == "arch" ]]; then
    header " Starting Arch Initial Setup"
    source ~/.dotfiles/install/arch/init/00-stow.sh
    source ~/.dotfiles/install/arch/init/01-paru.sh
    source ~/.dotfiles/install/arch/init/02-pacman.sh
    source ~/.dotfiles/install/arch/init/03-packages.sh

    header "󰵮 Starting Developer Setup"
    source ~/.dotfiles/install/arch/dev/00-dev-env.sh
    source ~/.dotfiles/install/arch/dev/01-docker.sh
    source ~/.dotfiles/install/arch/dev/02-jetbrains-idea.sh
    source ~/.dotfiles/install/arch/dev/03-clion.sh
    source ~/.dotfiles/install/arch/dev/04-code-dir.sh
    source ~/.dotfiles/install/arch/dev/05-gpg.sh

    header "󰹑 Starting WM Setup"
    source ~/.dotfiles/install/arch/wm/00-wm.sh

    header "󰻠 Starting System Setup"
    source ~/.dotfiles/install/arch/system/00-network.sh
    source ~/.dotfiles/install/arch/system/01-bluetooth.sh
    source ~/.dotfiles/install/arch/system/02-firewall.sh
    source ~/.dotfiles/install/arch/system/03-printer.sh
    source ~/.dotfiles/install/arch/system/04-ssh-flakiness.sh
    source ~/.dotfiles/install/arch/system/05-usb-autosuspend.sh
    source ~/.dotfiles/install/arch/system/06-applications.sh

    header "󱘷 Post-Install Cleanup"
    sudo pacman -Rns $(pacman -Qtdq) || echo "No orphaned packages to remove."
    sudo pacman -Sc --noconfirm

elif [[ "$DISTRO" == "fedora" ]]; then
    header " Starting Fedora Setup"
    source ~/.dotfiles/install/fedora/init/00-base.sh
    source ~/.dotfiles/install/fedora/init/00-stow.sh
    source ~/.dotfiles/install/fedora/init/01-codecs.sh
    source ~/.dotfiles/install/fedora/init/02-base-devel.sh
    source ~/.dotfiles/install/fedora/init/03-other-packages.sh
    source ~/.dotfiles/install/fedora/init/04-fonts.sh
    source ~/.dotfiles/install/fedora/init/05-hostname.sh
    source ~/.dotfiles/install/fedora/init/06-bin.sh

    header "󰵮 Starting Fedora Developer Setup"
    source ~/.dotfiles/install/fedora/dev/00-dev-env.sh
    source ~/.dotfiles/install/fedora/dev/01-docker.sh
    source ~/.dotfiles/install/fedora/dev/02-jetbrains-idea.sh
    source ~/.dotfiles/install/fedora/dev/03-clion.sh
    source ~/.dotfiles/install/fedora/dev/04-code-dir.sh

    header "󱘷 Fedora Post-Install Cleanup"
    sudo dnf autoremove -y
    sudo dnf clean all
fi

# --- Finalize ---
echo -e "\n${C_HEAD}Reloading configuration...${C_RESET}"
set +u
source ~/.bashrc
set -u
echo -e "${C_LABEL}Done! System is ready.${C_RESET}"
