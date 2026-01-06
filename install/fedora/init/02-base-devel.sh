#!/bin/bash

sudo dnf install @c-development
sudo dnf install @development-libs
sudo dnf install @development-tools

packages=(
sqlite-devel
qt6-qtbase-devel
qt6-qtsvg-devel
webkit2gtk4.1-devel
json-devel
json-c-devel
libzip-devel
vlc-devel
mpv-devel
mpv-libs
cmake
meson
lld
llvm
)

echo "Installing packages..."
sudo dnf install -y "${packages[@]}"
