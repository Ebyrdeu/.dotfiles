#!/bin/bash

# setup script for fresh install arch using hyprland
packages=(
    # Fonts
    "adobe-source-han-sans-jp-fonts"
    "adobe-source-han-serif-jp-fonts"
    "ttf-jetbrains-mono"
    "ttf-jetbrains-mono-nerd"

    # System & CLI tools
	"bash-completion"
    "btop"
    "brightnessctl"
    "hyprsunset"
    "pavucontrol"
    "rofi-wayland"
    "stow"
    "unzip"
    "waybar"
    "wl-clipboard"
    "zip"
    "network-manager-applet"
    "gnome-keyring"
    "wireplumber"
    "xdg-desktop-portal-hyprland"
    "slurp"
    "grim" 
    "rsync"

    # GUI Applications
	"arandr"
    "chromium"
	"firefox"
    "telegram-desktop"
    "youtube-music-bin"
    "qbittorrent"
)

# Function to check if a package is installed
is_installed() {
    pacman -Q "$1" >/dev/null 2>&1
}

# Function to install a package using pacman
install_package_pacman() {
    echo "Installing $1 from official repositories..."
    sudo pacman -S --noconfirm "$1"
}

# Function to install a package using yay (AUR)
install_package_yay() {
    echo "Installing $1 from AUR..."
    yay -S --noconfirm "$1"
}

install_hy3_plugin() {
    echo "Installing hy3 plugin via hyprpm..."
    if command -v hyprpm >/dev/null 2>&1; then
        hyprpm add https://github.com/outfoxxed/hy3
        hyprpm update
        hyprpm enable hy3
        echo "hy3 plugin installed and updated successfully."
    else
        echo "Error: hyprpm not found. Make sure Hyprland is installed correctly."
        exit 1
    fi
}

# Loop through the list of packages and install if not already installed
for package in "${packages[@]}"; do
    if is_installed "$package"; then
        echo "[$package] - is already installed."
    else
        if pacman -Si "$package" >/dev/null 2>&1; then
            install_package_pacman "$package"
        else
            install_package_yay "$package"
        fi
        echo "$package ---- 完全"
    fi
done

install_hy3_plugin

echo "Done"
