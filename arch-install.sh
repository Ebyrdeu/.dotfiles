#!/bin/bash

# setup script for fresh install arch using i3wm
packages=(
	"i3blocks"
	"rofi"
	"brightnessctl"
	"xkblayout"
	"xwininfo"
	"redshift"
	"gnome-keyring"
	"telegram-desktop"
	"youtube-music-bin"
	"chromium"
)

# URL of the JetBrains Mono font
font_url="https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
font_dir="$HOME/.local/share/fonts"
font_zip="$HOME/JetBrainsMono.zip"

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


# Function to download and unpack JetBrains Mono font
install_fonts() {
    echo "Downloading JetBrains Mono fonts..."
    curl -L -o $font_zip $font_url
    
    echo "Unpacking fonts to $font_dir..."
    mkdir -p $font_dir
    unzip -o $font_zip -d $font_dir
    
    echo "Updating font cache..."
    fc-cache -fv
    
    echo "Cleaning up..."
    rm $font_zip
}

# Loop through the list of packages and install if not already installed
for package in "${packages[@]}"; do
    if is_installed_pacman $package || is_installed_yay $package; then
        echo "$package is already installed."
    else
        if pacman -Si $package > /dev/null 2>&1; then
            install_package_pacman $package
        else
            install_package_yay $package
        fi
        echo "$package ---- 完全"
    fi
done


# Install JetBrains Mono font
install_fonts

echo "Done"
