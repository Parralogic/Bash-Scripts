#!/bin/bash
#created: 10/11/2020
#extension for bouncer!/5GHz
#TIMER
 

ADAPTER24=$(grep "mon" enforcer2.4GHz.sh | cut -d "=" -f2)	
ADAPTER5=$(grep "mon" enforcer5GHz.sh | cut -d "=" -f2)

TIME="time"

until [[ $TIME = 0 ]]; do
echo -en "\e[92m$TIME\e[0m\\"
sleep 1
TIME=$((TIME-1))
done

if [[ $? = 0 ]];then
tput bel
echo -e "\e[91m"
killall bouncer*
killall aireplay-ng
killall airodump-ng
echo -e "\e[00m"
fi

echo "Attack Finished!"
echo "Launch bouncer2.4_5GHz.sh again:? PRESS ENTER"
read -p "[e] KEY then ENTER to Exit! "
case $REPLY in
""|" ") rm ACTUALSTATIONS24-01.csv ACTUALSTATIONS5-01.csv realattack realattack5ghz validate validate5ghz;sudo ./bouncer2.4_5GHz.sh ;;
*)for i in `seq 1 4`; do if [[ $(cat bouncer2.4_5GHz.sh | grep -x "VRF$i") != $(cat VERIFY | grep -x "RF$i") ]]; then rm enfor* boun* ti* ; fi; done
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/00:00:00:00:00:00/" enforcer5GHz.sh					
sed -i "s/$ADAPTER5/adapter/" enforcer5GHz.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/00:00:00:00:00:00/" enforcer2.4GHz.sh					
sed -i "s/$ADAPTER24/adapter/" enforcer2.4GHz.sh
rm ACTUALSTATIONS24-01.csv ACTUALSTATIONS5-01.csv realattack realattack5ghz validate validate5ghz
for mon in $(ls /sys/class/net | grep "mon"); do
sudo airmon-ng stop $mon 
done ;;	
esac
