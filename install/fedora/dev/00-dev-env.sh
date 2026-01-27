#!/bin/bash

# Install mise if missing
if ! command -v mise &> /dev/null; then
    sudo dnf copr enable jdxcode/mise
    sudo dnf install mise
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
mise use --global zls@latest
echo "Zls installed: $(zls version)"

# Install Rust
echo "Installing Rust..."
mise use --global rust@latest
echo "Rust installed: $(cargo --version)"



#-----------------------------------------------
# Mise support of java kinda meh, so sdk for now
#-----------------------------------------------
if [[ ! -d "$HOME/.sdkman" ]]; then
  echo "Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
else
  echo "SDKMAN already installed."
fi

if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  echo "Loading SDKMAN environment…"
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

packages=("maven" "gradle")

for pkg in "${packages[@]}"; do
    echo "Installing $pkg via SDKMAN..."
    sdk install "$pkg"
done


jdks=(
"25.0.1.fx-nik"
)

for jdk in "${jdks[@]}"; do
    echo "Installing $jdk via SDKMAN..."
    sdk install java "$jdk"
done
