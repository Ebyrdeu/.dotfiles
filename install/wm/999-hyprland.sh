#!/bin/bash


# Wayland package list
packages_wayland=(
  hyprland
  hyprsunset
  hyprlock
  hypridle
  rofi
  waybar
  wl-clipboard
  xdg-desktop-portal-hyprland
  slurp
  grim
  uwsm
  libnewt
  dunst
)


echo "Installing Hyprland packages..."
sudo pacman -S --noconfirm --needed "${packages_wayland[@]}"
echo "Hyprland environment setup complete."

# Ask about hy3 plugin
read -p "Install hy3 plugin via hyprpm? [Y/n]: " install_hy3
install_hy3=${install_hy3:-Y}

if [[ "$install_hy3" =~ ^[Yy]$ ]]; then
    if command -v hyprpm >/dev/null 2>&1; then
        echo "Installing hy3 plugin..."
        hyprpm add https://github.com/outfoxxed/hy3 || true
        hyprpm update -f
        hyprpm enable hy3
        echo "hy3 plugin installed and enabled."
    else
        echo "hyprpm not found. Skipping hy3 plugin. (Ensure Hyprland is installed.)"
    fi
else
    echo "Skipped hy3 plugin installation."
fi
