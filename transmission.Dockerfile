FROM ubuntu:latest

# install transmission-daemon and dependencies
RUN apt-get update && apt-get install -y transmission-daemon

# copy the custom settings file
COPY transmission/settings.json /root/.config/transmission-daemon/settings.json

# mount the downloads volume
VOLUME /var/lib/transmission-daemon/info/resume /root/.config/transmission-daemon/resume

# optional - transfer torrents and stats from previous installation on host
COPY transmission/dht.dat /root/.config/transmission-daemon/dht.dat
COPY transmission/stats.json /root/.config/transmission-daemon/stats.json
VOLUME /var/lib/transmission-daemon/info/torrents /root/.config/transmission-daemon/torrents
VOLUME /var/lib/transmission-daemon/downloads /var/lib/transmission-daemon/downloads

# set the default command to start transmission-daemon
CMD ["transmission-daemon", "-f"]
