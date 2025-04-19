#!/bin/bash

# Start the Tailscale daemon
tailscaled &

# Give it a second to boot
sleep 3

# Check for required environment variable
if [ -z "$TAILSCALE_AUTH_KEY" ]; then
  echo "❌ TAILSCALE_AUTH_KEY not set! Cannot proceed."
  exit 1
fi

# Authenticate and connect
tailscale up --authkey="$TAILSCALE_AUTH_KEY" --hostname=ptero-vpn --ssh

# Show status
tailscale status

# Keep container alive
tail -f /dev/null
