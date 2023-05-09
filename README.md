# docker-wireguard-transmission
# Description:
A containerized version of a VPN-bittorrent duo using the WireGuard VPN protocol and the Transmission bittorrent daemon, built using docker and docker-compose. This isolates the VPN from the host system so that only the torrent traffic is captured. Now featuring RPC SSL encryption by nginx!

Currently under re-construction and non-functional as-is.

# Notes:
- IPv6 is disabled and the WireGuard container will throw an error when it encounters any reference to IPv6. I do not trust IPv6.

# Instructions: 
1. Go to your VPN provider's website and generate a config file for your favorite WireGuard server. DO NOT include a killswitch as this is already present in the entrypoint.sh script. Edit out any references to IPv6 (variables Address, Endpoint) as well as any PostUp and PreDown killswitch rules. Copy the config file to the docker project folder as wg0.conf.
2. If you have a previous Transmission installation to transfer to the container, copy files like /etc/transmission-daemon/settings.json, /var/lib/transmission-daemon/info/dht.dat, and /var/lib/transmission-daemon/info/stats.json to the transmission folder inside the docker project. Otherwise, create a copy of settings.json with your desired options, and edit out the references to the other files from transmission.Dockerfile and docker-compose.yaml. 
3. Edit the wireguard section of docker-compose.yaml for your local subnet. If you don't wish to allow local network traffic, remove the LOCAL_SUBNET option.
4. Change the DNS entry in the wireguard section of docker-compose.yaml to match the DNS server in wg0.conf.
5. Edit the nginx section of docker-compose.yaml and nginx.conf to use your port of choice for encrypted RPC. I used 42069 as a placeholder because I am a mature adult. Be sure to adjust any necessary firewall or router rules.
6. Run the following commands to start the containers and check for errors:

    $ docker-compose build
    
    $ docker-compose up -d
    
    $ docker-compose logs wireguard
    
    $ docker-compose logs transmission

6. Log into your Transmission daemon remotely!

Many thanks to https://github.com/jordanpotter/docker-wireguard for helping figure out the WireGuard container, and for writing the entrypoint.sh script, which I've modified to remove IPv6.
