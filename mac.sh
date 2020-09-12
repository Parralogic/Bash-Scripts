#!/bin/bash
clear
echo
ip address 
echo
echo
echo "Enter the name of the interface, to change the MAC Address:"
read interface
read -p "How many times do you wanna change the MAC Address?:" times
echo
clear
echo "Please wait now changing MAC"
until [[ $times = 0 ]]; do
sudo ip link set $interface down
sudo macchanger -A $interface | echo $interface `tail -1`
sudo ip link set $interface up
sleep 6
times=$(($times-1))
done
