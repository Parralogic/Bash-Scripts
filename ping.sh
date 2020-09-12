#!/bin/bash

while true; do
clear
echo -e "\e[31mNow pinging ROUTER, MODEM and WWW\e[00m"
echo
ping -c 1 192.168.0.1 2> /dev/null  | echo "Router: $(grep ttl)"; sleep 1
if [[ $? = 0 ]]; then
echo
ping -c 1 192.168.100.1 2> /dev/null | echo -e "Modem: $(grep ttl)"; sleep 1
fi
echo
ping -c 3 parralogic.ddns.net 1> /dev/null
if [[ $? = 0 ]]; then
echo -e "WWW:\e[92mSuccessful\e[00m"
curl ifconfig.me
sleep 6
clear
break
else echo -e  "\n\e[31mUnsuccessful\e[00m"
sleep 6
fi
done
