#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOWNLOAD_DIR="${DOWNLOAD_DIR:-}"

# prefer podman-compose down if available and a compose file exists
if command -v podman-compose >/dev/null 2>&1 && [ -n "$DOWNLOAD_DIR" -a -f "$DOWNLOAD_DIR/compose.yaml" ]; then
  echo "[+] Using podman-compose to stop and remove the stack"
  (cd "$DOWNLOAD_DIR" && podman-compose down --remove-volumes || true)
elif command -v podman-compose >/dev/null 2>&1 && [ -f "$SCRIPT_DIR/compose.yaml" ]; then
  echo "[+] Using podman-compose to stop and remove the stack (repo compose.yaml)"
  (cd "$SCRIPT_DIR" && podman-compose down --remove-volumes || true)
else
  echo "[+] Podman-compose not available or compose file not found - falling back to stopping all containers (safe mode)"
  podman ps -q | xargs -r podman stop
  podman ps -a -q | xargs -r podman rm
  echo "[+] Removing volumes"
  podman volume prune -f || true
  echo "[+] Removing networks"
  podman network prune -f || true
fi

echo "[+] Cleanup complete"
