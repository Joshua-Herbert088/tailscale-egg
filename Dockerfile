FROM ghcr.io/parkervcp/yolks:ubuntu

# Install Tailscale
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release && \
    curl -fsSL https://tailscale.com/install.sh | sh && \
    apt-get clean
