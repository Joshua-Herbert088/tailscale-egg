FROM ghcr.io/parkervcp/yolks:ubuntu

RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://tailscale.com/install.sh | sh && \
    apt-get clean
