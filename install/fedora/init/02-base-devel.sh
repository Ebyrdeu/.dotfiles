#!/usr/bin/env bash
set -euo pipefail

C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_RESET='\033[0m'

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }


packages=(
  @c-development
  @development-libs
  @development-tools
  cmake
  clang
  clang-tools-extra
  fdk-aac-devel
  fontconfig-devel
  freetype-devel
  fribidi-devel
  glslang-devel
  json-c-devel
  json-devel
  lame-devel
  lcms2-devel
  libdovi-devel
  libffi-devel
  libshaderc-devel
  libunwind-devel
  libzip-devel
  lld
  llvm
  meson
  mpv-devel
  mpv-libs
  mysql-devel
  nasm
  nodejs-bash-language-server
  openssl-devel
  qt6-qtbase-devel
  qt6-qtsvg-devel
  SDL2-devel
  SDL2_image-devel
  SDL2_mixer-devel
  SDL2_net-devel
  SDL2_sound-devel
  spirv-headers-devel
  spirv-tools-devel
  sqlite-devel
  twolame-devel
  vlc-devel
  vulkan-headers
  vulkan-loader-devel
  webkit2gtk4.1-devel
  x264-devel
  xxhash-devel
  xz-devel
)

say "Installing Header Libraries and Toolchains..."
sudo dnf install -y "${packages[@]}"

echo -e "${C_OK}------------------------------------------------${C_RESET}"
echo -e "Development environment is now fully provisioned."
echo -e "${C_OK}------------------------------------------------${C_RESET}"
