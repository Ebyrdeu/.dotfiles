#!/usr/bin/env bash
set -euo pipefail

# Colors
C_RESET='\033[0m'
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_ERR='\033[0;31m'
C_HEAD='\033[1;36m'

# Helpers
say()  { printf "%b[INFO]%b %s\n" "$C_HEAD" "$C_RESET" "$*"; }
ok()   { printf "%b[OK]%b %s\n" "$C_OK"   "$C_RESET" "$*"; }
warn() { printf "%b[WARN]%b %s\n" "$C_WARN" "$C_RESET" "$*"; }
err()  { printf "%b[ERR]%b %s\n" "$C_ERR"  "$C_RESET" "$*" >&2; }

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
    libXt-devel
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

say "Checking development environment packages and toolchains..."

to_install=()
for pkg in "${packages[@]}"; do
    if [[ "$pkg" == @* ]]; then
        # Check dnf group installation state
        local group_name="${pkg#@}"
        if ! dnf group summary "$group_name" 2>/dev/null | grep -q "Installed Groups"; then
            to_install+=("$pkg")
        fi
    else
        # Check individual RPM package installation state
        if ! rpm -q "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    fi
done

if [[ ${#to_install[@]} -gt 0 ]]; then
    say "Installing header libraries and toolchains: ${to_install[*]}"
    if sudo dnf install -y "${to_install[@]}"; then
        echo "------------------------------------------------------------"
        ok "Development environment is now fully provisioned."
    else
        err "Failed to install some development dependencies."
        exit 1
    fi
else
    echo "------------------------------------------------------------"
    ok "All development libraries and toolchains are already installed."
fi
