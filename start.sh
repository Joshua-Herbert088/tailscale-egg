#!/bin/bash

# 1. Auth key required
if [[ -z "$TAILSCALE_AUTH_KEY" ]]; then
  echo "❌ No TAILSCALE_AUTH_KEY set"
  exit 1
fi

# 2. Start tailscaled in userspace mode
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
sleep 2

# 3. Bring up the Tailscale connection
tailscale up \
  --authkey="$TAILSCALE_AUTH_KEY" \
  --hostname="josh-bam" \
  --ssh \
  --advertise-tags="tag:container"

# 4. Show status
tailscale status

# 5. Keep container running
tail -f /dev/null

bash
