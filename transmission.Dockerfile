FROM alpine:latest

# install transmission-daemon and dependencies
RUN apk add --no-cache transmission-daemon

# set the default command to start transmission-daemon
CMD ["transmission-daemon", "-f"]
