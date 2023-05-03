# docker-wireguard-transmission
# Description:
A containerized version of a VPN-bittorrent duo using the WireGuard VPN protocol and the Transmission bittorrent daemon, built using docker and docker-compose.

# Notes:
- This approach isolates the VPN from the host so that it only captures Transmission's traffic. If you want the VPN to capture traffic from the host PC, use "network: host" in the wireguard section of docker-compose.yaml.
- These files are optimized for someone who has a previous installation of Transmission on the host PC that they would like to containerize. It transfers all downloads, torrents, and statistics to the container.
- IPv6 is disabled and the WireGuard container will throw an error when it encounters any reference to IPv6.

# Instructions: 
1. Go to your VPN provider's website and generate a config file for your favorite WireGuard server. DO NOT include a killswitch as this is already present in the entrypoint.sh script. Edit out any references to IPv6 (variables Address, Endpoint) as well as any PostUp and PreDown killswitch rules. Copy the config file to the docker project folder as wg0.conf.
2. If you have a previous Transmission installation to transfer to the container, copy /etc/transmission-daemon/settings.json, /var/lib/transmission-daemon/info/dht.dat, and /var/lib/transmission-daemon/info/stats.json to the docker project folder. Otherwise, create a copy of settings.json with your desired options, and edit out the references to the other files from transmission.Dockerfile and docker-compose.yaml. 
3. Edit the wireguard section of docker-compose.yaml for your local subnet. If you don't wish to allow local network traffic, remove the LOCAL_SUBNET option.
4. Change the DNS entry in the wireguard section of docker-compose.yaml to match the DNS server in wg0.conf.
5. Run the following commands to start the containers and check for errors:

    $ docker-compose build
    
    $ docker-compose up -d
    
    $ docker-compose logs wireguard
    
    $ docker-compose logs transmission

6. Log into your Transmission daemon remotely!

Many thanks to https://github.com/jordanpotter/docker-wireguard for helping figure out the WireGuard container, and for writing the entrypoint.sh script, which I've modified to remove IPv6.

Future updates will:
1. Re-enable IPv6
2. Determine and select the fastest server
