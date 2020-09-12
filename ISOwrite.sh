#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 05/17/2020
#Last Modified: 09/09/2020
clear
PS3="ISO to write?# "
until [[ $CHOICE = [yY]* ]]; do
lsblk
read -p "Drive to write ISO image?:" DRIVE
echo "/dev/$DRIVE"
read -p "Is this the correct Drive?:" CHOICE
if [[ $CHOICE = [yY]* ]]; then
clear
cd $HOME/Downloads/
select ISO in $(find $HOME -name "*.iso"); do 
echo -e "\n$ISO"
sudo dd if=$ISO of=/dev/$DRIVE  bs=4M status=progress 
if [[ $? = 0 ]]; then
echo "Successful"
sleep 6
break
else echo -e "\nUnsuccessful"
sleep 6
fi
done
echo
elif [[ $CHOICE = [nN]* ]]; then
echo "Rerunning Script!"
sleep 3
clear
fi
done
