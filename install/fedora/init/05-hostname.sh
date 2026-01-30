#!/usr/bin/env bash
set -euo pipefail

# Colors
C_HEAD='\033[1;36m'
C_OK='\033[0;32m'
C_ERR='\033[0;31m'
C_RESET='\033[0m'

echo -e "${C_HEAD}--- Fedora Hostname Setup ---${C_RESET}"

# 1. Capture current hostname for reference
current_host=$(hostname)
echo "Current hostname: $current_host"

# 2. Ask for input
read -rp "Enter new hostname: " new_hostname

# 3. Check if empty
if [[ -z "$new_hostname" ]]; then
    echo -e "${C_ERR}Error: No hostname entered. Operation cancelled.${C_RESET}"
    exit 1
fi

# 4. Normalize and Validate
# Convert to lowercase as per standard DNS/hostname conventions
new_hostname="${new_hostname,,}"

# Regex: Starts/ends with alphanumeric, allows dots/dashes in between
if [[ "$new_hostname" =~ ^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$ ]]; then

    # Check if it's the same as the current one
    if [[ "$new_hostname" == "$current_host" ]]; then
        echo "Hostname is already set to '$new_hostname'. No changes needed."
        exit 0
    fi

    # 5. Apply changes
    echo "Applying change: $current_host -> $new_hostname..."

    # hostnamectl handles /etc/hostname and machine-info
    sudo hostnamectl set-hostname "$new_hostname"

    # 6. Success Feedback
    echo -e "${C_OK}------------------------------------------------${C_RESET}"
    echo -e "Success! Hostname set to: ${C_HEAD}$new_hostname${C_RESET}"
    echo -e "${C_OK}------------------------------------------------${C_RESET}"
    echo "Note: Start a new shell session to see the change in your prompt."
else
    # Error path
    echo -e "${C_ERR}------------------------------------------------${C_RESET}"
    echo -e "Error: Invalid hostname '${new_hostname}'"
    echo -e "Rules:"
    echo -e " - Only alphanumeric, dots, and dashes"
    echo -e " - Cannot start or end with a dash or dot"
    echo -e "${C_ERR}------------------------------------------------${C_RESET}"
    exit 1
fi
