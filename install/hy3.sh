#!/bin/bash

echo "  Installing hy3 plugin via hyprpm..."
if command -v hyprpm >/dev/null 2>&1; then
  hyprpm add https://github.com/outfoxxed/hy3 || true
  hyprpm update -f
  hyprpm enable hy3
  echo " hy3 plugin installed and enabled."
else
  echo "⚠️  hyprpm not found. Skipping hy3 plugin. (Ensure Hyprland is installed correctly.)"
fi
