FROM ubuntu:latest

# install transmission-daemon and dependencies
RUN apt update && apt install -y transmission-daemon

# set the default command to start transmission-daemon
CMD ["transmission-daemon", "-f"]
