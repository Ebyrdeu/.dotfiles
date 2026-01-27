#!/bin/bash

# --- CONFIGURATION ---
URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
FONT_NAME="JetBrainsMonoNerdFont"
TEMP_DIR="/tmp/font_install"
LOCAL_FONT_DIR="$HOME/.local/share/fonts"
JETBRAINS_DIR="$LOCAL_FONT_DIR/$FONT_NAME"

# Ensure directories exist
mkdir -p "$TEMP_DIR"
mkdir -p "$LOCAL_FONT_DIR"


echo "Step 1: Installing JetBrains Mono Nerd Font..."
mkdir -p "$JETBRAINS_DIR"
curl -L "$URL" -o "$TEMP_DIR/nerd_fonts.zip"
unzip -o "$TEMP_DIR/nerd_fonts.zip" -d "$JETBRAINS_DIR"
find "$JETBRAINS_DIR" -type f ! -name "*.ttf" ! -name "*.otf" -delete

echo "Step 2: Downloading Google Fonts (Main Collection)..."
mkdir -p "$LOCAL_FONT_DIR/google"
curl -L "https://github.com/google/fonts/archive/main.zip" -o "$TEMP_DIR/google-fonts.zip"
unzip -oq "$TEMP_DIR/google-fonts.zip" -d "$TEMP_DIR/google-temp"
# Move only the font files to keep it clean
find "$TEMP_DIR/google-temp" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$LOCAL_FONT_DIR/google/" \;

echo "Step 3: Cloning Adobe Source Fonts..."
mkdir -p "$LOCAL_FONT_DIR/adobe-fonts"
for repo in source-sans source-serif source-code-pro; do
    TARGET="$LOCAL_FONT_DIR/adobe-fonts/$repo"
    if [ ! -d "$TARGET" ]; then
        git clone --depth 1 "https://github.com/adobe-fonts/$repo.git" "$TARGET"
    else
        echo "   -> $repo already exists, skipping."
    fi
done

echo "Step 4: Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "Step 5: Updating font cache..."
fc-cache -fv

echo "------------------------------------------------"
echo "Success! All fonts installed."
