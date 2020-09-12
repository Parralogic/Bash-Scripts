#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/28/2020
#Last Modified Date: 3/29/2020 
clear

if [[ ${UID} -ne 0 ]]; then
echo "First run MASSDeauthAllch Script"
exit 1
fi

wlan0=`ip a | grep wl | head -1 | cut -d ":" -f 2`

for CH in `cat *.kismet.csv | awk -F ";" '{print $6}' | tail +2`; do

if [[ $CH = 1 ]]; then
xterm -e sudo airodump-ng -c 1 $wlan0 &  
sleep 1; sleep .5
kill $!

elif [[ $CH = 2 ]]; then
xterm -e sudo airodump-ng -c 2 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 3 ]]; then
xterm -e sudo airodump-ng -c 3 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 4 ]]; then
xterm -e sudo airodump-ng -c 4 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 5 ]]; then
xterm -e sudo airodump-ng -c 5 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 6 ]]; then
xterm -e sudo airodump-ng -c 6 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 7 ]]; then
xterm -e sudo airodump-ng -c 7 $wlan0 &
sleep 1 ; sleep .5
kill $!

elif [[ $CH = 8 ]]; then
xterm -e sudo airodump-ng -c 8 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 9 ]]; then
xterm -e sudo airodump-ng -c 9 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 10 ]]; then
xterm -e sudo airodump-ng -c 10 $wlan0 &
sleep 1; sleep .5 
kill $!

elif [[ $CH = 11 ]]; then
xterm -e sudo airodump-ng -c 11 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 12 ]]; then
xterm -e sudo airodump-ng -c 12 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 13 ]]; then
xterm -e sudo airodump-ng -c 13 $wlan0 &
sleep 1; sleep .5
kill $!

elif [[ $CH = 14 ]]; then
xterm -e sudo airodump-ng -c 14 $wlan0 &
sleep 1; sleep .5 
kill $!
fi

done
