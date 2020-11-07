#!/bin/bash
#created: 10/11/2020
#extension for bouncer!/5GHz
#TIMER
 

wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
wifi=$(ip a | grep wl | head -1 | cut -d ":" -f 2)

EXIT () {
echo -e "\e[92m"
airmon-ng stop $wlan0
sleep 2
ip link set $wifi down && ip link set $wifi up
sleep 1
killall sleep
killall file.so
killall aireplay-ng
killall xterm
echo -e "\e[00m"
}

TIME="time"

until [[ $TIME = 0 ]]; do
echo -en "\e[92m$TIME\e[0m\\"
sleep 1
TIME=$((TIME-1))
done

if [[ $? = 0 ]];then
tput bel
echo -e "\e[91m"
killall bouncer5GHz.sh
rm realattack 5ghzstations-01.csv validate
echo -e "\e[00m"
fi
echo "Attack Finished!"
echo "Launch bouncer5GHz.sh again:? PRESS ENTER"
read -p "[e] KEY then ENTER to Exit! "
case $REPLY in
""|" ") sudo ./bouncer5GHz.sh ;;
*) EXIT ;;
esac
