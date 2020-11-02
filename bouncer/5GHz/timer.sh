#!/bin/bash
#created: 10/11/2020
#extension for bouncer!/5GHz
#TIMER
 
 
TIME="time"
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
wifi=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
until [[ $TIME = 0 ]]; do
echo -en "\e[92m$TIME\e[0m\\"
sleep 1
TIME=$((TIME-1))
done

if [[ $? = 0 ]];then
tput bel
echo -e "\e[91m"
sudo killall bouncer5GHz.sh
rm realattack 5ghzstations-01.csv
sudo airmon-ng stop $wlan0 
sudo ip link set $wifi 
sudo ip link set $wifi
sudo killall xterm
sudo killall sleep
killall file.so
PID=$(ps -e | grep aireplay-ng | cut -d " " -f 3)
sudo kill $PID
echo -e "\e[00m"
fi
