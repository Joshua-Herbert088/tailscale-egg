#!/bin/bash
echo "🛑 stop.sh: Initiating Tailscale shutdown..."

# Kill Tailscale if it's running
TS_PID=$(pgrep -x tailscaled)
if [[ -n "$TS_PID" ]]; then
  echo "🔪 Killing tailscaled (PID: $TS_PID)"
  kill "$TS_PID"
fi

# Bring the interface down
./tailscale --socket=tailscaled.sock down

echo "✅ Tailscale stopped successfully."