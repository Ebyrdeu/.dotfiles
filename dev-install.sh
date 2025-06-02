#!/bin/bash
 
packages=(
    # Core system
    "alacritty"
    "base-devel"
    "cmake"
	"meson"
	"cpio"
	"pkg-config"
	"g++"
	"gcc"
    "go"
    "neovim"
    "nvm"
    "ripgrep"
    "tmux"
    "tldr"

    # Graphics/Video
    "gstreamer"
    "gst-plugins-base"
    "gst-plugins-good"
    "gst-plugins-bad"
    "gst-plugins-ugly"
    "gst-libav"
    "libva-mesa-driver"
    "mesa-vdpau"
    "vulkan-intel"
	"lld"
	"llvm"

    # Web/Networking
    "webkit2gtk-4.1"
	"webkit2gtk"

    # Containers
    "docker"
    "docker-buildx"
    "docker-compose"

    # CLI tools
    "fd"
    "fzf"
)


# Directory for code projects
code_dir="$HOME/code"

# Check if a package is installed (official repos or AUR)
is_installed() {
  pacman -Q "$1" &> /dev/null \
    || yay -Q "$1" &> /dev/null
}

# Install from official repositories
install_package_pacman() {
  echo "Installing $1 from official repositories…"
  sudo pacman -S --noconfirm "$1"
}

# Install from AUR
install_package_yay() {
  echo "Installing $1 from AUR…"
  yay -S --noconfirm "$1"
}

# Install SDKMAN if missing
install_sdkman() {
  if [ ! -d "$HOME/.sdkman" ]; then
    echo "Installing SDKMAN…"
    curl -s "https://get.sdkman.io" | bash
  else
    echo "SDKMAN is already installed."
  fi
}

# Install Rust toolchain via rustup if missing
install_rust() {
  if ! command -v rustup &> /dev/null; then
    echo "Installing Rust…"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  else
    echo "Rust is already installed."
  fi
}

# Create code directory if it doesn't exist
create_code_directory() {
  if [ ! -d "$code_dir" ]; then
    echo "Creating code directory at $code_dir…"
    mkdir -p "$code_dir"
  else
    echo "Code directory already exists at $code_dir."
  fi
}

# Configure Docker permissions and enable service
configure_docker() {
  if id -nG "$USER" | grep -qw docker; then
    echo "User '$USER' is already in the 'docker' group; skipping group/user config and Docker enable."
    return
  fi

  # Ensure the group exists
  echo "Creating or verifying 'docker' group…"
  sudo groupadd -f docker

  # Add user to docker group
  echo "Adding '$USER' to 'docker' group…"
  sudo usermod -aG docker "$USER"
  echo "NOTE: You’ll need to log out and back in for group changes to take effect!"

  # Enable & start Docker service
  echo "Enabling Docker service…"
  sudo systemctl enable --now docker.service docker.socket
}

# Create symlink for IntelliJ IDEA (if installed under /opt/idea)
configure_sim_link_idea() {
  if [ -d "/opt/idea" ]; then
    if [ -f "/opt/idea/bin/idea" ]; then
      sudo ln -sf /opt/idea/bin/idea /usr/local/bin/idea
      echo "Linked /usr/local/bin/idea → /opt/idea/bin/idea"
    else
      echo "Error: /opt/idea/bin/idea not found. Is IntelliJ IDEA installed?"
      exit 1
    fi
  else
    echo "Error: /opt/idea directory not found. IntelliJ IDEA might not be installed."
    exit 1
  fi
}

# Begin installations and setup
install_sdkman
install_rust
create_code_directory

# Install packages
for pkg in "${packages[@]}"; do
  if is_installed "$pkg"; then
    echo "[$pkg] is already installed."
  else
    if pacman -Si "$pkg" &> /dev/null; then
      install_package_pacman "$pkg"
    else
      install_package_yay "$pkg"
    fi
    echo "$pkg — 完全"
  fi
done

# Final configuration steps
configure_docker
configure_sim_link_idea

echo "Done."
