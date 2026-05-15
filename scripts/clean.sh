#!/usr/bin/env bash
set -e

echo "[+] Stopping containers"
podman stop -a || true

echo "[+] Removing containers"
podman rm -a || true

echo "[+] Removing volumes"
podman volume prune -f

echo "[+] Removing networks"
podman network prune -f

echo "[+] Cleanup complete"
