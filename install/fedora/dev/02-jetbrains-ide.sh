#!/usr/bin/env bash
set -euo pipefail

# Colors
C_RESET='\033[0m'
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_ERR='\033[0;31m'
C_HEAD='\033[1;36m'

# Helpers
say()  { printf "%b[INFO]%b %s\n" "$C_HEAD" "$C_RESET" "$*"; }
ok()   { printf "%b[OK]%b %s\n" "$C_OK"   "$C_RESET" "$*"; }
warn() { printf "%b[WARN]%b %s\n" "$C_WARN" "$C_RESET" "$*"; }
err()  { printf "%b[ERR]%b %s\n" "$C_ERR"  "$C_RESET" "$*" >&2; }

# Track downloaded archives for reliable cleanup on exit
TEMP_FILES=()
cleanup() {
    for file in "${TEMP_FILES[@]:-}"; do
        [[ -f "$file" ]] && rm -f "$file"
    done
}
trap cleanup EXIT SIGINT SIGTERM

# Generic JetBrains IDE Installer Function
install_jetbrains_ide() {
    local name="$1"
    local code="$2"
    local install_dir="$3"
    local bin_link="$4"
    local exec_path="$5"

    if [[ -f "$exec_path" ]]; then
        warn "$name is already installed at $install_dir. Skipping."
        return 0
    fi

    say "Installing $name..."

    # Ensure required download/extract dependencies
    local deps=(curl tar)
    local to_install=()
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            to_install+=("$cmd")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        say "Installing missing dependencies: ${to_install[*]}"
        sudo dnf install -y "${to_install[@]}"
    fi

    local download_url="https://data.services.jetbrains.com/products/download?code=${code}&platform=linux"
    local temp_tarball
    temp_tarball=$(mktemp /tmp/jetbrains_XXXXXX.tar.gz)
    TEMP_FILES+=("$temp_tarball")

    say "Downloading $name..."
    curl -sSL --progress-bar -o "$temp_tarball" "$download_url"

    say "Extracting to $install_dir..."
    sudo mkdir -p "$install_dir"
    sudo rm -rf "${install_dir:?}"/*
    sudo tar -xzf "$temp_tarball" -C "$install_dir" --strip-components=1

    say "Setting ownership and creating symlinks..."
    sudo chown -R "$(id -u):$(id -g)" "$install_dir"
    sudo ln -sf "$exec_path" "$bin_link"

    ok "$name installation complete!"
}

# Prompt user for selection
select_ides() {
    # If running non-interactively (e.g. CI or automated script without TTY), default to skipping
    if [[ ! -t 0 ]]; then
        warn "Non-interactive terminal detected. Skipping JetBrains IDE installation."
        exit 0
    fi

    echo "------------------------------------------------------------"
    say "Select JetBrains IDEs to install:"
    echo "1) IntelliJ IDEA Ultimate"
    echo "2) CLion"
    echo "3) Both (IntelliJ + CLion)"
    echo "4) Skip (Default)"
    echo "------------------------------------------------------------"

    read -rp "Enter choice [1-4] (default: 4): " choice
    choice="${choice:-4}"

    case "$choice" in
        1)
            install_jetbrains_ide "IntelliJ IDEA Ultimate" "IIU" "/opt/idea" "/usr/local/bin/idea" "/opt/idea/bin/idea"
            ;;
        2)
            install_jetbrains_ide "CLion" "CL" "/opt/clion" "/usr/local/bin/clion" "/opt/clion/bin/clion.sh"
            ;;
        3)
            install_jetbrains_ide "IntelliJ IDEA Ultimate" "IIU" "/opt/idea" "/usr/local/bin/idea" "/opt/idea/bin/idea"
            install_jetbrains_ide "CLion" "CL" "/opt/clion" "/usr/local/bin/clion" "/opt/clion/bin/clion.sh"
            ;;
        4|*)
            warn "Skipping JetBrains IDE installation."
            exit 0
            ;;
    esac
}

# Run selection
select_ides
