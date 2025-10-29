#!/bin/bash

set -eEo pipefail

ask_install() {
    local section="$1"
    read -p "Do you want to install $section? [Y/n]: " answer
    answer=${answer:-Y}
    [[ "$answer" =~ ^[Yy]$ ]]
}

echo "----------------------------------------"
echo " Starting Initial setup"
echo "----------------------------------------"
if ask_install "Initial setup"; then
    source ~/.dotfiles/install/init/00-paru.sh
    source ~/.dotfiles/install/init/01-pacman.sh
    source ~/.dotfiles/install/init/02-packages.sh
fi

echo "----------------------------------------"
echo "󰵮 Starting developer setup"
echo "----------------------------------------"
if ask_install "Developer setup"; then
    source ~/.dotfiles/install/dev/00-dev-env.sh
    source ~/.dotfiles/install/dev/01-docker.sh
    source ~/.dotfiles/install/dev/02-jetbrains-idea.sh
    source ~/.dotfiles/install/dev/03-clion.sh
    source ~/.dotfiles/install/dev/04-code-dir.sh
    source ~/.dotfiles/install/dev/05-gpg.sh
fi

echo "----------------------------------------"
echo "󰹑 Starting WM setup"
echo "----------------------------------------"
if ask_install "WM setup"; then
    source ~/.dotfiles/install/wm/00-wm.sh
fi

echo "----------------------------------------"
echo "󰻠 Starting System setup"
echo "----------------------------------------"
if ask_install "System setup"; then
    source ~/.dotfiles/install/system/00-network.sh
    source ~/.dotfiles/install/system/01-bluetooth.sh
    source ~/.dotfiles/install/system/02-firewall.sh
    source ~/.dotfiles/install/system/03-printer.sh
    source ~/.dotfiles/install/system/04-ssh-flakiness.sh
    source ~/.dotfiles/install/system/05-usb-autosuspend.sh
fi

echo "----------------------------------------"
echo "󱘷 Post install setup"
echo "----------------------------------------"
echo "Cleaning caches..."
paru -Sc

echo "Reloading bash configuration..."
source ~/.bashrc