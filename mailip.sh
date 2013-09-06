#! /bin/bash

# The mailmyip script may have to wait quite long for
# the RTC to come up. So we're not going to wait for
# that script to end.

# Save this script in /etc/network/if-up.d

/usr/local/bin/mailmyip &