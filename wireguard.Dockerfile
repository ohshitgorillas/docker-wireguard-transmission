FROM ubuntu:latest

# Install WireGuard and its dependencies
# also install findutils needed for find's -printf flag
RUN apt update && apt install -y \
    wireguard iproute2 iptables openresolv \
    wireguard-tools findutils

# Copy the wireguard config file and entrypoint script
COPY wireguard/wg0.conf /etc/wireguard/wg0.conf
COPY wireguard/entrypoint.sh /entrypoint.sh

# execute entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
