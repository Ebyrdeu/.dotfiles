#!/bin/bash
# Simple cache cleanup script for Arch Linux using paru

echo "Starting system cache cleanup..."

# Remove pacman package cache except for the latest 3 versions
echo "Cleaning pacman cache..."
sudo paccache -r

# Remove orphaned packages
echo "Removing orphaned packages..."
sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null

# Remove AUR build cache (for paru)
echo "Cleaning paru build cache..."
paru -Sc --noconfirm

# Optional: clean temporary files in /tmp
echo "Cleaning temporary files..."
sudo rm -rf /tmp/*

echo "Cache cleanup completed!"
