#!/bin/bash

# i3/Xorg package list
packages_i3=(
  i3-wm
  i3status
  i3blocks
  rofi
  brightnessctl
  arandr
  xorg-server
  xorg-xrandr
  xclip
  xorg-xprop
  xkblayout
  xorg-xwininfo
  redshift
)

echo "Installing i3 packages..."
sudo pacman -S --noconfirm --needed "${packages_i3[@]}"
echo "i3 environment setup complete."