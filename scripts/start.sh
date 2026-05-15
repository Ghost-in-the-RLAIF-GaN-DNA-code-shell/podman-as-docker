#!/usr/bin/env bash
set -e

export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock

echo "[+] Starting Podman socket"
systemctl --user enable --now podman.socket

echo "[+] Starting Greenbone stack"
docker compose up -d

echo "[+] Streaming logs (Ctrl+C to exit)"
docker compose logs -f
