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


# 1. Install Docker Repository and Packages
# ------------------------------------------------------------
if ! rpm -q docker-ce &>/dev/null; then
    say "Adding Docker repository and installing packages..."
    sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ok "Docker packages installed."
else
    warn "Docker is already installed. Skipping package installation."
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
sudo tee /etc/systemd/resolved.conf.d/20-docker-dns.conf >/dev/null <<'EOF'
[Resolve]
DNSStubListenerExtra=172.17.0.1
EOF

say "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

# 4. Permissions and Systemd Service
# ------------------------------------------------------------
say "Configuring user permissions and systemd..."

# Create docker group if it doesn't exist and add current user
if ! id -nG "$USER" | grep -qw "docker"; then
    sudo usermod -aG docker "$USER"
    warn "User added to docker group. (Note: Log out and back in for changes to take effect)"
fi

# Prevent Docker from blocking boot
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/no-block-boot.conf >/dev/null <<'EOF'
[Unit]
DefaultDependencies=no
EOF

# Reload, enable, and start service
sudo systemctl daemon-reload
sudo systemctl enable --now docker

# 5. Summary
# ------------------------------------------------------------
echo "------------------------------------------------------------"
ok "Docker Setup Complete!"
say "Docker Version: $(docker --version 2>/dev/null || echo 'N/A')"
say "DNS Bridge:     172.17.0.1 (via systemd-resolved)"
echo "------------------------------------------------------------"
