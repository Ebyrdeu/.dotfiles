#!/bin/bash

echo "Which environment do you want to install?"
echo "1) Hyprland (default)"
echo "2) i3"
echo "3) Skip installation"
read -p "Enter 1, 2, or 3: " choice
choice=${choice:-1}

if [[ "$choice" == "1" ]]; then
    source ./install/wm/999-hyprland.sh
elif [[ "$choice" == "2" ]]; then
    source ./install/wm/999-i3.sh
else
    echo "Skipped environment installation."
fi
