#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 10/10/2020
#Last Modified: 10/12/2020
clear

if [[ ${UID} -ne 0 ]]; then
echo run as root/sudo
exit 1
fi
for app in nmap arp xterm aircrack-ng macchanger; do
command -v $app 2>&1> /dev/null
if [[ $? = 0 ]]; then
echo -e "Great! $app installed"
else echo -e "$app not installed :("
echo "Script will not work without $app!!"
echo "Or will not work correctly!!"
fi
done
modify () {
sed -i "s|FILE|$TRUSTED|" enforcer.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$MYBSSID/" enforcer.sh enforce4all.sh
sed -i "s/time/$STOPTIME/" timer.sh #enforce4all.sh
}
#####################################################################################################################
WiFi24GHz () {
#until [[ $CHOICE = [yY]* ]]; do      ????????????????????????????????????????????????
read -p "Input the Subnet:? " SUBNET
read -p "Router/AP 2.4GHz MAC:? " MAC
read -p "Is this correct Sub:$SUBNET Mac:$MAC ?(y/n) " CHOICE
#done                                 ????????????????????????????????????????????????WTF
nmap $SUBNET-254 -F -r 2>&1> /dev/null
sleep 6
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<" > untrust
cat untrust | cut -d " " -f2 > untrustmac
read -p "Run bouncer every ?min/?Hour?(m/h) "
if [[ $REPLY = h ]]; then
read -p "Type how many hours:? " HOUR
let "hour= 60 * 60"
let "TIME= $hour * $HOUR"
else
read -p "Type how many min:? " MIN
let "min= 60 * 1" ##
let "TIME= $min * $MIN"
fi
exec xterm -iconic -e sudo airodump-ng -c $CH $wlan0 &
sleep .5
kill $!
read -p "How long do you really wanna keep the attack/enforcer going for:?(m/h) "
if [[ $REPLY = h ]]; then
read -p "How many hours:? " STOPh
STOPTIME=$((60 * $STOPh * 60))
else
read -p "Type how many min:? " STOPm
STOPTIME=$(( 60 * $STOPm ))
fi
modify
exec sudo xterm -geometry 60x2 -e ./timer.sh &
sleep .5
sed -i "s/$STOPTIME/time/" timer.sh enforce4all.sh
while true; do
for mac in $(diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"); do
if [[ $mac = HWaddress ]]; then
echo "";clear
elif [[ $mac = "<" ]]; then
echo "";clear
else
echo $mac
echo "Because the above MAC is not trusted enforcer will" 
echo "disconnect all untrust MAC's! One by One" 
echo "enforcer will run every $TIME sec"
echo "For $STOPTIME sec"
echo "You do the math" #remember ;)
sleep 1
sudo xterm  -e ./enforcer.sh &
PID=$!
sleep $TIME
kill $PID
fi
done
done
}
#####################################################################################################################
WiFi5GHz () {
    WTF () {
    read -p "Input the Subnet:? " SUBNET
    read -p "Router/AP 5GHz MAC:? " MAC
    read -p "Is this correct Sub:$SUBNET Mac:$MAC ?(y/n) " CHOICE
    }
#until [[ $CHOICE = [yY]* ]]; do       #??????????????????????????????????????????????????
#while [[ $CHOICE = [nN]* ]]; do       #??????????????????????????????????????????????????
read -p "Input the Subnet:Ex.192.168.0.1-254 or 192.168.0.1/24? " SUBNET
read -p "Router/AP 5GHz MAC:? " MAC
read -p "Is this correct Sub:$SUBNET Mac:$MAC ?(y/n) " CHOICE
#done                                  #??????????????????????????????????????????????????WTF
case $CHOICE in
y|Y) echo "";;
n|N) WTF;;
*) wtf;;
esac
echo "Please wait...will take a min...!"
nmap $SUBNET -F -r 2>&1> /dev/null
sleep 6
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<" > untrust
cat untrust | cut -d " " -f2 > untrustmac
echo -e "Note the above MAC's are untrusted! they will be attacked!!"
read -p "Run bouncer every ?min/?Hour?(m/h) "
if [[ $REPLY = h ]]; then
read -p "How many hours:? " HOUR
let "hour= 60 * 60"
let "TIME= $hour * $HOUR"
else
read -p "How many min:? " MIN
let "min= 60 * 1" ##
let "TIME= $min * $MIN"
fi
exec xterm -iconic -e sudo airodump-ng -c $CH $wlan0 &
sleep .5
kill $!
read -p "How long do you really wanna keep the attack/enforcer going for:?(m/h) "
if [[ $REPLY = h ]]; then
read -p "How many hours:? " STOPh
STOPTIME=$((60 * $STOPh * 60))
else
read -p "How many min:? " STOPm
STOPTIME=$(( 60 * $STOPm ))
fi
modify
exec sudo xterm -geometry 60x2 -e ./timer.sh &
sleep .5
sed -i "s/$STOPTIME/time/" timer.sh
while true; do
for mac in $(diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"); do
if [[ $mac = HWaddress ]]; then
echo "";clear
elif [[ $mac = "<" ]]; then
echo "";clear
else
echo $mac
echo "Because the above MAC is not trusted enforcer will" 
echo "disconnect all untrust MAC's!;enforcer will run every $TIME sec"
echo "For $STOPTIME sec"
echo "You do the math" #remember ;)
sleep 1
sudo xterm  -e ./enforcer.sh &
PID=$!
sleep $TIME
kill $PID
fi
done
done
}
#####################################################################################################################
DEFAULT () {
echo -e "Please wait..will take a min..!"
nmap $SUBNET-254 -F -r 2>&1> /dev/null
sleep 6
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"
diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<" > untrust
cat untrust | cut -d " " -f2 > untrustmac
echo -e "Note the above MAC's are untrusted! they will be attacked!!"
echo -e "Run enforcer or enforce4all:?"
echo -e "enforcer= Uses a time script!"
echo -e "enforce4all= No time script! just a one time"
echo -e "mass-deauthentication on all" 
echo -e "unknown clients/macs at the same time!"
read -p "1=enforcer 2=enforce4all (1 or 2) "
if [[ $REPLY = 2 ]]; then
while true; do
read -p "Deauth Count:? " COUNT
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$MYBSSID/" enforcer.sh enforce4all.sh
sed -i "s/COUNT/$COUNT/" enforce4all.sh
exec xterm -iconic -e sudo airodump-ng -c $CH $wlan0 &
sleep .5
kill $!
sudo ./enforce4all.sh
sed -i "s/$COUNT/COUNT/" enforce4all.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/00:00:00:00:00:00/" enforcer.sh enforce4all.sh
echo -e "Press Enter to re-execute enforce4all."
read -p "OR number 1 for enforcer :"
clear
case $REPLY in
1) clear;kill $!;break;clear;;
*) echo "";;
esac
done
else
read -p "Run enforcer every ?min/?Hour?(m/h) "
if [[ $REPLY = h ]]; then
read -p "How many hours:? " HOUR
let "hour= 60 * 60"
let "TIME= $hour * $HOUR"
else
read -p "How many min:? " MIN
let "min= 60 * 1" ##
let "TIME= $min * $MIN"
fi
exec xterm -iconic -e sudo airodump-ng -c $CH $wlan0 &
sleep .5
kill $!
read -p "How long do you really wanna keep the attack/enforcer going for:?(m/h) "
if [[ $REPLY = h ]]; then
read -p "How many hours:? " STOPh
STOPTIME=$((60 * $STOPh * 60))
else
read -p "How many min:? " STOPm
STOPTIME=$(( 60 * $STOPm ))
fi
modify
exec sudo xterm -geometry 60x2 -e ./timer.sh &
sleep .5
fi
#sed -i "s/$STOPTIME/time/" timer.sh
while true; do
for mac in $(diff <(arp -n | awk '{print $3}') $TRUSTED | grep "<"); do
if [[ $mac = HWaddress ]]; then
sed -i "s/$STOPTIME/time/" timer.sh enforce4all.sh;clear
elif [[ $mac = "<" ]]; then
echo "";clear
elif [[ $mac = enp* ]];then
echo "";clear
else
echo $mac
echo "Because the above MAC is not trusted enforcer will" 
echo "disconnect all untrust MAC's!, enforcer will run every $TIME sec"
echo "For $STOPTIME sec"
echo "You do the math" #remember ;)
sudo xterm -e ./enforcer.sh &
PID=$!
sleep $TIME
kill $PID
fi
done
done
}
#######################################################################################################################
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
echo "$TRUSTED will be used to filter out unknown MAC's"
else
echo "$TRUSTED does not exist!"
macfile
fi
echo
echo -e "First Xterm will open to gather info"
echo -e "about your Router/AP"
echo -e "#Select WiFi interface to deploy enforcer/4all:#"
echo -e "enp=Ethernet wl=WiFi lo=loopback address"
select NETWORK in $(ls /sys/class/net);do
ADAPTER=$NETWORK
read -p "Use $ADAPTER:?(y/n) " CHOICE
case $CHOICE in
y|Y) break ;;
n|N) echo -e "Re-Select" ;;
*) echo "Only (y/n) re-select interface." ;;
esac
done
clear
sudo airmon-ng start $ADAPTER 2>&1> /dev/null
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down 2>&1> /dev/null
sleep 1
sudo macchanger -A $wlan0  2>&1> /dev/null
sleep 1
sudo ip link set $wlan0 up 2>&1> /dev/null
sleep 1
exec xterm -hold -e sudo airodump-ng $wlan0 &
PID=$!
read -p "What's your Router/AP WiFi Channel:? " CH
read -p "What's your Router/AP BSSID MAC Address:? " MYBSSID
sleep 1
kill $PID
SUBNET=$(ip a | grep dynamic | cut -d " " -f8)
if [[ $SUBNET = 192.168.1.255 ]];then
SUBNET=192.168.1.1
else
SUBNET=192.168.0.1
fi
GATEWAY_MAC=$(arp -a | grep "$SUBNET" | grep gateway | cut -d " " -f4)
echo
echo -e "Your Subnet:$SUBNET-254"
echo -e "Your Router/AP MAC:$GATEWAY_MAC\n"
echo -e "Would you like to use this configuration????"
echo -e "Note your Router/AP MAC will differ from AP/BSSID" 
echo -e "In order for this script to work,"
echo -e "this script needs the WiFi chip MAC of your router."
echo -e "2.4GHz MAC or 5GHz MAC\n"
echo -e "Press Enter for default configuration!"
echo -e "Subnet:$SUBNET"
echo -e "Router/AP:$GATEWAY_MAC" 
echo -e "AP/BSSID:$MYBSSID\n"
echo -e "1) Define 2.4GHz MAC  2) Define 5GHz MAC" 
echo -e "        !under-construction!             "
read -p "#? "
case $REPLY in
1) WiFi24GHz;;
2) WiFi5GHz;;
""|" ") DEFAULT;;
*) echo " "
esac





