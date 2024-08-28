#!/bin/bash

# List of packages to install
packages=("stow" "fzf" "ripgrep" "zellij" "neovim")

# URL of the JetBrains Mono font
font_url="https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
font_dir="$HOME/.local/share/fonts"
font_zip="$HOME/JetBrainsMono.zip"

# Directory of the .dotfiles repo
dotfiles_dir="$HOME/.dotfiles"

# Directory for code projects
code_dir="$HOME/code"

# Function to check if a package is installed
is_installed() {
    yay -Qs $1 > /dev/null 2>&1
}

# Function to install a package
install_package() {
    echo "Installing $1..."
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

# Function to stow dotfiles with replacement
stow_dotfiles() {
    echo "Stowing dotfiles from $dotfiles_dir..."
    
    cd $dotfiles_dir

    # Stow each directory in the .dotfiles folder with --restow to replace existing files
    for dir in $(ls -d */); do
        stow -v --restow --target=$HOME $dir
    done

    echo "Dotfiles successfully stowed and replaced existing files where necessary."
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
    if is_installed $package; then
        echo "$package is already installed."
    else
        install_package $package
    fi
done

# Install JetBrains Mono font
install_fonts

# Stow dotfiles with replacement
stow_dotfiles

# Create code directory
create_code_directory

echo "All packages, fonts, dotfiles, and directories are set up."
