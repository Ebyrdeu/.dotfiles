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


# 1. Mise Installation
# ------------------------------------------------------------
if ! command -v mise >/dev/null 2>&1; then
    say "Enabling mise COPR and installing..."
    sudo dnf copr enable -y jdxcode/mise
    sudo dnf install -y mise
    eval "$(mise activate bash)"
else
    warn "Mise is already installed."
fi

# Activate Mise environment in current shell session
set +u
eval "$(mise activate bash)"
set -u

# 2. Mise Languages (Global)
# ------------------------------------------------------------
languages=(
    "npm@latest"
    "pnpm@latest"
    "node@latest"
    "go@latest"
    "rust@latest"
    "zig@master"
    "zls@latest"
)

say "Provisioning global toolchains via Mise..."
for lang in "${languages[@]}"; do
    say "Setting up $lang..."
    mise use --global "$lang"
done

# Resilient tool version verification
say "Verifying Mise toolchains..."
echo "  [+] Node: $(node -v 2>/dev/null || echo 'N/A')"
echo "  [+] Npm:  $(npm -v 2>/dev/null || echo 'N/A')"
echo "  [+] Pnpm: $(pnpm -v 2>/dev/null || echo 'N/A')"
echo "  [+] Go:   $(go version 2>/dev/null | awk '{print $3}' || echo 'N/A')"
echo "  [+] Rust: $(cargo --version 2>/dev/null || echo 'N/A')"
echo "  [+] Zig:  $(zig version 2>/dev/null || echo 'N/A')"
echo "  [+] Zls:  $(zls --version 2>/dev/null || echo 'N/A')"

# 3. SDKMAN Setup
# ------------------------------------------------------------
export SDKMAN_DIR="$HOME/.sdkman"
if [[ ! -d "$SDKMAN_DIR" ]]; then
    say "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    ok "SDKMAN installed."
else
    warn "SDKMAN already detected."
fi

# Initialize SDKMAN Environment (set +u required for internal variables)
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    set +u
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    set -u
fi

# 4. Java Ecosystem (Maven, Gradle, JDKs)
# ------------------------------------------------------------
packages=("maven" "gradle")
jdks=("25.0.2-graalce")

say "Provisioning Java ecosystem..."

# Disable nounset for the SDKMAN execution loop
set +u

for pkg in "${packages[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        say "Installing $pkg via SDKMAN..."
        sdk install "$pkg"
    else
        warn "$pkg already installed. Skipping."
    fi
done

for jdk in "${jdks[@]}"; do
    if [[ ! -d "$SDKMAN_DIR/candidates/java/$jdk" ]]; then
        say "Installing JDK: $jdk..."
        sdk install java "$jdk"
    else
        warn "JDK $jdk already exists. Skipping."
    fi
done

set -u

# 5. Summary
# ------------------------------------------------------------
echo "------------------------------------------------------------"
ok "All dev toolchains are synchronized!"
say "Mise: Node, Go, Zig, Rust"
say "SDK:  Java (${jdks[*]} $), Maven, Gradle"
echo "------------------------------------------------------------"
