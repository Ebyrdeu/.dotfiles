#!/bin/bash

set -eEo pipefail

# --- New Function: Check OS ---
ask_distro() {
    echo "Select your distribution:"
    echo "1) Arch Linux"
    echo "2) Fedora"
    read -p "Enter choice [1-2]: " distro_choice

    case $distro_choice in
        1) DISTRO="arch" ;;
        2) DISTRO="fedora" ;;
        *) echo "Invalid choice. Exiting."; exit 1 ;;
    esac
}

ask_install() {
    local section="$1"
    read -p "Do you want to install $section? [Y/n]: " answer
    answer=${answer:-Y}
    [[ "$answer" =~ ^[Yy]$ ]]
}

# Run the distro check
ask_distro

# --- Arch Logic (Your existing code) ---
if [[ "$DISTRO" == "arch" ]]; then
    echo "----------------------------------------"
    echo " Starting Arch Initial setup"
    echo "----------------------------------------"
    if ask_install "Initial setup"; then
        source ~/.dotfiles/install/arch/init/00-stow.sh
        source ~/.dotfiles/install/arch/init/01-paru.sh
        source ~/.dotfiles/install/arch/init/02-pacman.sh
        source ~/.dotfiles/install/arch/init/03-packages.sh
    fi

    echo "----------------------------------------"
    echo "󰵮 Starting developer setup"
    echo "----------------------------------------"
    if ask_install "Developer setup"; then
        source ~/.dotfiles/install/arch/dev/00-dev-env.sh
        source ~/.dotfiles/install/arch/dev/01-docker.sh
        source ~/.dotfiles/install/arch/dev/02-jetbrains-idea.sh
        source ~/.dotfiles/install/arch/dev/03-clion.sh
        source ~/.dotfiles/install/arch/dev/04-code-dir.sh
        source ~/.dotfiles/install/arch/dev/05-gpg.sh
    fi

    echo "----------------------------------------"
    echo "󰹑 Starting WM setup"
    echo "----------------------------------------"
    if ask_install "WM setup"; then
        source ~/.dotfiles/install/arch/wm/00-wm.sh
    fi

    echo "----------------------------------------"
    echo "󰻠 Starting System setup"
    echo "----------------------------------------"
    if ask_install "System setup"; then
        source ~/.dotfiles/install/arch/system/00-network.sh
        source ~/.dotfiles/install/arch/system/01-bluetooth.sh
        source ~/.dotfiles/install/arch/system/02-firewall.sh
        source ~/.dotfiles/install/arch/system/03-printer.sh
        source ~/.dotfiles/install/arch/system/04-ssh-flakiness.sh
        source ~/.dotfiles/install/arch/system/05-usb-autosuspend.sh
        source ~/.dotfiles/install/arch/system/06-applications.sh
    fi

    echo "----------------------------------------"
    echo "󱘷 Post install setup"
    echo "----------------------------------------"
    echo "Cleaning caches..."
    # Only run these if pacman is actually available/needed
    sudo pacman -Rns $(pacman -Qtdq) || echo "No orphaned packages to remove."
    sudo pacman -Sc --noconfirm
    sudo pacman -Scc --noconfirm
    sudo du -sh ~/.cache/

elif [[ "$DISTRO" == "fedora" ]]; then
    echo "----------------------------------------"
    echo " Starting Fedora Setup"
    echo "----------------------------------------"
        source ~/.dotfiles/install/fedora/init/00-base.sh
        source ~/.dotfiles/install/fedora/init/00-stow.sh
        source ~/.dotfiles/install/fedora/init/01-codecs.sh
        source ~/.dotfiles/install/fedora/init/02-base-devel.sh
        source ~/.dotfiles/install/fedora/init/03-other-packages.sh
        source ~/.dotfiles/install/fedora/init/04-fonts.sh
        source ~/.dotfiles/install/fedora/dev/00-dev-env.sh
        source ~/.dotfiles/install/fedora/dev/01-docker.sh
        source ~/.dotfiles/install/fedora/dev/02-jetbrains-idea.sh
        source ~/.dotfiles/install/fedora/dev/03-clion.sh
        source ~/.dotfiles/install/fedora/dev/04-code-dir.sh
    echo "----------------------------------------"
       echo "󱘷 Fedora Post-install Cleaning"
       echo "----------------------------------------"
       sudo dnf autoremove -y
       sudo dnf clean all
fi

echo "Reloading bash configuration..."
source ~/.bashrc