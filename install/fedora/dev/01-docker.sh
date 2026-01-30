#!/usr/bin/env bash
set -euo pipefail

C_HEAD='\033[1;34m'
C_OK='\033[0;32m'
C_RESET='\033[0m'

say() { echo -e "${C_HEAD}>>> $1${C_RESET}"; }

# 1. Install Docker Repository and Packages
# ------------------------------------------------------------
if ! dnf list installed docker-ce &>/dev/null; then
    say "Adding Docker repository and installing packages..."
    sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    say "Docker is already installed. Skipping package installation."
fi

# 2. Configure Docker Daemon
# ------------------------------------------------------------
say "Configuring Docker daemon (logs, DNS, bip)..."
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
{
    "log-driver": "json-file",
    "log-opts": { "max-size": "10m", "max-file": "5" },
    "dns": ["172.17.0.1"],
    "bip": "172.17.0.1/16"
}
EOF

# 3. Networking: Bridge systemd-resolved to Docker
# ------------------------------------------------------------
say "Exposing systemd-resolved to Docker network..."
sudo mkdir -p /etc/systemd/resolved.conf.d
echo -e '[Resolve]\nDNSStubListenerExtra=172.17.0.1' | sudo tee /etc/systemd/resolved.conf.d/20-docker-dns.conf >/dev/null

say "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

# 4. Permissions and Systemd Service
# ------------------------------------------------------------
say "Configuring user permissions and systemd..."

# Only add user to group if they aren't already in it
if ! groups "$USER" | grep -q "\bdocker\b"; then
    sudo usermod -aG docker "$USER"
    echo "  [+] User added to docker group. (Note: Log out and back in for this to take effect)"
fi

# Prevent Docker from blocking boot
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/no-block-boot.conf >/dev/null <<'EOF'
[Unit]
DefaultDependencies=no
EOF

# Reload, enable, and start
sudo systemctl daemon-reload
sudo systemctl enable --now docker

# 5. Summary
# ------------------------------------------------------------
echo -e "${C_OK}------------------------------------------------${C_RESET}"
echo -e "Docker Setup Complete!"
echo -e "Docker Version: $(docker --version)"
echo -e "DNS Bridge:     172.17.0.1 (via systemd-resolved)"
echo -e "${C_OK}------------------------------------------------${C_RESET}"
