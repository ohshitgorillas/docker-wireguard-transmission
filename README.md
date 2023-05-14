# docker-wireguard-transmission
# Description:
A containerized version of a VPN-bittorrent duo with full encryption for P2P and RPC data.

# Features:
- All BitTorrent traffic is encrypted through WireGuard VPN, which offers superior speeds to OpenVPN.
- Uses Python to ping and select the fastest server (lowest latency) if several WireGuard config files are supplied.
- Containerization isolates VPN from host system, capturing only BitTorrent traffic. Host system services are unaffected and uncomplicated by the VPN.
- Uses Transmission as a BitTorrent daemon, which offers a web interface and robust interface apps for all platforms.
- All RPC traffic (remote access to Transmission) is encrypted with SSL using Nginx as a reverse HTTPS proxy.
- IPv6 is disabled for security purposes. I do not trust IPv6.

# Instructions: 
1. Go to your VPN provider's website and generate a config file for your favorite WireGuard servers. A killswitch is already present in the entrypoint.sh script, so don't add one to your WireGuard configs or they will block local network traffic. Check out the files and edit out any references to IPv6 (variables Address, Endpoint) as well as any PostUp and PreDown killswitch rules. Copy the config files to wireguard/configs.
2. If you have a previous Transmission installation to transfer to the container, copy files like /etc/transmission-daemon/settings.json, /var/lib/transmission-daemon/info/dht.dat, and /var/lib/transmission-daemon/info/stats.json to the transmission folder inside the docker project. Otherwise, create a copy of settings.json with your desired options, username, and password. Be sure to set the RPC whitelist options correctly, otherwise you won't be able to connect.
3. Edit the wireguard section of docker-compose.yaml for your local subnet. If you don't wish to allow local network traffic, remove the LOCAL_SUBNET option.
4. Change the DNS entry in the wireguard section of docker-compose.yaml to match the DNS server in your WireGuard configuration files.
5. Edit the nginx section of docker-compose.yaml and nginx.conf to use your port of choice for encrypted RPC. I used 42069 as a placeholder because I am a mature adult.
6. Generate SSL certificates and place them in nginx/ssl.
7. Adjust any local or network firewall rules to open the P2P port forwarded by your VPN and the HTTPS port selected for nginx.
8. Run the following commands to start the containers:

    $ docker-compose build
    
    $ docker-compose up -d

9. Log into your Transmission daemon remotely! Be sure to select SSL or HTTPS in the remote connection options. 

Many thanks to https://github.com/jordanpotter/docker-wireguard for helping figure out the WireGuard container, and for writing the entrypoint.sh script, which I've modified to remove IPv6 and to select the fastest server from multiple options.
