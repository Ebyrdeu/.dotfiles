#!/bin/bash

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/.dotfiles"

sudo dnf install stow

echo "Stowing dotfiles to $HOME "
cd "$DOTFILES_DIR" || exit

# --ignore=".bashrc|.bash_profile" tells stow to skip these files
# We also ignore 'config' here since it was handled above
stow -v --ignore=".bashrc|.bash_profile" .

echo "Done! Your environment is set up"