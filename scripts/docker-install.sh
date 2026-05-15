#!/usr/bin/env bash
set -euo pipefail

# Docker install helper for Debian/Parrot OS (run interactively as a user with sudo)
# WARNING: This script will remove conflicting packages (podman-docker, docker.io, containerd) before installing Docker Engine.

if ! command -v apt >/dev/null 2>&1; then
  echo "This script is intended for Debian-based systems with apt. Aborting."
  exit 1
fi

#echo "[+] Removing known conflicting packages (may prompt for sudo password)"
#for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
#  sudo apt remove -y "$pkg" || true
#done

#echo "[+] Adding Docker APT keyring and repository"
#sudo install -m 0755 -d /etc/apt/keyrings
#curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#sudo chmod a+r /etc/apt/keyrings/docker.gpg

#echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#echo "[+] Installing Docker Engine and compose plugin"
#sudo apt update
#sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "[+] Adding current user to docker group (you must log out and back in for this to take effect)"
sudo usermod -aG docker "$USER"

echo "[+] Docker installation not complete. Log out and log back in, then verify with: docker --version && docker compose version"
