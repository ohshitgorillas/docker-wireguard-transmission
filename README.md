# docker-wireguard-transmission
A docker container for a WireGuard VPN client connection to a remote server, and a Transmission bittorrent daemon in a separate container which routes all traffic through the VPN.

Notes:
- These files are optimized for someone who has a previous installation of Transmission on the host PC that they would like to containerize. It transfers all downloads, torrents, and statistics to the container.
- IPv6 is disabled and the WireGuard container will throw an error when it encounters a reference to IPv6 in the wg0.conf file.


1. Go to your VPN provider's website and generate a config file for your favorite WireGuard server. DO NOT include a killswitch as this is already present in the entrypoint.sh script. Edit out any references to IPv6. Copy the config file to the docker project folder and name it wg0.conf.
2. If you have a previous installation of Transmission, ensure that the links in transmission.Dockerfile and docker-compose.yaml are appropriate for your setup.
3. Copy the settings file from /etc/transmission-daemon/settings.json to the docker project folder. If you don't have a settings file, create the file from scratch or find one online and edit it to your liking.
4. Edit the wireguard section of docker-compose.yaml for your local subnet. If you don't wish to allow local network traffic, remove the LOCAL_SUBNET option.
5. Change the dns: entry in the wireguard section of docker-compose.yaml to match the DNS entry in wg0.conf.
6. Run the following commands to start the containers and check for errors:
  # docker-compose build
  # docker-compose up -d
  # docker-compose logs wireguard
  # docker-compose logs transmission
7. Log into your Transmission daemon remotely and start downloading!

Many thanks to:
- https://github.com/jordanpotter/docker-wireguard for helping figure out the WireGuard container, and for writing the entrypoint.sh script, which I've modified to remove IPv6

Future updates will (hopefully) include a method of selecting the fastest server.
