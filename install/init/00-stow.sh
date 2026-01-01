#!/bin/bash

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/.dotfiles"

if [ -d "$CONFIG_DIR" ]; then
    echo "Refreshing .config directory..."
    rm -rf "$CONFIG_DIR"
fi
mkdir -p "$CONFIG_DIR"

if [ -d "$DOTFILES_DIR/config" ]; then
    echo "Stowing config package to ~/.config..."
    stow -v -t "$HOME/.config" -d "$DOTFILES_DIR" config
fi

echo "Removing existing bash startup files..."
rm -f "$HOME/.bashrc"
rm -f "$HOME/.bash_profile"

echo "Stowing all other packages to $HOME..."
cd "$DOTFILES_DIR" || exit

stow .

echo "Done! Your environment is set up."