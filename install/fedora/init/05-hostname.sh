#!/bin/bash

# 1. Ask the user for input
echo "--- Hostname Setup ---"
read -p "Enter new hostname: " hostname

# 2. Check if the input is empty (User just pressed Enter)
if [[ -z "$hostname" ]]; then
    echo "Error: No hostname entered. Operation cancelled."
    exit 1
fi

# 3. Validate the hostname format
# Rules: alphanumeric, dots, and dashes only
if [[ "$hostname" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    # Success path: Set the hostname
    sudo hostnamectl set-hostname "$hostname"
    echo "------------------------------------------------"
    echo "Success! Hostname successfully set to: $hostname"
    echo "------------------------------------------------"
else
    # Error path: Invalid characters
    echo "------------------------------------------------"
    echo "Error: Invalid hostname provided."
    echo "Only alphanumeric characters, dots, and dashes are allowed."
    echo "------------------------------------------------"
    exit 1
fi