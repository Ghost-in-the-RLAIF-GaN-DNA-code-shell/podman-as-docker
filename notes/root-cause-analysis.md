# Root Cause Analysis

This document explains common failure modes encountered when running Greenbone containers under rootless Podman and mitigations.

Topics included:

- Port 443 privilege issues under rootless Podman
- Podman network corruption and how to reset
- Missing DOCKER_HOST and Docker API socket
- Common misconfigurations in compose files

(Expand this document in your fork with system-specific notes.)
