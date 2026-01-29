#!/bin/bash

packages=(
tldr
fcitx5
fcitx5-mozc
tmux
neovim
mpv
qbittorrent
telegram-desktop
thunderbird
)

echo "Installing packages..."
sudo dnf install -y "${packages[@]}"
