#!/bin/bash

if ! command -v paru >/dev/null 2>&1; then
  echo "  Installing paru (AUR helper)..."
  sudo pacman -S --noconfirm --needed base-devel git
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$tmpdir"
  cd "$tmpdir"
  makepkg -si --noconfirm
  cd -
  rm -rf "$tmpdir"
else
  echo " paru already installed."
fi
