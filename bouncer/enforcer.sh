#!/bin/bash
#created: 10/11/2020
#extension to bouncer!
if [[ ${UID} -ne 0 ]]; then
exit 1
fi
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
TRUSTED="FILE"
MYBSSID="00:00:00:00:00:00"
for mac in $(diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"); do
if [[ $mac = HWaddress ]]; then
echo "";clear
elif [[ $mac = "<" ]]; then
echo "";clear
else
sudo aireplay-ng  --deauth 100 -a $MYBSSID -c $mac $wlan0
fi
done
