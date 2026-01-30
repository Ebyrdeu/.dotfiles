#!/usr/bin/env bash
set -euo pipefail

# Colors
C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_WARN='\033[1;33m'
C_RESET='\033[0m'

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }

# 1. Mise Installation
# ------------------------------------------------------------
if ! command -v mise &> /dev/null; then
    say "Enabling mise COPR and installing..."
    sudo dnf copr enable -y jdxcode/mise
    sudo dnf install -y mise
    eval "$(mise activate bash)"
else
    say "Mise is already installed."
    eval "$(mise activate bash)"
fi

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

say "Provisioning languages via Mise..."
for lang in "${languages[@]}"; do
    echo "  -> Setting up $lang..."
    mise use --global "$lang"
done

# Verification of Mise tools
echo -e "  [+] Npm: $(npm -v)"
echo -e "  [+] Pnpm: $(pnpm -v)"
echo -e "  [+] Node: $(node -v)"
echo -e "  [+] Go:   $(go version | awk '{print $3}')"
echo -e "  [+] Rust: $(cargo --version)"
echo -e "  [+] Zig: $(zig version)"
echo -e "  [+] Zls: $(zls --version)"
# 3. SDKMAN Setup
# ------------------------------------------------------------
export SDKMAN_DIR="$HOME/.sdkman"
if [[ ! -d "$SDKMAN_DIR" ]]; then
    say "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
else
    say "SDKMAN already detected."
fi

# Initialize SDKMAN Environment
# We wrap this in 'set +u' because SDKMAN scripts reference
# undefined variables (like ZSH_VERSION) which crashes 'set -u' scripts.
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    set +u
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    set -u
fi

# 4. Java Ecosystem (Maven, Gradle, JDKs)
# ------------------------------------------------------------
packages=("maven" "gradle")
jdks=("25.0.1.fx-nik")

say "Provisioning Java ecosystem..."

# We disable 'nounset' for the entire loop because 'sdk' commands
# internally check variables like SDKMAN_OFFLINE_MODE that might be unset.
set +u

for pkg in "${packages[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        echo "  -> Installing $pkg via SDKMAN..."
        sdk install "$pkg"
    else
        echo "  -> $pkg already installed. Skipping."
    fi
done

for jdk in "${jdks[@]}"; do
    # Check if this specific version is already installed on disk
    if [[ ! -d "$SDKMAN_DIR/candidates/java/$jdk" ]]; then
        echo "  -> Installing JDK: $jdk..."
        sdk install java "$jdk"
    else
        echo "  -> JDK $jdk already exists. Skipping."
    fi
done

set -u

# 5. Summary
# ------------------------------------------------------------
echo -e "${C_OK}------------------------------------------------${C_RESET}"
echo -e "All dev toolchains are synchronized!"
echo -e "Mise: Node, Go, Zig, Rust"
echo -e "SDK:  Java ($jdks), Maven, Gradle"
echo -e "${C_OK}------------------------------------------------${C_RESET}"
