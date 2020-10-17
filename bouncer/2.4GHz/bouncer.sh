#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 10/10/2020
#Last Modified: 10/16/2020
clear

    enforcer () {
exec xterm -iconic -e sudo airodump-ng -c $CH $wlan0 &
sleep .5
kill $!
read -p "Run enforcer every ?min/?Hour: (m/h) "
if [[ $REPLY = h ]]; then
read -p "enforcer will launch every # hours:? " HOUR
let "hour= 60 * 60"
let "TIME= $hour * $HOUR"
else
read -p "enforcer will launch every # min:? " MIN
let "min= 60 * 1" ##
let "TIME= $min * $MIN"
fi
echo
echo -e "How long do you really wanna keep the"
read -p "attack/enforcer going for:?(m/h) "
if [[ $REPLY = h ]]; then
read -p "enforcer will keep running for # hours:? " STOPh
STOPTIME=$((60 * $STOPh * 60))
else
read -p "enforcer will keep running for # min:? " STOPm
STOPTIME=$(( 60 * $STOPm ))
fi
sed -i "s|FILE|$TRUSTED|" enforcer.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$MYBSSID/" enforcer.sh enforce4all.sh
sed -i "s/time/$STOPTIME/" timer.sh               #Area to fix time!
exec sudo xterm -geometry 60x2 -e ./timer.sh &
#fi
while true; do
for mac in $(diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"); do
if [[ $mac = HWaddress ]]; then
sed -i "s/$STOPTIME/$STOPTIME/" timer.sh
elif [[ $mac = "<" ]]; then                       #Area to fix time!
sed -i "s/$STOPTIME/$STOPTIME/" timer.sh
elif [[ $mac = enp* ]];then
sed -i "s/$STOPTIME/$STOPTIME/" timer.sh
else
echo $mac
echo "Because the above MAC is not trusted enforcer will;" 
echo "disconnect all untrust MAC's! One by One." 
echo "enforcer will run every $TIME sec"
echo "For $STOPTIME sec"
echo "You do the math" #remember ;)
sudo xterm -e ./enforcer.sh &
PID=$!
sleep $TIME
kill $PID 2>&1> /dev/null
sed -i "s/$STOPTIME/time/" timer.sh  #enforcer.sh             #Area to fix time!
fi
done
done
}

if [[ ${UID} -ne 0 ]]; then
echo run as root/sudo
exit 1
fi
for app in arp nmap xterm macchanger aircrack-ng ; do
command -v $app 2>&1> /dev/null
if [[ $? = 0 ]]; then
echo -e "\e[92mGreat!\e[00m $app installed"
else echo -e "\e[91m$app\e[00m not installed :("
echo "Script will not work without $app!!"
echo "Or will not work correctly!!"
fi
done
echo
echo "You need two WiFi adapters one that can"
echo "be put in monitor mode with packet injection,"
echo "and the other connected to your WiFi OR"
echo "One WiFi adapter with monitor & packet injection"
echo "while connected to your router using ethernet."
read -p "Do you meet the requirements:?(y/n) "
if [[ $REPLY = [nN]* ]];then
exit 1
fi
    macfile () {
    while true; do
    read -p "Full path of trusted MAC file:?" TRUSTED
    if [[ -f $TRUSTED  ]];then
    break
    fi
    done
    }
echo
echo "This script will auto disconnect/deauthenticate:"
echo "Unknown wireless clients from your wireless network"
echo "Provided with a list of accepted MAC addresses"
read -p "Full path of trusted MAC file:?" TRUSTED
if [[ -f $TRUSTED ]];then
echo -e "\e[92m$TRUSTED\e[00m will be used to filter out unknown MAC's"
else
echo -e "\e[91m$TRUSTED\e[00m does not exist!"
macfile
fi
echo
echo  "Xterm will open to gather info"
echo  "about your Router/AP"
echo  "#Select WiFi interface to deploy enforcer/4all:#"
echo  "enp=Ethernet wl=WiFi lo=loopback address"
select NETWORK in $(ls /sys/class/net);do
ADAPTER=$NETWORK
read -p "Use $ADAPTER:?(y/n) " CHOICE
case $CHOICE in
y|Y) break ;;
n|N) echo  "Re-Select" ;;
*) echo "Only (y/n) re-select interface." ;;
esac
done
clear
sudo airmon-ng start $ADAPTER 2>&1> /dev/null
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down 2>&1> /dev/null
sudo macchanger -A $wlan0  2>&1> /dev/null
sudo ip link set $wlan0 up 2>&1> /dev/null
exec xterm -hold -e sudo airodump-ng $wlan0 &
PID=$!
echo -e "\e[33mWarning!\e[00m must use proper MAC address format: \e[5m00:00:00:00:00:00\e[00m!"
echo -e "OR enforcer/enforce4all will break! Take note of the numbers used on the mac address.."
echo "Example: AA:BB:10:20:EE:60, do not use 10,20,or 60 as deauth count!" 
echo -e "just to make sure nothing breaks.\n"
read -p "What's your Router/AP WiFi Channel:? " CH
read -p "What's your Router/AP BSSID MAC Address:? " MYBSSID
sleep 2
kill $PID
SUBNET=$(ip a | grep dynamic | cut -d " " -f8)
if [[ $SUBNET = 192.168.1.255 ]];then
SUBNET=192.168.1.1
else
SUBNET=192.168.0.1
fi
echo "Please wait..gathering info about your network:" 
arp -n 2>&1> /dev/null
arp -n 2>&1> /dev/null
arp -a 2>&1> /dev/null
sleep 2
GATEWAY_MAC=$(arp -a | grep "$SUBNET" | grep gateway | cut -d " " -f4)
echo
echo -e "Your Subnet:\e[92m$SUBNET-254\e[00m"
echo -e "Your Router/AP MAC:\e[92m$GATEWAY_MAC\e[00m\n"
echo  "Bouncer script will use this configuration:"
echo  "Note your Router/AP MAC will differ from AP/BSSID" 
echo  "This script will use nmap to scan your network"
echo  "and populate the arp table with mac addresses,"
echo  "then aireplay-ng will use the generated mac list using"
echo  "arp -a [net-tools package] in conjunction with diff to identify" 
echo  "the differences in macs to deauthenticate"
echo  "based on the trusted mac list provided!"
echo
echo -e "Subnet:\e[92m$SUBNET\e[00m"
echo -e "Router/AP:\e[92m$GATEWAY_MAC\e[00m" 
echo -e "AP/BSSID:\e[92m$MYBSSID\e[00m"
read -p "Press Enter to Continue!"
SUBNET=$(ip a | grep dynamic | cut -d " " -f8)
if [[ $SUBNET = 192.168.1.255 ]];then
SUBNET=192.168.1.1
else
SUBNET=192.168.0.1
fi
echo -e "Please wait..will take a min..!"
echo -e "\033[32m"
nmap $SUBNET-254 -F -r -vv
echo -e "\033[00m"
sleep 6
echo -e "\e[91m"
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<" > untrust
cat untrust | cut -d " " -f2 > untrustmac
echo -e "\e[00m"
echo "Note the above MAC's are untrusted! they will be attacked!!"
echo
echo  "Run enforcer or enforce4all:?"
echo
echo -e "\033[34menforcer\e[00m= Uses a time script!"
echo
echo -e "\033[34menforce4all\033[00m= No time script! just a one time"
echo  "mass-deauthentication on all" 
echo  "unknown clients/macs at the same time!"
echo
read -p "1=enforcer 2=enforce4all (1 or 2) "
echo
case $REPLY in
2)
#if [[ $REPLY = 2 ]]; then
while true; do
echo -e "Your MAC Address: $MYBSSID"
echo -e "Example: AA:BB:10:20:EE:60, do not use 10,20,or 60.."
echo -e "as deauth count! just to make sure nothing breaks."
read -p "Deauth Count:? " COUNT
if [[ $COUNT = 0 ]]; then
COUNT=COUNT
elif [[ $COUNT = 1 ]]; then
COUNT=COUNT
elif [[ $COUNT = 2 ]]; then
COUNT=COUNT
elif [[ $COUNT = 10 ]]; then
COUNT=COUNT
elif [[ $COUNT = 11 ]]; then
COUNT=COUNT
elif [[ $COUNT = 20 ]]; then
COUNT=COUNT
clear
fi
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$MYBSSID/" enforcer.sh enforce4all.sh
sed -i "s/COUNT/$COUNT/" enforce4all.sh
exec xterm -iconic -e sudo airodump-ng -c $CH $wlan0 &
sleep .5
kill $!
sudo ./enforce4all.sh
sed -i "s/$COUNT/COUNT/" enforce4all.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/00:00:00:00:00:00/" enforcer.sh enforce4all.sh
echo "Press Enter to re-execute enforce4all."
echo -e "Or 1 to run enforcer \e[91mq=quit!\e[00m: " 
read OPTION
clear
case $OPTION in
1) enforcer;;
q|Q) sudo airmon-ng stop $wlan0 2>&1> /dev/null;exit 1;;
#*) echo "";;
esac
done;;
#else
1) enforcer ;;
esac