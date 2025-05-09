#!/bin/bash

cd /home/container || exit 1

# Ensure stop.sh runs on signal
trap 'bash /home/container/stop.sh' SIGINT SIGTERM

# 1. Check for Tailscale auth key
if [[ -z "$TAILSCALE_AUTH_KEY" ]]; then
  echo "❌ ERROR: TAILSCALE_AUTH_KEY is not set. Exiting."
  exit 1
fi

# 2. Detect architecture (default to amd64)
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  arm*) ARCH="arm" ;;
  i386|i686) ARCH="386" ;;
esac

# 3. Download Tailscale static binaries if not already present
TS_VERSION="1.82.5"
TARBALL="tailscale_${TS_VERSION}_${ARCH}.tgz"
TS_DIR="tailscale_${TS_VERSION}_${ARCH}"

if [[ ! -d "$TS_DIR" ]]; then
  echo "🔽 Downloading Tailscale $TS_VERSION for $ARCH..."
  curl -fsSL "https://pkgs.tailscale.com/stable/${TARBALL}" -o "$TARBALL" || {
    echo "❌ Failed to download Tailscale archive."
    exit 1
  }
  mkdir -p "$TS_DIR"
  tar -xzf "$TARBALL" -C "$TS_DIR" --strip-components=1
fi

cd "$TS_DIR" || exit 1

# Start tailscaled in the background
./tailscaled --tun=userspace-networking \
  --state=tailscaled.state \
  --socket=tailscaled.sock \
  --socks5-server=localhost:1055 &

TAILSCALED_PID=$!

# Wait a bit to ensure tailscaled has started
sleep 2

# Run tailscale up
./tailscale --socket=tailscaled.sock up \
  --auth-key="$TAILSCALE_AUTH_KEY" \
  --hostname="josh-bam" \
  --ssh \
  --advertise-tags="tag:container" \
  --advertise-exit-node || {
    echo "❌ tailscale up failed"
    kill $TAILSCALED_PID
    exit 1
}

# Optional: show connection status
./tailscale --socket=tailscaled.sock status

# Wait for tailscaled to exit
wait $TAILSCALED_PID
