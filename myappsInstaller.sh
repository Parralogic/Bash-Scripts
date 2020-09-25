#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 9/24/2020
#Last Modified Date: 9/24/2020
clear

echo -e "Installing my most used applications.\n"
sleep 2
if [[ $(command -v kodi) ]]; then
echo "*)Kodi already installed!"
else
read -p "Kodi not installed, press Enter to install"
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:team-xbmc/ppa
sudo apt-get update
sudo apt-get install kodi
fi
sleep 1
if [[ $(command -v aircrack-ng) ]]; then
echo "*)aircrack-ng already installed!"
else
read -p "aircrack-ng not installed, press Enter to install"
sudo apt-get update && sudo apt-get install aircrack-ng
fi
sleep 1
if [[ $(command -v macchanger) ]]; then
echo "*)macchanger already installed!"
else
read -p "macchanger not installed, press Enter to install"
sudo apt-get update && sudo apt-get install macchanger
fi
sleep 1
if [[ $(command -v nmap) ]]; then
echo "*)nmap already installed!"
else
read -p "nmap not installed, press Enter to install"
sudo apt-get update && sudo apt-get install nmap
fi
clear
echo -e "re-verifying if apps are installed\n"
sleep 2
for app in kodi aircrack-ng macchanger nmap
do
which $app
if [[ $? = 0 ]]; then
echo OK!
else read -p "$app not installed! Press Enter to install"
sudo apt install $app
fi
sleep 1
done
clear



