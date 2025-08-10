#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------------------
# Dev workstation setup for Arch Linux
# - Uses paru for AUR packages (installs it if missing)
# - Installs core toolchains, graphics/video stacks, containers, CLIs
# - Creates ~/code
# - Sets up Docker group/service
# - (Optional) symlink IntelliJ IDEA from /opt/idea to /usr/local/bin/idea
# -------------------------------------------------------------------

# ===================== Packages =====================
packages=(
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
)

# Directory for code projects
code_dir="$HOME/code"

# ===================== Paru install =====================
install_paru() {
  if command -v paru >/dev/null 2>&1; then
    echo "✅ paru is already installed."
    return
  fi
  echo "📦 Installing paru (AUR helper)..."
  sudo pacman -S --noconfirm --needed base-devel git
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
  ( cd "$tmpdir/paru" && makepkg -si --noconfirm )
  echo "✅ paru installed."
}

# ===================== Helpers =====================
is_installed() {
  pacman -Q "$1" >/dev/null 2>&1 || paru -Q "$1" >/dev/null 2>&1
}

install_package_pacman() {
  echo "📦 Installing $1 from official repositories…"
  sudo pacman -S --noconfirm --needed "$1"
}

install_package_paru() {
  echo "📦 Installing $1 from AUR via paru…"
  paru -S --noconfirm --needed "$1"
}

# Install SDKMAN if missing
install_sdkman() {
  if [[ ! -d "$HOME/.sdkman" ]]; then
    echo "🌐 Installing SDKMAN…"
    if ! command -v curl >/dev/null 2>&1; then
      echo "curl not found, installing…"
      sudo pacman -S --noconfirm --needed curl
    fi
    curl -s "https://get.sdkman.io" | bash
  else
    echo "✅ SDKMAN already installed."
  fi
}

# Install Rust toolchain via rustup if missing
install_rust() {
  if ! command -v rustup >/dev/null 2>&1; then
    echo "🦀 Installing Rust (rustup)…"
    if ! command -v curl >/dev/null 2>&1; then
      echo "curl not found, installing…"
      sudo pacman -S --noconfirm --needed curl
    fi
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  else
    echo "✅ Rust (rustup) already installed."
  fi
}

# Create code directory if it doesn't exist
create_code_directory() {
  if [[ ! -d "$code_dir" ]]; then
    echo "📁 Creating code directory at $code_dir…"
    mkdir -p "$code_dir"
  else
    echo "✅ Code directory already exists at $code_dir."
  fi
}

# Configure Docker permissions and enable service
configure_docker() {
  # Ensure the group exists
  echo "🛠️  Creating or verifying 'docker' group…"
  sudo groupadd -f docker

  # Add user to docker group if not present
  if id -nG "$USER" | grep -qw docker; then
    echo "✅ User '$USER' is already in the 'docker' group."
  else
    echo "👤 Adding '$USER' to 'docker' group…"
    sudo usermod -aG docker "$USER"
    echo "⚠️  You’ll need to log out and back in for group changes to take effect!"
  fi

  # Enable & start Docker service
  echo "🧩 Enabling Docker service…"
  sudo systemctl enable --now docker.service docker.socket || true
}

# Create symlink for IntelliJ IDEA (if installed under /opt/idea)
configure_sim_link_idea() {
  if [[ -d "/opt/idea" && -f "/opt/idea/bin/idea" ]]; then
    sudo ln -sf /opt/idea/bin/idea /usr/local/bin/idea
    echo "🔗 Linked /usr/local/bin/idea → /opt/idea/bin/idea"
  else
    echo "ℹ️  Skipping IDEA symlink: /opt/idea/bin/idea not found."
  fi
}

# ===================== Begin =====================
echo "----------------------------------------"
echo "🚀 Starting developer setup"
echo "----------------------------------------"

install_paru
install_sdkman
install_rust
create_code_directory

# Install packages
for pkg in "${packages[@]}"; do
  if is_installed "$pkg"; then
    echo "✅ [$pkg] is already installed."
  else
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      install_package_pacman "$pkg"
    else
      install_package_paru "$pkg"
    fi
    echo "$pkg — 完全"
  fi
done

# Final configuration steps
configure_docker
configure_sim_link_idea

echo "✅ Done."
