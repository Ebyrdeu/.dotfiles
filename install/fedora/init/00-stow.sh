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

echo "Stowing dotfiles to $HOME"
cd "$DOTFILES_DIR" || exit

stow .

echo "Done! Your environment is set up"
