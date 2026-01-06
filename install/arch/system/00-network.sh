#!/bin/bash

read -p "Do you want to install the iwd/network (wifi) configuration? (y/N): " install_config
install_config=${install_config,,}  # convert to lowercase

if [[ "$install_config" == "y" || "$install_config" == "yes" ]]; then
    # Install iwd if missing
    if ! command -v iwctl &>/dev/null; then
        echo "Installing iwd..."
        sudo pacman -S --noconfirm --needed iwd impala
        sudo systemctl enable --now iwd.service
    else
        echo "iwd is already installed."
    fi

    # Disable and mask systemd-networkd-wait-online
    echo "Disabling systemd-networkd-wait-online.service..."
    sudo systemctl disable systemd-networkd-wait-online.service
    sudo systemctl mask systemd-networkd-wait-online.service

    echo "Configuration applied."
else
    echo "Skipping iwd/network configuration."
fi
