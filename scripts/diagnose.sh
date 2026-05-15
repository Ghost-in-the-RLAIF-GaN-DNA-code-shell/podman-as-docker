#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOWNLOAD_DIR="${DOWNLOAD_DIR:-}"
COMPOSE_FILE=""
if [ -n "$DOWNLOAD_DIR" ]; then
  if [ -f "$DOWNLOAD_DIR/compose.yaml" ]; then
    COMPOSE_FILE="$DOWNLOAD_DIR/compose.yaml"
  elif [ -f "$DOWNLOAD_DIR/docker-compose.yml" ]; then
    COMPOSE_FILE="$DOWNLOAD_DIR/docker-compose.yml"
  fi
fi
if [ -z "$COMPOSE_FILE" ] && [ -f "$SCRIPT_DIR/compose.yaml" ]; then
  COMPOSE_FILE="$SCRIPT_DIR/compose.yaml"
fi

echo "=== Podman socket status ==="
systemctl --user status podman.socket --no-pager || true

echo "=== Disk Space ==="
df -h /var/lib/containers || df -h || true

echo "=== DNS Test ==="
getent hosts feed.community.greenbone.net || echo "DNS lookup failed"

echo "=== Feed Connectivity ==="
curl -I https://feed.community.greenbone.net --max-time 10 || echo "Feed unreachable"

echo "=== Running containers ==="
if command -v podman >/dev/null 2>&1; then
  podman ps || true
else
  docker ps || true
fi

if [ -n "$COMPOSE_FILE" ]; then
  echo "=== Compose file in use: $COMPOSE_FILE ==="
  if command -v podman-compose >/dev/null 2>&1; then
    echo "=== podman-compose ps ==="
    (cd "$(dirname "$COMPOSE_FILE")" && podman-compose ps) || true
  else
    echo "=== docker compose ps (via DOCKER_HOST) ==="
    (cd "$(dirname "$COMPOSE_FILE")" && docker compose ps) || true
  fi
fi

echo "=== SCAP / Notus recent logs (tail 200) ==="
if command -v podman >/dev/null 2>&1; then
  podman logs --tail 200 scap-data 2>/dev/null || true
  podman logs --tail 200 notus-data 2>/dev/null || true
else
  docker logs --tail 200 scap-data 2>/dev/null || true
  docker logs --tail 200 notus-data 2>/dev/null || true
fi
