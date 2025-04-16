#!/bin/bash

# setup script for fresh install arch using i3wm
packages=(
	"ly"
	"ttf-jetbrains-mono"
	"ttf-jetbrains-mono-nerd"
	"adobe-source-han-sans-jp-fonts"
	"adobe-source-han-serif-jp-fonts"
	"fcitx5-im"
	"fcitx5-mozc"
	"rofi"
	"brightnessctl"
	"xclip"
	"xprop"
	"xorg-xwininfo"
	"redshift"
	"btop"
	"yazi"
	"gnome-keyring"
	"telegram-desktop"
	"youtube-music-bin"
	"chromium"
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

echo "Done"
