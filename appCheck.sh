#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 3/21/2020
#Last Modified Date: 8/18/2020
clear

for app in $@; do
command -v $app > /dev/null
if [[ $? = 0 ]]; then
echo -e  "\e[92m$app installed\e[00m"
else echo -e "\e[91m$app not installed\e[00m"
read -p "Would you like to install $app? (Yes/No):" choice
if [[ $choice = [yY]* ]]; then
sudo apt-get install $app
elif [[ $choice = [nN]* ]]; then
echo "$app will not be installed!"
else echo "Only Yes/No"
fi
fi
done
