#!/usr/bin/env bash
set -euo pipefail

# Configuration
TEMP_DIR=$(mktemp -d)
FONT_BASE_DIR="$HOME/.local/share/fonts"
NERD_VERSION="v3.4.0"

# Colors
C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_RESET='\033[0m'

cleanup() {
    rm -rf "$TEMP_DIR"
    echo -e "${C_RESET}\nCleaned up temporary workspace."
}
trap cleanup EXIT

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }

# 1. Dependency Check
for cmd in curl unzip git fc-cache; do
    if ! command -v "$cmd" &>/dev/null; then
        sudo dnf install -y "$cmd"
    fi
done

mkdir -p "$FONT_BASE_DIR"

# ------------------------------------------------------------
# Step 1: JetBrains Mono Nerd Font
# ------------------------------------------------------------
JB_DIR="$FONT_BASE_DIR/JetBrainsMonoNerd"
if find "$JB_DIR" -maxdepth 1 -name "JetBrainsMono*.[ot]tf" 2>/dev/null | grep -q .; then
    say "JetBrains Mono Nerd Font detected. Skipping."
else
    say "Installing JetBrains Mono Nerd Font..."
    mkdir -p "$JB_DIR"
    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_VERSION}/JetBrainsMono.zip" -o "$TEMP_DIR/jb.zip"
    unzip -oq "$TEMP_DIR/jb.zip" -d "$JB_DIR"
    find "$JB_DIR" -type f ! -name "*.[ot]tf" -delete
fi

# ------------------------------------------------------------
# Step 2: Google Fonts (Full Repo Skip Logic)
# ------------------------------------------------------------
GOOGLE_DIR="$FONT_BASE_DIR/google-fonts"
font_count=0
[[ -d "$GOOGLE_DIR" ]] && font_count=$(find "$GOOGLE_DIR" -name "*.[ot]tf" | wc -l)

if [ "$font_count" -gt 100 ]; then
    say "Google Fonts library detected ($font_count files). Skipping."
else
    say "Downloading FULL Google Fonts Library..."
    mkdir -p "$GOOGLE_DIR"
    curl -L "https://github.com/google/fonts/archive/main.zip" -o "$TEMP_DIR/google-fonts.zip"
    unzip -j -oq "$TEMP_DIR/google-fonts.zip" "*.ttf" "*.otf" -d "$GOOGLE_DIR" || true
fi

# ------------------------------------------------------------
# Step 3: Adobe Source Pro Series (Fixed Skip Logic)
# ------------------------------------------------------------
say "Checking Adobe Source Fonts..."
ADOBE_BASE_DIR="$FONT_BASE_DIR/adobe-fonts"

for repo in source-sans source-serif source-code-pro; do
    TARGET_DIR="$ADOBE_BASE_DIR/$repo"

    # CONTENT CHECK: Look inside the specific folder for font files
    # We use 2>/dev/null to hide errors if the directory doesn't exist yet
    if find "$TARGET_DIR" -name "*.[ot]tf" 2>/dev/null | grep -q .; then
        echo -e "  -> ${C_OK}OK:${C_RESET} Adobe $repo already exists. Skipping."
    else
        echo "  -> Downloading $repo..."
        # Clone into temp first so we don't leave .git folders in our font dir
        git clone --depth 1 "https://github.com/adobe-fonts/$repo.git" "$TEMP_DIR/$repo"
        mkdir -p "$TARGET_DIR"
        # Move only the fonts
        find "$TEMP_DIR/$repo" -type f -name "*.[ot]tf" -exec cp {} "$TARGET_DIR/" \;
    fi
done

# ------------------------------------------------------------
# Step 4: Finalize
# ------------------------------------------------------------
say "Updating font cache..."
fc-cache -f

echo -e "${C_OK}------------------------------------------------${C_RESET}"
echo -e "All font checks complete!"
echo -e "Total fonts in $FONT_BASE_DIR: $(find "$FONT_BASE_DIR" -type f | wc -l)"
