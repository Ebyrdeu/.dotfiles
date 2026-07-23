#!/usr/bin/env bash
set -euo pipefail

# Configuration
FONT_BASE_DIR="$HOME/.local/share/fonts"
NERD_VERSION="v3.4.0"

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

# Temporary directory handling
TEMP_DIR=$(mktemp -d)
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT SIGINT SIGTERM

# 1. Dependency Check
ensure_dependencies() {
    local deps=(curl unzip git fontconfig)
    local to_install=()

    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            to_install+=("$cmd")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        say "Installing required dependencies: ${to_install[*]}"
        sudo dnf install -y "${to_install[@]}"
        ok "Dependencies installed."
    fi
}

ensure_dependencies
mkdir -p "$FONT_BASE_DIR"

# ------------------------------------------------------------
# Step 1: JetBrains Mono Nerd Font
# ------------------------------------------------------------
JB_DIR="$FONT_BASE_DIR/JetBrainsMonoNerd"
if [[ -d "$JB_DIR" ]] && find "$JB_DIR" -maxdepth 1 -type f \( -name "*.ttf" -o -name "*.otf" \) | grep -q .; then
    warn "JetBrains Mono Nerd Font detected. Skipping."
else
    say "Installing JetBrains Mono Nerd Font..."
    mkdir -p "$JB_DIR"
    curl -sSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_VERSION}/JetBrainsMono.zip" -o "$TEMP_DIR/jb.zip"
    unzip -oq "$TEMP_DIR/jb.zip" -d "$JB_DIR"
    find "$JB_DIR" -type f ! \( -name "*.[ot]tf" \) -delete
    ok "JetBrains Mono Nerd Font installed."
fi

# ------------------------------------------------------------
# Step 2: Google Fonts
# ------------------------------------------------------------
GOOGLE_DIR="$FONT_BASE_DIR/google-fonts"
font_count=0
if [[ -d "$GOOGLE_DIR" ]]; then
    font_count=$(find "$GOOGLE_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) 2>/dev/null | wc -l)
fi

if [[ $font_count -gt 100 ]]; then
    warn "Google Fonts library detected ($font_count files). Skipping."
else
    say "Downloading FULL Google Fonts Library..."
    mkdir -p "$GOOGLE_DIR"
    curl -sSL "https://github.com/google/fonts/archive/main.zip" -o "$TEMP_DIR/google-fonts.zip"
    unzip -j -oq "$TEMP_DIR/google-fonts.zip" "*.ttf" "*.otf" -d "$GOOGLE_DIR" || true
    ok "Google Fonts library installed."
fi

# ------------------------------------------------------------
# Step 3: Adobe Source Pro Series
# ------------------------------------------------------------
say "Checking Adobe Source Fonts..."
ADOBE_BASE_DIR="$FONT_BASE_DIR/adobe-fonts"

for repo in source-sans source-serif source-code-pro; do
    TARGET_DIR="$ADOBE_BASE_DIR/$repo"

    if [[ -d "$TARGET_DIR" ]] && find "$TARGET_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) 2>/dev/null | grep -q .; then
        warn "Adobe $repo already exists. Skipping."
    else
        say "Downloading Adobe $repo..."
        git clone --depth 1 "https://github.com/adobe-fonts/$repo.git" "$TEMP_DIR/$repo" &>/dev/null
        mkdir -p "$TARGET_DIR"
        find "$TEMP_DIR/$repo" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$TARGET_DIR/" \;
        ok "Adobe $repo installed."
    fi
done

# ------------------------------------------------------------
# Step 4: Finalize Font Cache
# ------------------------------------------------------------
say "Updating font cache..."
fc-cache -f

echo "------------------------------------------------------------"
ok "All font checks complete!"
say "Total font files in $FONT_BASE_DIR: $(find "$FONT_BASE_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) | wc -l)"
