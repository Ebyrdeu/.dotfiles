#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------------------
# Setup script for a fresh Arch install with either Hyprland (Wayland)
# or i3 (Xorg). Chooses the proper package set based on your selection.
#
# Usage:
#   ./setup.sh hyprland   # non-interactive
#   ./setup.sh i3         # non-interactive
#   ./setup.sh            # interactive menu
# -------------------------------------------------------------------

# ---------- Preconditions ----------
command -v sudo >/dev/null 2>&1 || { echo "This script requires 'sudo'."; exit 1; }
command -v pacman >/dev/null 2>&1 || { echo "This script must run on Arch or Arch-based distros."; exit 1; }

# ---------- Install paru if missing ----------
install_paru() {
  if ! command -v paru >/dev/null 2>&1; then
    echo "📦 Installing paru (AUR helper)..."
    sudo pacman -S --noconfirm --needed base-devel git
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmpdir"
    cd "$tmpdir"
    makepkg -si --noconfirm
    cd -
    rm -rf "$tmpdir"
  else
    echo "✅ paru already installed."
  fi
}

# ---------- Helpers ----------
is_installed() { pacman -Q "$1" >/dev/null 2>&1; }
in_official_repos() { pacman -Si "$1" >/dev/null 2>&1; }

install_package_pacman() {
  echo "📦 Installing $1 from official repositories..."
  sudo pacman -S --noconfirm --needed "$1"
}

install_package_paru() {
  echo "📦 Installing $1 from AUR via paru..."
  paru -S --noconfirm --needed "$1"
}

install_pkg() {
  local pkg="$1"
  if is_installed "$pkg"; then
    echo "✅ [$pkg] already installed."
  else
    if in_official_repos "$pkg"; then
      install_package_pacman "$pkg"
    else
      install_package_paru "$pkg"
    fi
    echo "$pkg ---- 完全"
  fi
}

install_hy3_plugin() {
  echo "🔌 Installing hy3 plugin via hyprpm..."
  if command -v hyprpm >/dev/null 2>&1; then
    hyprpm add https://github.com/outfoxxed/hy3 || true
    hyprpm update
    hyprpm enable hy3
    echo "✅ hy3 plugin installed and enabled."
  else
    echo "⚠️  hyprpm not found. Skipping hy3 plugin. (Ensure Hyprland is installed correctly.)"
  fi
}

# ---------- Package Sets ----------

# Common packages (both Wayland and Xorg)
packages_common=(
  # Fonts
  adobe-source-han-sans-jp-fonts
  adobe-source-han-serif-jp-fonts
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd

  # System & CLI tools
  bash-completion
  btop
  brightnessctl
  pavucontrol
  stow
  unzip
  zip
  network-manager-applet
  gnome-keyring
  wireplumber
  rsync

  # GUI Applications
  chromium
  firefox
  telegram-desktop
  youtube-music-bin   # AUR
  qbittorrent
)

# Wayland / Hyprland specific
packages_wayland=(
  hyprland
  hyprsunset
  rofi-wayland
  waybar
  wl-clipboard
  xdg-desktop-portal-hyprland
  slurp
  grim
)

# Xorg / i3 specific
packages_xorg=(
  i3-wm
  i3status
  i3blokcs
  rofi
  arandr
  xorg-server
  xorg-xrandr
  xclip
  xorg-xprop
  xkblayout
  xorg-xwininfo
  redshift
)

# ---------- Install paru first ----------
install_paru

# ---------- Choice ----------
choice="${1:-}"

if [[ -z "$choice" ]]; then
  echo "Select Window Manager:"
  select opt in "Hyprland (Wayland)" "i3 (Xorg)"; do
    case $REPLY in
      1) choice="hyprland"; break ;;
      2) choice="i3"; break ;;
      *) echo "Invalid choice."; ;;
    esac
  done
else
  choice="$(echo "$choice" | tr '[:upper:]' '[:lower:]')"
  if [[ "$choice" != "hyprland" && "$choice" != "i3" ]]; then
    echo "Usage: $0 [hyprland|i3]"
    exit 1
  fi
fi

echo "----------------------------------------"
echo "🛠  Preparing install for: $choice"
echo "----------------------------------------"

# ---------- Build final package list ----------
packages=("${packages_common[@]}")
if [[ "$choice" == "hyprland" ]]; then
  packages+=("${packages_wayland[@]}")
elif [[ "$choice" == "i3" ]]; then
  packages+=("${packages_xorg[@]}")
fi

# ---------- Install ----------
for pkg in "${packages[@]}"; do
  install_pkg "$pkg" || true
done

# ---------- Post steps ----------
if [[ "$choice" == "hyprland" ]]; then
  install_hy3_plugin
fi

echo "✅ Done."
