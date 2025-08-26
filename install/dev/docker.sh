#!/bin/bash

# Ensure the group exists
echo " Creating or verifying 'docker' group…"
sudo groupadd -f docker

# Add user to docker group if not present
if id -nG "$USER" | grep -qw docker; then
  echo " User '$USER' is already in the 'docker' group."
else
  echo " Adding '$USER' to 'docker' group…"
  sudo usermod -aG docker "$USER"
  echo "⚠️  You’ll need to log out and back in for group changes to take effect!"
fi

if systemctl is-active --quiet docker.service; then
  echo " Docker service is already running."
else
  echo " Enabling and starting Docker service…"
  sudo systemctl enable --now docker.service docker.socket || true
fi