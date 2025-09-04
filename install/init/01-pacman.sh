#!/bin/bash

echo "Copying pacman configuration..."
sudo cp ~/.dotfiles/install/init/pacman/pacman.conf /etc/pacman.conf
echo "✓ pacman.conf copied to /etc/pacman.conf"
sudo cp ~/.dotfiles/install/init/pacman/mirrorlist /etc/pacman.d/mirrorlist
echo "✓ mirrorlist copied to /etc/pacman.d/mirrorlist"
echo "Pacman configuration updated."
