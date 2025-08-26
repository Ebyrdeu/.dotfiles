#!/bin/bash

echo "  Installing hy3 plugin via hyprpm..."
read -p "Do you want to skip installing the hy3 plugin? [y/N]: " skip_hy3
skip_hy3=${skip_hy3:-N}

if [[ ! "$skip_hy3" =~ ^[Yy]$ ]]; then
    if command -v hyprpm >/dev/null 2>&1; then
        hyprpm add https://github.com/outfoxxed/hy3 || true
        hyprpm update -f
        hyprpm enable hy3
        echo " hy3 plugin installed and enabled."
    else
        echo "⚠️  hyprpm not found. Skipping hy3 plugin. (Ensure Hyprland is installed correctly.)"
    fi
else
    echo "⏭️  Skipped hy3 plugin installation."
fi
