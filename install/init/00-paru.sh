#!/bin/bash

if ! command -v paru >/dev/null 2>&1; then
    echo "Installing paru..."
    sudo pacman -S --noconfirm --needed base-devel git
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmpdir"
    cd "$tmpdir" || exit
    makepkg -si --noconfirm
    cd - >/dev/null || exit
    rm -rf "$tmpdir"
    echo "paru installed successfully."
else
    echo "paru is already installed."
fi
