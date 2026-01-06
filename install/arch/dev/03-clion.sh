#!/bin/bash

CLION_URL="https://download.jetbrains.com/cpp/CLion-2025.3.1.tar.gz"
INSTALL_DIR="/opt/clion"
SYMLINK="/usr/local/bin/clion"
EXECUTABLE="$INSTALL_DIR/bin/clion"

# Check if Clion is already installed
if [[ -f "$EXECUTABLE" ]]; then
    echo "Clion already installed at $EXECUTABLE"
else
    echo "Downloading Clion from $CLION_URL..."
    wget -O /tmp/clion.tar.gz "$CLION_URL"

    echo "Extracting to $INSTALL_DIR..."
    sudo rm -rf "$INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"
    sudo tar -xzf /tmp/clion.tar.gz -C "$INSTALL_DIR" --strip-components=1

    echo "Installed to $INSTALL_DIR"

    # Create or update symlink
    echo "Linking $SYMLINK → $EXECUTABLE"
    sudo ln -sf "$EXECUTABLE" "$SYMLINK"

    # Give privileges (for updates)
    sudo chown -R $(whoami):$(whoami) /opt/clion
    echo "Privileges was given"

    echo "Done! You can run Clion using 'clion' from the terminal."
fi
