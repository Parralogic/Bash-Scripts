#!/bin/bash
#created: 10/11/2020
#extension for bouncer!/5GHz
#TIMER
 

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
killall airodump-ng
echo -e "\e[00m"
fi
echo "Attack Finished!"
echo "Launch bouncer2.4_5GHz.sh again:? PRESS ENTER"
read -p "[e] KEY then ENTER to Exit! "
case $REPLY in
""|" ") sudo ./bouncer2.4_5GHz.sh ;;
*) EXIT ;;
esac
