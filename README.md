# Greenbone Community Edition on Podman
*A clean, reliable setup for running Greenbone/OpenVAS using Podman rootless containers.*

---

## 🚀 Overview

This repository provides a **Podman-first deployment** of the Greenbone Community Edition (OpenVAS). It is designed to run using Podman (rootless) and `podman-compose` where possible. The Docker instructions are included for users who intentionally want to switch to Docker, but this repository's default and recommended path is Podman.

---

## 🧩 Requirements

- Podman ≥ 4.0  
- podman-compose (recommended) or podman-docker (shim)  
- docker-compose plugin (optional but **not** recommended with Podman)  
- 15–20 GB free disk space  
- Stable internet connection  

---

## ⚙️ Installation (Podman, recommended)

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

## 🚦 Start Greenbone (Podman)

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

## 🔁 Alternate: Official Docker install (Parrot OS / Debian derivatives)

If you intentionally want to run the official Docker Engine (recommended by upstream Greenbone docs), follow these manual steps. Note: switching to Docker is a deliberate system change and is not recommended for users who want to keep a Podman-first environment.

**Prerequisites & Setup**

1. Install basic dependencies:

```bash
sudo apt update && sudo apt install -y curl ca-certificates gnupg
```

2. Install Docker Engine (this will remove conflicting Podman shim packages if present).
Run these commands manually and review them before executing:

```bash
# Remove conflicting packages (optional - run only if you intend to replace Podman with Docker)
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove -y $pkg; done

# Add Docker's official GPG key and repository
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine and the compose plugin
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

3. Add your user to the docker group so you can run Docker without sudo (log out and back in after this step):

```bash
sudo usermod -aG docker $USER
```

---

## 📥 Downloading and Running the Containers (Docker)

1. Create a directory to hold the compose file and related data:

```bash
export DOWNLOAD_DIR=$HOME/greenbone-community-container && mkdir -p "$DOWNLOAD_DIR"
```

2. Download the official `compose.yaml` provided by Greenbone (manual):

```bash
curl -fsSL -o "$DOWNLOAD_DIR/compose.yaml" https://greenbone.github.io/docs/latest/_static/compose.yaml
```

3. Pull images and start the stack using the Docker Compose plugin:

```bash
docker compose -f "$DOWNLOAD_DIR/compose.yaml" pull
docker compose -f "$DOWNLOAD_DIR/compose.yaml" up -d
```

---

## 🔑 Secure Your Admin Account (Docker)

Change the `admin` user's password immediately (replace `YourStrongPassword`):

```bash
docker compose -f "$DOWNLOAD_DIR/compose.yaml" exec -u gvmd gvmd gvmd --user=admin --new-password='YourStrongPassword'
```

If your password contains shell-sensitive characters, keep it wrapped in single quotes.

---

## 🌐 Accessing the Greenbone Security Assistant (GSA)

Open your browser and navigate to:

```
https://127.0.0.1
```

Accept the self-signed certificate warning for local installs.

---

## 🛠️ Troubleshooting (Common Docker fix)

If you encounter a `redis_socket_vol` or volume-related issue, stop the stack and remove the offending volume:

```bash
# Stop and remove the containers and network
docker compose -f "$DOWNLOAD_DIR/compose.yaml" down
# Remove the problematic volume
docker volume rm greenbone-community-container_redis_socket_vol
# Start again
docker compose -f "$DOWNLOAD_DIR/compose.yaml" up -d
```

---

## 🎯 Next Steps

This repository remains Podman-first. If you intentionally want Docker tooling, follow the manual instructions above. I removed the automated Docker installer from the scripts/ directory to avoid accidental system changes.
