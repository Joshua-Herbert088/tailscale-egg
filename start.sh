#!/bin/bash
tailscale up --authkey=${TAILSCALE_AUTH_KEY} --hostname=ptero-vpn
tailscale status
sleep infinity
