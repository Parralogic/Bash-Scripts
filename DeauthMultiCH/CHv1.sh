#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/27/2020
#Last Modified Date: 3/28/2020
clear

if [[ ${UID} -ne 0 ]]; then
echo "First run MASSDeauthAllch Script"
exit 1
fi

wlan0=`ip a | grep wl | head -1 | cut -d ":" -f 2`

for CH in `cat *.kismet.csv | awk -F ";" '{print $6}' | tail +2`; do
xterm -e sudo airodump-ng -c $CH $wlan0 &  
sleep 1
kill $!
done
