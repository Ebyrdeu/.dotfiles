#!/bin/bash

# Install mise if missing
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
    source ~/.bashrc
else
    echo "mise is already installed."
fi

# Install Node.js
echo "Installing Node.js..."
mise use --global node@lts
echo "Node.js installed: $(node -v)"

# Install npm
echo "Installing npm..."
mise use --global npm
echo "npm installed: $(npm -v)"

# Install pnpm
echo "Installing pnpm..."
mise use --global pnpm
echo "pnpm installed: $(pnpm -v)"

# Install Go
echo "Installing Go..."
mise use --global go@latest
echo "Go installed: $(go version)"

# Install Zig
echo "Installing Zig..."
mise use --global zig@latest
echo "Zig installed: $(zig version)"

# Install Rust
if ! command -v rustup &> /dev/null; then
    echo "Installing Rust (rustup)…"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    echo "Rust (rustup) already installed."
fi

# Install SDKMAN
if [[ ! -d "$HOME/.sdkman" ]]; then
    echo "Installing SDKMAN…"
    curl -s "https://get.sdkman.io" | bash
else
    echo "SDKMAN already installed."
fi

# Load SDKMAN environment
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    echo "Loading SDKMAN environment…"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install SDKMAN packages
packages=("maven" "gradle")

for pkg in "${packages[@]}"; do
    if sdk list "$pkg" | grep -q 'installed'; then
        echo "$pkg is already installed."
    else
        echo "Installing $pkg via SDKMAN…"
        sdk install "$pkg"
    fi
done

# Optional Java installation
read -p "Install Java via SDKMAN? (y/N): " install_java
install_java=${install_java,,} # lowercase

if [[ "$install_java" == "y" || "$install_java" == "yes" ]]; then
    read -p "Enter Java version (e.g., 24.0.2-graal): " java_version
    echo "Installing Java $java_version via SDKMAN…"
    sdk install java "$java_version"
else
    echo "Skipping Java installation."
fi
