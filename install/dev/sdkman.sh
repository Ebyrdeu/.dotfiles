#!/bin/bash

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
  read -p "Enter the Java version you want to install (e.g., 24.0.2): " java_version
  java_candidate="java-${java_version}-graalce"

  if sdk list java | grep -q "$java_candidate"; then
    echo " Java $java_version is already installed."
  else
    echo " Installing Java $java_version via SDKMAN…"
    sdk install java "$java_candidate"
  fi
else
  echo "Skipping Java installation."
fi