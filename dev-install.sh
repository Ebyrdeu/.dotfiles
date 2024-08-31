#!/bin/bash
# 
packages=(
	"stow" 
	"fd" 
	"proximity-sort"
	"fzf" 
	"ripgrep" 
	"zellij" 
	"neovim" 
	"alacritty"
	"go"
	"nodejs"
	"docker"
	"docker-buildx"
	"docker-compose"
)

# Directory for code projects
code_dir="$HOME/code"

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

# Function to install SDKMAN
install_sdkman() {
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "Installing SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
    else
        echo "SDKMAN is already installed."
    fi
}

# Function to install Rust using rustup
install_rust() {
    if ! command -v rustup &> /dev/null; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    else
        echo "Rust is already installed."
    fi
}

# Function to create code directory if it doesn't exist
create_code_directory() {
    if [ ! -d "$code_dir" ]; then
        echo "Creating code directory at $code_dir..."
        mkdir -p $code_dir
    else
        echo "Code directory already exists at $code_dir."
    fi
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

# Install SDKMAN
install_sdkman

# Install Rust
install_rust

# Create code directory
create_code_directory

echo "Done"
