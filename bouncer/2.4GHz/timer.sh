#!/bin/bash
#created: 10/11/2020
#extension for bouncer!
#TIMER


TIME="time"
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
wifi=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
until [[ $TIME = 0 ]]; do
echo -en "$TIME\\"
sleep 1
TIME=$((TIME-1))
done

if [[ $? = 0 ]];then
tput bel
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/00:00:00:00:00:00/" enforcer.sh enforce4all.sh
echo -e "\e[91m"
rm -i attack realattack validate
echo -e "\e[00m"
sudo airmon-ng stop $wlan0 2>&1> /dev/null
sudo ip link set $wifi down 2>&1> /dev/null
sudo ip link set $wifi up 2>&1> /dev/null
sudo killall bouncer.sh
sudo killall xterm
sudo killall sleep
killall file.so
fi

