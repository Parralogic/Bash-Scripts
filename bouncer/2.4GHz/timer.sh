#!/bin/bash
#created: 10/11/2020
#extension for bouncer!
#TIMER


TIME="time"
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
wifi=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
until [[ $TIME = 0 ]]; do
echo -en "$TIME\\"
TIME=$((TIME-1))
sleep 1
done

if [[ $? = 0 ]];then
sed -i "s|/[a-z|A-Z]*/[a-z|A-Z]*/[a-z|A-Z]*|FILE|" enforcer.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/00:00:00:00:00:00/" enforcer.sh enforce4all.sh
sudo airmon-ng stop $wlan0 2>&1> /dev/null
sudo ip link set $wifi down 2>&1> /dev/null
sudo ip link set $wifi up 2>&1> /dev/null
sudo killall bouncer.sh
sudo killall xterm
sudo killall sleep
fi

