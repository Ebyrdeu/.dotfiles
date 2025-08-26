#!/bin/bash

IDEA_URL="https://download.jetbrains.com/idea/ideaIU-2025.2.tar.gz"
INSTALL_DIR="/opt/idea"
SYMLINK="/usr/local/bin/idea"
EXECUTABLE="$INSTALL_DIR/bin/idea"

# --- CHECK IF ALREADY INSTALLED ---
if [[ -f "$EXECUTABLE" ]]; then
  echo "  IntelliJ IDEA already installed at $EXECUTABLE"
else
  echo "  Downloading IntelliJ IDEA from $IDEA_URL..."
  wget -O /tmp/idea.tar.gz "$IDEA_URL"

  echo " Extracting to $INSTALL_DIR..."
  sudo rm -rf "$INSTALL_DIR"
  sudo mkdir -p "$INSTALL_DIR"
  sudo tar -xzf /tmp/idea.tar.gz -C "$INSTALL_DIR" --strip-components=1

  echo " Installed to $INSTALL_DIR"

  # --- CREATE/UPDATE SYMLINK ---
  echo " Linking $SYMLINK → $EXECUTABLE"
  sudo ln -sf "$EXECUTABLE" "$SYMLINK"

  echo "  Done! Run 'idea' from terminal."
fi
