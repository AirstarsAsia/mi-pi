#!/bin/sh
### BEGIN INIT INFO
# Provides: tightvncserver
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start vnc server
# Description:
### END INIT INFO

. /lib/lsb/init-functions

# Carry out specific functions when asked to by the system
case "$1" in
start)
su pi -c 'vncserver :1 -geometry 1280x800 -depth 24'
echo "Starting VNC server "
;;
stop)
pkill Xtightvnc
echo "VNC Server has been stopped (didn't double check though)"
;;
*)
echo "Usage: /etc/init.d/tightvnc {start|stop}"
exit 1
;;
esac