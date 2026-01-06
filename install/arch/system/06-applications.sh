#!/usr/bin/env bash

SOURCE_DIR="$HOME/.dotfiles/install/system/applications"
TARGET_DIR="/usr/share/applications"

mkdir -p "$TARGET_DIR"

for file in "$SOURCE_DIR"/*.desktop; do
    [ -e "$file" ] || continue

    if grep -q "^Hidden=true" "$file"; then
        filename="$(basename "$file")"
        target="$TARGET_DIR/$filename"

        sudo cp "$file" "$target"
        sudo sed -i '/^Hidden=/d' "$target"

        echo "Hidden=true" | sudo tee -a "$target" > /dev/null

        echo "Processed: $filename"
    fi
done
