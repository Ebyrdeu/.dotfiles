#!/bin/bash

packages=(
  # Fonts
  adobe-source-han-sans-jp-fonts
  adobe-source-han-serif-jp-fonts
  noto-fonts-cjk
  otf-ipaexfont
  ttf-mplus-git
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd

  # Keyboard
  fcitx5-mozc
  fcitx5-gtk

  # System & CLI tools
  avahi
  bash-completion
  blueberry
  btop
  brightnessctl
  curl
  gnome-keyring
  iwd
  pavucontrol
  power-profiles-daemon
  rsync
  stow
  tldr
  ufw
  unzip
  wget
  wireplumber

  # Printers
  cups
  cups-browsed
  cups-filters
  cups-pdf
  nss-mdns
  polkit-gnome
  system-config-printer

  # Core system / build tools
  alacritty
  base-devel
  cmake
  cpio
  gcc
  lld
  llvm
  meson
  neovim
  pkg-config
  ripgrep
  tmux
  zip
  unzip
  7zip

  # Graphics / Video
  gst-libav
  gst-plugins-bad
  gst-plugins-base
  gst-plugins-good
  gst-plugins-ugly

  # Containers
  docker
  docker-buildx
  docker-compose
  ufw-docker

  # CLI tools
  fd
  fzf
  impala

  # GUI Applications
  chromium
  firefox
  mpv
  qbittorrent
  telegram-desktop-bin
)

# Install packages
for pkg in "${packages[@]}"; do
    echo "Installing $pkg..."
    if pacman -Si "$pkg" &>/dev/null; then
        sudo pacman -S --noconfirm --needed "$pkg"
    else
        paru -S --noconfirm --needed "$pkg"
    fi
done
