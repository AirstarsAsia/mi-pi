#! /bin/bash

# mailmyip
#
# This script sends a mail every time the network comes up.
# The mail contains a time stamp and the obtained IP address.
#
# Author: San Bergmans
#         www.sbprojects.com
#

# Mutex, don't run if another instance is already running
PROG=$(echo $0 | awk -F/ '{ print $NF }')
if [ $(pgrep -c $PROG) -gt 1 ]; then
    # Already running. Simply exit
    exit 0
fi

# Configuration variables
RPINAME="Raspberry Pi"
MAILTO="you@example.com"

# Get current private IP address for eth0
PRIVATE=$(ifconfig eth0 | grep "inet addr:" | awk '{ print $2 }')
IPV6=$(ifconfig eth0 | grep "Scope:Global" | awk '{ print $3 }')
PRIVATE=${PRIVATE:5}

# Exit if IP address is empty
if [ -z $PRIVATE ]
then
    exit 0
fi

# Wait about 2 minutes for the RTC to be set after boot (in steps of 10 seconds)
for I in {1..12}
do
    sleep 10
    if [ $(date +%Y) != "1970" ]
    then
        # Yes! The clock is set. Find out what our public IP address is and send the message.
        PUBLIC=$(curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
        MSG="$(date +%F\ %T)\n$RPINAME now has IP-Address $PRIVATE.\nIts public address is $PUBLIC.\n$IPV6"
	echo -e $MSG | mail -s "$RPINAME just received a new IP address" "$MAILTO"
        exit 0
    fi
done