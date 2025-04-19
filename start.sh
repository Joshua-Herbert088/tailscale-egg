#!/bin/bash

sudo curl -fsSL https://tailscale.com/install.sh | sh

# Start the Tailscale daemon in the background
tailscaled &

# Wait for it to start up
sleep 3

# Ensure auth key is provided
if [ -z "$TAILSCALE_AUTH_KEY" ]; then
  echo "❌ TAILSCALE_AUTH_KEY is not set!"
  exit 1
fi

# Start Tailscale and join the network
tailscale up --authkey="$TAILSCALE_AUTH_KEY" --hostname=ptero-vpn --accept-routes

# Show connection status
tailscale status

# Keep the container running
tail -f /dev/null
