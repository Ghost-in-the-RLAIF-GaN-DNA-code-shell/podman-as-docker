#!/usr/bin/env bash
set -euo pipefail

# Robust start script that prefers podman-compose but falls back to docker compose
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOWNLOAD_DIR="${DOWNLOAD_DIR:-}" 
if [ -n "$DOWNLOAD_DIR" ]; then
  mkdir -p "$DOWNLOAD_DIR"
  # prefer compose file in DOWNLOAD_DIR if present
  if [ -f "$DOWNLOAD_DIR/docker-compose.yml" ]; then
    COMPOSE_FILE="$DOWNLOAD_DIR/docker-compose.yml"
  elif [ -f "$DOWNLOAD_DIR/compose.yaml" ]; then
    COMPOSE_FILE="$DOWNLOAD_DIR/compose.yaml"
  else
    # fall back to repo's compose.yaml
    COMPOSE_FILE="$SCRIPT_DIR/compose.yaml"
  fi
else
  COMPOSE_FILE="$SCRIPT_DIR/compose.yaml"
fi

echo "[+] Using compose file: $COMPOSE_FILE"

# If compose file missing, attempt to download the official one (best-effort)
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "[!] Compose file not found at $COMPOSE_FILE - attempting to download official compose file into directory"
  mkdir -p "$(dirname "$COMPOSE_FILE")"
  curl -fsSL -o "$COMPOSE_FILE" "https://community.greenbone.net/docker-compose.yml" || {
    echo "[!] Failed to download compose file; please place a compose YAML at $COMPOSE_FILE and retry"
    exit 1
  }
  echo "[+] Downloaded compose file to $COMPOSE_FILE"
fi

echo "[+] Ensuring podman.socket is running (user)" 
systemctl --user enable --now podman.socket || true

# Choose compose command
if command -v podman-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(podman-compose -f "$COMPOSE_FILE")
  echo "[+] Using podman-compose"
else
  echo "[!] podman-compose not found; trying docker compose with Podman socket (may be less reliable)"
  export DOCKER_HOST="unix:///run/user/$(id -u)/podman/podman.sock"
  COMPOSE_CMD=(docker compose -f "$COMPOSE_FILE")
fi

echo "[+] Pulling images"
"${COMPOSE_CMD[@]}" pull

echo "[+] Bringing up containers"
"${COMPOSE_CMD[@]}" up -d

echo "[+] Streaming logs (Ctrl+C to exit)"
"${COMPOSE_CMD[@]}" logs -f
