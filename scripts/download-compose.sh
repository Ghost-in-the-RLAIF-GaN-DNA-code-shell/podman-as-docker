#!/usr/bin/env bash
set -euo pipefail

DOWNLOAD_DIR="${DOWNLOAD_DIR:-$HOME/greenbone-community-container}"
mkdir -p "$DOWNLOAD_DIR"
COMPOSE_URL="https://greenbone.github.io/docs/latest/_static/compose.yaml"

echo "[+] Downloading official compose file to $DOWNLOAD_DIR/compose.yaml"
curl -fsSL -o "$DOWNLOAD_DIR/compose.yaml" "$COMPOSE_URL"

echo "[+] Download complete. Verify with: ls -la \"$DOWNLOAD_DIR/compose.yaml\""
