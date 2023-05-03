FROM ubuntu:latest

# Install WireGuard and other necessary packages
RUN apt-get update && apt-get install -y \
    wireguard iproute2 iptables openresolv \
    wireguard-tools findutils 

# Copy the config file
COPY wireguard/wg0.conf /etc/wireguard/wg0.conf

# Copy entrypoint script
COPY wireguard/entrypoint.sh /entrypoint.sh

# execute entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
