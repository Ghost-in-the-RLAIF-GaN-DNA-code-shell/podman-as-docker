#!/usr/bin/env bash
set -euo pipefail

cat <<'NOTICE'
This repository is Podman-first. The automated Docker installer script has been removed to avoid accidental system changes.
If you intentionally want to install Docker, follow the manual instructions in README.md under "Alternate: Official Docker install".
NOTICE

exit 0
