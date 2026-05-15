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
- podman-compose (recommended) or podman-docker (shim)  
- docker-compose plugin (optional but **not** recommended with Podman)  
- 15–20 GB free disk space  
- Stable internet connection  

---

## ⚙️ Installation

### 1. Clone the repository

```bash
git clone https://github.com/Ghost-in-the-RLAIF-GaN-DNA-code-shell/podman-as-docker.git
cd podman-as-docker
```

### 2. Recommended: Use podman-compose (native)

`podman-compose` is the most compatible compose tool when running Podman. Install it using your distribution packages or pip:

```bash
# Debian/Ubuntu (if package available)
sudo apt install podman-compose
# or via pip (user)
python3 -m pip install --user podman-compose
```

### 3. Enable Podman’s Docker API socket (rootless)

```bash
systemctl --user enable --now podman.socket
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock
```

To make the DOCKER_HOST export permanent:

```bash
echo 'export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock' >> ~/.bashrc
```

---

## 🚦 Start Greenbone

This repo includes helper scripts in `scripts/` that perform sensible defaults and checks. The `start.sh` script prefers `podman-compose` and will fall back to `docker compose` if `podman-compose` is not present.

Basic start (from repo root):

```bash
./scripts/start.sh
```

If you prefer to run from a different download directory (for example following upstream community instructions), set DOWNLOAD_DIR:

```bash
export DOWNLOAD_DIR=$HOME/greenbone-community-container
./scripts/start.sh
```

This will:

- Ensure the Podman socket is active  
- Ensure a compose file exists (downloads one if missing)  
- Start the full Greenbone stack  
- Stream logs until all containers are healthy  

Access the UI:

👉 https://localhost:8443

Default credentials (change ASAP):

- **admin / admin**

---

## 🧹 Cleanup

```bash
./scripts/clean.sh
```

This removes containers, volumes and networks created by the stack. The script prefers `podman-compose down` when available and falls back to safe `podman` commands.

---

## 🩺 Diagnose Issues

```bash
./scripts/diagnose.sh
```

This checks:

- Podman socket and service status  
- Disk space  
- DNS  
- Feed connectivity  
- Container health and recent SCAP/Notus logs  

---

## 🧠 Podman notes and gotchas

- The official `docker compose` plugin is Docker Engine specific. It may work with `podman-docker` for many cases, but networking and API edge cases make `podman-compose` the recommended option.
- Rootless Podman cannot bind privileged ports (<1024). This repo exposes Greenbone on port **8443** to avoid that restriction.
- `podman-compose` may handle network aliases slightly differently; if services cannot resolve each other create a network manually:

```bash
podman network create greenbone-net
```

---

## 🧰 compose.yaml

The repository includes a compose file `compose.yaml` that uses port **8443** (rootless‑safe), health checks, and official Greenbone community images.

---

## 🎯 Next Steps

Choose what you want next:

- **Generate a GitHub release-ready ZIP**  
- **Add systemd user services for auto‑start**  
- **Add monitoring with health dashboards**  

Or tell me any changes you want and I’ll update the repo.
