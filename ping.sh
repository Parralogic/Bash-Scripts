#!/bin/bash

while true; do
clear
echo -e "\e[31mNow pinging ROUTER, MODEM and WWW\e[00m"
echo
ping -c 1 192.168.0.1 2> /dev/null  | echo -e "\e[32mRouter\e[00m: $(grep ttl)"
if [[ $? = 0 ]]; then
sleep 2
echo
ping -c 1 192.168.100.1 2> /dev/null | echo -e "\e[32mModem\e[00m: $(grep ttl)"
fi
echo
ping -c 3 www.google.com 1> /dev/null
if [[ $? = 0 ]]; then
echo -e "\e[32mWWW\e[00m:\e[92mSuccessful\e[00m"
curl ifconfig.me
sleep 6
clear
break
else echo -e  "\n\e[31mUnsuccessful\e[00m"
sleep 6
fi
done
