#!/bin/bash

echo "🛑 Stopping Tailscale..."
tailscale logout
pkill tailscaled
