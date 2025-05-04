#!/bin/bash

# setup script for fresh install arch using i3wm
packages=(
    # Fonts
    "adobe-source-han-sans-jp-fonts"
    "adobe-source-han-serif-jp-fonts"
    "ttf-jetbrains-mono"
    "ttf-jetbrains-mono-nerd"

    # System & CLI tools
    "btop"
    "brightnessctl"
    "git"
    "hyprsunset"
    "pavucontrol"
    "rofi-wayland"
    "stow"
    "unzip"
    "waybar"
    "wl-clipboard"
    "zip"

    # GUI Applications
    "chromium"
    "telegram-desktop"
    "youtube-music-bin"
	"qbittorrent"
)

# Function to check if a package is installed via pacman
is_installed_pacman() {
    pacman -Qi $1 > /dev/null 2>&1
}

# Function to check if a package is installed via yay (AUR)
is_installed_yay() {
    yay -Qs $1 > /dev/null 2>&1
}

# Function to install a package using pacman
install_package_pacman() {
    echo "Installing $1 from official repositories..."
    sudo pacman -S --noconfirm $1
}

# Function to install a package using yay (AUR)
install_package_yay() {
    echo "Installing $1 from AUR..."
    yay -S --noconfirm $1
}

install_hy3_plugin() {
    echo "Installing hy3 plugin via hyprpm..."
    if command -v hyprpm >/dev/null 2>&1; then
        hyprpm add https://github.com/outfoxxed/hy3
        hyprpm update
        echo "hy3 plugin installed and updated successfully."
    else
        echo "Error: hyprpm not found. Make sure Hyprland is installed correctly."
        exit 1
    fi
}


# Loop through the list of packages and install if not already installed
for package in "${packages[@]}"; do
    if is_installed_pacman $package || is_installed_yay $package; then
		echo "[$package] - is already installed."
    else
        if pacman -Si $package > /dev/null 2>&1; then
            install_package_pacman $package
        else
            install_package_yay $package
        fi
        echo "$package ---- 完全"
    fi
done

install_hy3_plugin

echo "Done"
