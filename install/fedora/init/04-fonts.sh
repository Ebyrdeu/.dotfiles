#!/bin/bash

# Define variables
URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
FONT_NAME="JetBrainsMonoNerdFont"
TEMP_DIR="/tmp/$FONT_NAME"
INSTALL_DIR="$HOME/.local/share/fonts/$FONT_NAME"

echo "Step 1: Creating installation directory..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$TEMP_DIR"

echo "Step 2: Downloading fonts..."
# -L follows redirects, -o specifies output file
curl -L "$URL" -o "$TEMP_DIR/fonts.zip"

echo "Step 3: Extracting fonts..."
unzip -o "$TEMP_DIR/fonts.zip" -d "$INSTALL_DIR"

echo "Step 4: Cleaning up non-font files..."
# Removes READMEs, licenses, and other metadata often included in the zip
find "$INSTALL_DIR" -type f ! -name "*.ttf" ! -name "*.otf" -delete

echo "Step 5: Updating font cache..."
fc-cache -fv

echo "Success! JetBrains Mono Nerd Font is installed."