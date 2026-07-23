#!/usr/bin/env bash
set -euo pipefail

# Colors
C_RESET='\033[0m'
C_OK='\033[0;32m'
C_ERR='\033[0;31m'
C_HEAD='\033[1;36m'

# Helpers
say() { printf "%b[INFO]%b %s\n" "$C_HEAD" "$C_RESET" "$*"; }
ok()  { printf "%b[OK]%b %s\n" "$C_OK"   "$C_RESET" "$*"; }
err() { printf "%b[ERR]%b %s\n" "$C_ERR"  "$C_RESET" "$*" >&2; }

# Main Execution
current_host=$(hostname)
say "Current hostname: $current_host"

# 1. Ask for input (Optional)
read -rp "Enter new hostname [Press ENTER to keep '$current_host']: " input_hostname

# 2. Handle empty input (Optional skip)
if [[ -z "${input_hostname:-}" ]]; then
    ok "No changes made. Keeping hostname as '$current_host'."
    exit 0
fi

# 3. Normalize and Validate
new_hostname="${input_hostname,,}"

# Regex: Starts/ends with alphanumeric, allows dots/dashes in between
if [[ ! "$new_hostname" =~ ^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$ ]]; then
    err "Invalid hostname '$new_hostname'."
    echo "Rules: Alphanumeric, dots, and dashes only. Cannot start or end with a dot or dash."
    exit 1
fi

if [[ "$new_hostname" == "$current_host" ]]; then
    ok "Hostname is already set to '$new_hostname'. No changes needed."
    exit 0
fi

# 4. Apply Change
say "Applying change: $current_host -> $new_hostname..."
sudo hostnamectl set-hostname "$new_hostname"

# Update /etc/hosts entry if old hostname was present
if grep -q "127.0.1.1" /etc/hosts 2>/dev/null; then
    sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$new_hostname/" /etc/hosts
fi

ok "Success! Hostname updated to: $new_hostname"
say "Note: Open a new shell session to see the change in your terminal prompt."
