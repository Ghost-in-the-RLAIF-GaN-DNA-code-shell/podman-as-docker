# Greenbone Community Edition on Podman
*A clean, reliable setup for running Greenbone/OpenVAS using Podman rootless containers.*

---

## 🚀 Overview

This repository provides a **fully working Podman‑based deployment** of the Greenbone Community Edition (OpenVAS).  
It fixes the most common issues:

- Rootless Podman cannot bind to port **443**  
- Docker Compose compatibility requires **DOCKER_HOST**  
- Podman does not remove networks/volumes automatically  
- SCAP/Notus containers often become **unhealthy** during initial sync  

This repo gives you a **stable, reproducible setup** that works on Debian, Parrot OS, Ubuntu, Fedora, and any system with Podman.

---

## 🧩 Requirements

- Podman ≥ 4.0  
- podman-docker (for Docker API compatibility)  
- docker-compose plugin (optional but recommended)  
- 15–20 GB free disk space  
- Stable internet connection  

---

## ⚙️ Installation

### 1. Clone the repository

```bash
git clone https://github.com/Ghost-in-the-RLAIF-GaN-DNA-code-shell/podman-as-docker.git
cd podman-as-docker
```

### 2. Enable Podman’s Docker API socket

```bash
systemctl --user enable --now podman.socket
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock
```

To make this permanent:

```bash
echo 'export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock' >> ~/.bashrc
```

---

## 🚦 Start Greenbone

```bash
./scripts/start.sh
```

This will:

- Ensure the Docker API socket is active  
- Start the full Greenbone stack  
- Stream logs until all containers are healthy  

Access the UI:

👉 https://localhost:8443

Default credentials:

- **admin / admin**

---

## 🧹 Cleanup

```bash
./scripts/clean.sh
```

This removes:

- Containers  
- Volumes  
- Networks  
- Stale Podman references  

Useful when the stack becomes inconsistent.

---

## 🩺 Diagnose Issues

```bash
./scripts/diagnose.sh
```

This checks:

- Disk space  
- DNS  
- Feed connectivity  
- SCAP/Notus logs  
- Container health  

---

## 🧠 Common Problems

See:

- **notes/root-cause-analysis.md**  
- **notes/scap-data-issues.md**

These explain:

- Why SCAP containers become unhealthy  
- Why Podman networks get stuck  
- Why port 443 fails under rootless mode  
- How to fix corrupted dependency graphs

---

## 🛠️ compose.yaml

This compose file:

- Uses port **8443** (rootless‑safe)  
- Works with Podman’s Docker API  
- Includes health checks  
- Uses official Greenbone community containers

---

# 🧰 scripts/clean.sh

The helper scripts in `scripts/` are provided with a POSIX-friendly shebang; after cloning you may want to `chmod +x scripts/*.sh` so they are executable.

---

# 🎯 Next Steps

Choose what you want next:

- **Generate a GitHub release-ready ZIP**  
- **Add systemd user services for auto‑start**  
- **Add monitoring with health dashboards**  

Or tell me any changes you want and I’ll update the repo.
