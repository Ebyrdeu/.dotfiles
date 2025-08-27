#!/bin/bash

if ! command -v mise &> /dev/null
then
    echo "  Installing mise..."
    curl https://mise.run | sh
    source ~/.bashrc
else
    echo "mise is already installed."
fi

echo "  Install Node"
mise use --global node@lts
echo " Node.js installed: $(node -v)"

echo "  Install npm (latest version)"
mise use --global npm
echo " npm installed: $(npm -v)"

echo "  Install pnpm (latest version)"
mise use --global pnpm
echo " pnpm installed: $(pnpm -v)"

echo "  Install Go (latest stable version)"
mise use --global go@latest
echo " Go installed: $(go version)"

if ! command -v rustup >/dev/null 2>&1; then
  echo "  Installing Rust (rustup)…"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo " Rust (rustup) already installed."
fi

#-----------------------------------------------
# Mise support of java kinda meh, so sdk for now
#-----------------------------------------------
if [[ ! -d "$HOME/.sdkman" ]]; then
  echo "  Installing SDKMAN…"
  curl -s "https://get.sdkman.io" | bash
else
  echo " SDKMAN already installed."
fi

if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  echo "󰑓 Loading SDKMAN environment…"
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

packages=("maven" "gradle")

for pkg in "${packages[@]}"; do
  if sdk list "$pkg" | grep -q 'installed'; then
    echo " $pkg is already installed."
  else
    echo "  Installing $pkg via SDKMAN…"
    sdk install "$pkg"
  fi
done

read -p "Do you want to install Java via SDKMAN? (y/N): " install_java
install_java=${install_java,,} # lowercase

if [[ "$install_java" == "y" || "$install_java" == "yes" ]]; then
  read -p "Enter the Java version you want to install (e.g., 24.0.2-graal): " java_version
  java_candidate="${java_version}"


  if sdk list java | grep -q "$java_candidate"; then
    echo " Java $java_version is already installed."
  else
    echo " Installing Java $java_version via SDKMAN…"
    sdk install java "$java_candidate"
  fi
else
  echo "Skipping Java installation."
fi
