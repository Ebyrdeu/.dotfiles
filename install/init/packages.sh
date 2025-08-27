#!/bin/bash

packages=(
  # Fonts
  adobe-source-han-sans-jp-fonts
  adobe-source-han-serif-jp-fonts
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd

  # System & CLI tools
  avahi
  bash-completion
  blueberry
  btop
  brightnessctl
  curl
  gnome-keyring
  impala
  iwd
  pavucontrol
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
  tldr

  # Graphics / Video
  gst-libav
  gst-plugins-bad
  gst-plugins-base
  gst-plugins-good
  gst-plugins-ugly
  gstreamer
  libva-mesa-driver
  mesa-vdpau
  vulkan-intel

  # Web / GTK
  webkit2gtk
  webkit2gtk-4.1

  # Containers
  docker
  docker-buildx
  docker-compose
  ufw-docker

  # CLI tools
  fd
  fzf

  # GUI Applications
  chromium
  firefox
  mpv
  qbittorrent
  telegram-desktop-bin
  youtube-music-bin
)


for pkg in "${packages[@]}"; do
    echo " Installing $pkg"
    if pacman -Si "$pkg" &>/dev/null; then
        sudo pacman -S --noconfirm --needed "$pkg"
    else
        source ~/.dotfiles/install/init/paru.sh
        paru -S --noconfirm --needed "$pkg"
    fi
done
