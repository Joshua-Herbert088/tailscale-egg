#!/bin/bash

# Clone scripts from GitHub into the container's server directory
git clone https://github.com/Joshua-Herbert088/tailscale-egg.git .

# Make all shell scripts executable
chmod +x ./*.sh

echo "✅ Tailscale scripts are ready."
