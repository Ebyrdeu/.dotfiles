#!/bin/bash

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/.dotfiles"

sudo dnf install -y stow

for file in ".bashrc" ".bash_profile"; do
    if [ -f "$HOME/$file" ]; then
        echo "Removing existing $HOME/$file"
        rm "$HOME/$file"
    fi
done

# Kde
for file in "kglobalshortcutsrc" "kwinrulesrc" "konsolerc"; do
    if [ -f "$CONFIG_DIR/$file" ]; then
        echo "Removing existing $CONFIG_DIR/$file"
        rm "$CONFIG_DIR/$file"
    fi
done

echo "Stowing dotfiles to $HOME"
cd "$DOTFILES_DIR" || exit

stow --ignore="config/(i3|paru|rofi|hypr|waybar|alacritty|dunst)" .

echo "Done! Your environment is set up"
