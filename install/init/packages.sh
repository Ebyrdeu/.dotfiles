#!/bin/bash

packages=(
  # Fonts
  adobe-source-han-sans-jp-fonts
  adobe-source-han-serif-jp-fonts
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd

  # System & CLI tools
  networkmanager
  thunar
  bash-completion
  btop
  brightnessctl
  pavucontrol
  stow
  unzip
  zip
  gnome-keyring
  wireplumber
  rsync
  curl
  wget
  tldr

  # Core system / build tools
  alacritty
  base-devel
  cmake
  meson
  cpio
  pkg-config
  gcc
  go
  neovim
  nvm
  ripgrep
  tmux
  tldr
  llvm
  lld

  # Graphics / Video
  gstreamer
  gst-plugins-base
  gst-plugins-good
  gst-plugins-bad
  gst-plugins-ugly
  gst-libav
  libva-mesa-driver
  mesa-vdpau
  vulkan-intel

  # Web / GTK
  webkit2gtk-4.1
  webkit2gtk

  # Containers
  docker
  docker-buildx
  docker-compose

  # CLI tools
  fd
  fzf

  # GUI Applications
  chromium
  firefox
  telegram-desktop-bin
  youtube-music-bin
  qbittorrent
  mpv
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
