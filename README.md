# docker-wireguard-transmission
# Description:
A containerized VPN-BitTorrent-nginx trio, using WireGuard VPN encryption for P2P traffic and SSL encryption for RPC access.

# Features:
- All BitTorrent traffic is encrypted through WireGuard VPN, which offers superior performance to OpenVPN.
- Containerization isolates VPN from host system, capturing only BitTorrent traffic. This is great for PCs since many websites block or restrict VPN users; turn your PC's VPN off and on as needed without needing to remember to stop and start your torrents every time. This is also great for servers as it prevents the VPN from capping your speed and uncomplicates hosting of other services.
- Uses Transmission as a BitTorrent daemon, which offers a web interface and robust remote interface apps for all platforms.
- All RPC traffic (remote access to Transmission) is encrypted with SSL using Nginx as a reverse HTTPS proxy.

# Instructions: 
1. Go to your VPN provider's website and generate an IPv4-only config file for your favorite WireGuard server. Name it wg0.conf and place it in wireguard/wg0.conf. Edit the file to include the following lines, if something similar isn't already included. This is a killswitch that prevents traffic from leaking outside of the WireGuard interface:
   
	$PostUp = DROUTE=$(ip route | grep default | awk '{print $3}'); HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route add $HOMENET3 via $DROUTE;ip route add $HOMENET2 via $DROUTE; ip route add $HOMENET via $DROUTE;iptables -I OUTPUT -d $HOMENET -j ACCEPT;iptables -A OUTPUT -d $HOMENET2 -j ACCEPT; iptables -A OUTPUT -d $HOMENET3 -j ACCEPT;  iptables -A OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT

	$PreDown = HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route del $HOMENET3 via $DROUTE;ip route del $HOMENET2 via $DROUTE; ip route del $HOMENET via $DROUTE; iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT; iptables -D OUTPUT -d $HOMENET -j ACCEPT; iptables -D OUTPUT -d $HOMENET2 -j ACCEPT; iptables -D OUTPUT -d $HOMENET3 -j ACCEPT

2. Fill out the .env file with your Transmission username and password, a forwarded port from your VPN for the peer port, and a random high number port (e.g. 42069) for RPC access.
3. Obtain a DDNS address and SSL certificates and place them in nginx/keys. I use AWS Route53 for DDNS and LetsEncrypt for SSL. If you lack these resources and want to do this for free, consider using linuxserver/swag in conjunction with duckdns as described in the SWAG documentation. This would effectively replace nginx for this project.
4. Update the transmission section of the docker-compose.yaml file with the desired location of your downloads folder.
5. Forward the RPC port in your router and local firewall. DO NOT forward the P2P port in your router or local firewall!
6. Run to start the containers:
	$ docker-compose up -d
7. Download your preferred remote access client for Transmission and log in to your new BitTorrent setup!
