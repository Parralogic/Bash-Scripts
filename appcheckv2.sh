#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 08/17/2020
#Last Modified: 08/17/2020
clear

if [[ -z $@ ]]; then
echo "No application to check.."
echo Usage: $0 appname appname appname etc..
exit 1
fi
echo -e "Checking package manager..\n"
sleep 1
if [[ -f $(command -v pacman) ]]; then
echo "Package manager is pacman"
for app in $@; do
command -v $app > /dev/null 2>&1
if [[ $? = 0 ]]; then
echo $app Installed
else echo "$app Not Installed......Installing < $app"
sudo pacman -S $app
fi
done
elif [[ -f $(command -v apt-get) ]]; then
echo "Package manager is apt-get"
for app in $@; do
command -v $app > /dev/null 2>&1
if [[ $? = 0 ]]; then
echo $app Installed
else echo "$app Not Installed......Installing < $app"
sudo apt-get install $app
fi
done
elif [[ -f $(command -v rpm) ]]; then
echo "Package manager is rpm"
for app in $@; do
command -v $app > /dev/null 2>&1
if [[ $? = 0 ]]; then
echo $app Installed
else echo "$app Not Installed......Installing < $app"
sudo rpm install $app
fi
done
elif [[ -f $(command -v dnf) ]]; then
echo "Package manager is dnf"
for app in $@; do
command -v $app > /dev/null 2>&1
if [[ $? = 0 ]]; then
echo $app Installed
else echo "$app Not Installed......Installing < $app"
sudo dnf install $app
fi
done
fi
