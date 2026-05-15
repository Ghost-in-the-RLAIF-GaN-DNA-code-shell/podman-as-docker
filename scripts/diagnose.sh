#!/usr/bin/env bash
set -e

echo "=== Disk Space ==="
df -h /var/lib/containers || df -h

echo "=== DNS Test ==="
getent hosts feed.community.greenbone.net || echo "DNS lookup failed"

echo "=== Feed Connectivity ==="
curl -I https://feed.community.greenbone.net || echo "Feed unreachable"

echo "=== Container Health ==="
docker compose ps

echo "=== SCAP Logs ==="
docker compose logs scap-data | tail -n 50 || true
