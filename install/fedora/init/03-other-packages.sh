#!/bin/bash

packages=(
tldr
fcitx5
fcitx5-mozc
alacritty
tmux
neovim
mpv
qbittorrent
telegram-desktop
)

echo "Installing packages..."
sudo dnf install -y "${packages[@]}"