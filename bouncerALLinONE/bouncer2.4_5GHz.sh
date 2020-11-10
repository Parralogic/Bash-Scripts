#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 11/10/2020
#Last Modified: 11/10/2020
clear

PS3="NIC? "
if [[ ${UID} -ne 0 ]]; then
	echo "Please run script as root/sudo!"
	sleep 3
	exit 1
fi

while [[ ${UID} = 0 ]]; do
echo "This script will deauthenticate unknown MAC addresses"
echo "from both your 2.4GHz & 5GHz AP/Router simultaneously!"
echo "In order for this script to work properly it requires:"
echo "Two WiFi adapters that are capable of packet injection"
echo "and one WiFi adapter connected to your WiFi AP/Router"
echo "or utilizing ethernet. Note! the obvious is having.."
echo "the two WiFi adapter to One being able to access the 5GHz"
echo "band."
echo
echo "RECAP:SETUP="
echo "3 WiFi adapters- 1 connected to your AP/Router.               "
echo -e "              1 capable of packet injection on 2.4GHz band."
echo -e "              1 capable of packet injection on 5GHz band.  "
echo
echo -e "                     OR"
echo
echo "2 WiFi adapters- 1 capable of packet injection on 2.4GHz band."
echo -e "              1 capable of packet injection on 5GHz band.  "
echo -e "              While connected via Ethernet to AP/Router.   "
echo
read -p "Do you meet the requirements!:? [y/n] " REQUIREMENTS
clear
case $REQUIREMENTS in
y|Y) break ;;
n|N) exit 1 ;;
*) echo "Only Y,y,N,n"
sleep 3; clear
esac
done
echo "Plug in the adapter that will be used for your 2.4GHz!"
read -p "Press Enter"
clear
echo "Lets select the WiFi adapter to be used for your 2.4GHz:"
echo "enp=Ethernet wl=Wifi lo=loopback" 
select nic24 in $(ls /sys/class/net); do
	NIC24=$nic24
read -p "Use $NIC24:? [y/n] " NIC
case $NIC in
y|Y) echo "Great! $NIC24 will be used"; sleep 2
echo "Now putting $NIC24 in monitor mode"; sleep 1
sudo airmon-ng start $NIC24 &> /dev/null
ip a | grep mon
echo
read -p "Input the 2.4GHzmon Name:? " mon24ghz
echo "OK... $mon24ghz is the 2.4GHz adapter that will be used" 
echo "to deauth 2.4GHz MACS!"
read -p "Press Enter"; break ;;
n|N) echo "Please re-select:" ;;
*) echo "Not valid!...only Y,y,N,n" ;;
esac
done
clear 
echo "Plug in the adapter that will be used for your 5GHz!"
read -p "Press Enter"
clear
echo "Now select the WiFi adapter to be used for your 5GHz:"
echo "enp=Ethernet wl=Wifi lo=loopback" 
select nic5 in $(ls /sys/class/net); do
	NIC5=$nic5
read -p "Use $NIC5:? [y/n] " NIC
case $NIC in
y|Y) echo "Great! $NIC5 will be used"; sleep 2
echo "Now putting $NIC5 in monitor mode"; sleep 1
sudo airmon-ng start $NIC5 &> /dev/null
ip a | grep mon
echo
echo "Your 2.4GHz is: $mon24ghz"
read -p "Input the 5GHzmon Name:? " mon5ghz
echo "OK... $mon5ghz is the 5GHz adapter that will be used" 
echo "to deauth 5GHz MACS!"
read -p "Press Enter"; break ;;
n|N) echo "Please re-select:" ;;
*) echo "Not valid!...only Y,y,N,n" ;;
esac
done
clear
echo "Lets gather the necessery info about your AP/Router:"
read -p "Press Enter"
xterm -e sudo airodump-ng --band abg $mon5ghz &
until [[ $REPLY = [yY]* ]]; do
clear
read -p "My 2.4GHz BSSID: " BSSID24
read -p "Channel: " CH24
echo
read -p "My 5GHz BSSID: " BSSID5
read -p "Channel: " CH5
echo
echo "My Info:"
echo -e "2.4GHz= $BSSID24 CH= $CH24\n"
echo -e "5GHz= $BSSID5 CH= $CH5\n"
read -p "Is the info correct:? "
done
killall airodump-ng

