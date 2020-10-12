#!/bin/bash
#created: 10/11/2020
#extension for bouncer!
#TIMER
TIME="time"
until [[ $TIME = 0 ]]; do
echo -en "$TIME\\"
sleep 1
TIME=$(($TIME-1))
done
if [[ $? = 0 ]];then
#sed -i "s|/*/*/*|FILE|" enforcer.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/00/" enforcer.sh
sudo killall bouncer.sh
fi

