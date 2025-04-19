#!/bin/bash
apt update && apt install -y curl gnupg2 lsb-release
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list
apt update && apt install -y tailscale
