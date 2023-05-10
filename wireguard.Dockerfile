FROM ubuntu:latest

# Install necessary packages
RUN apt update && apt install -y \
    wireguard iproute2 iptables openresolv \
    wireguard-tools findutils python3 iputils-ping

# Copy the wireguard config file and entrypoint script
COPY wireguard/entrypoint.sh /entrypoint.sh
COPY wireguard/select_server.py /select_server.py

# execute entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
