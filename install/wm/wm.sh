#!/bin/bash

# Define package lists
packages_wayland=(
  hyprland
  hyprsunset
  hyprlock
  hypridle
  rofi-wayland
  waybar
  wl-clipboard
  xdg-desktop-portal-hyprland
  slurp
  grim
  uwsm
  libnewt
)

packages_xorg=(
  i3-wm
  i3status
  i3blocks
  rofi
  brightnessctl
  upower
  arandr
  xorg-server
  xorg-xrandr
  xclip
  xorg-xprop
  xkblayout
  xorg-xwininfo
  redshift
)

echo "Which environment do you want to install?"
echo "1) Hyprland (Wayland)"
echo "2) i3 (Xorg)"
echo "3) Skip installation [default]"
read -p "Enter 1, 2, or 3: " choice

if [[ -z "$choice" || "$choice" == "3" ]]; then
    echo "⏩ Skipping installation."
elif [[ "$choice" == "1" ]]; then
    env_choice="Wayland"
    packages_to_install=("${packages_wayland[@]}")
    packages_to_remove=("${packages_xorg[@]}")
elif [[ "$choice" == "2" ]]; then
    env_choice="Xorg"
    packages_to_install=("${packages_xorg[@]}")
    packages_to_remove=("${packages_wayland[@]}")
else
    echo "❌ Invalid choice, skipping environment setup."
    env_choice=""
fi

if [[ -n "$env_choice" ]]; then
    # Confirm before installing
    read -p "⚠️  You chose $env_choice. Proceed with installation? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Install the selected packages
        echo "  Installing $env_choice packages…"
        sudo pacman -S --noconfirm --needed "${packages_to_install[@]}"

        # Ask if user wants to remove the other environment packages
        read -p "Do you want to remove the other environment packages? [y/N]: " remove_choice
        if [[ "$remove_choice" =~ ^[Yy]$ ]]; then
            echo "󱂥 Removing other environment packages…"
            sudo pacman -Rns --noconfirm "${packages_to_remove[@]}" || true
        else
            echo "⏩ Keeping the other environment packages."
        fi

        echo " $env_choice environment setup complete!"
    else
        echo "❌ Installation cancelled."
    fi
fi
