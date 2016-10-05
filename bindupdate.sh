#!/bin/bash

set -eu

#Replace the key and domain names your trying to update to suit


# fetch our current public IP
MY_IP="$(curl -s http://ip.appspot.com)"

#define interfaces
IFCW=wlan0
IFCE=eth0

#get the ip addesses
CMDW="$(ip addr show $IFCW | awk '/inet / {gsub(/\/.*/,"",$2); print $2}')"
CMDE="$(ip addr show $IFCE | awk '/inet / {gsub(/\/.*/,"",$2); print $2}')"

#set the vars to update records
MY_IPW=$CMDW
MY_IPE=$CMDE

# make sure we don't get some garbage
echo -n "$MY_IPW" | grep -qE '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b'
echo -n "$MY_IPE" | grep -qE '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b'
# update the RR
cat | nsupdate -v -k /home/user/dyDnsLocal/Kyourdomain.tld.+165+52993.private <<COMMANDS
server dns.yourdomain.tld
zone yourdomain.tld
update delete subd1.yourdomain.tld. A
update add subd1.yourdomain.tld 300 A $MY_IPW
update delete subd2.yourdomain.tld 300 A
update add subd2.yourdomain.tld 300 A $MY_IPE
show
send
COMMANDS
