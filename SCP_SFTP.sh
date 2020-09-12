#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 1/27/2020
#Last Modified Date: 2/5/2020
clear

down_file () {
read -p "User of remote host:" name
read -p "IP Address of remote host:" ipn
read -p "TCP port:" port
read -p "Absolute path of the FILE to download:" path
read -p "Absolute path to save the FILE on local host:" save
scp -P $port $name@$ipn:$path $save
if [[ $? = 0 ]]; then
echo -e "\e[92mSuccessful\e[0m"
sleep 2
clear
else echo -e "\e[91mUnsuccessful\e[0m"
sleep 3
fi
clear
}

down_folder () {
read -p "User of remote host:" name
read -p "IP Address of remote host:" ipn
read -p "TCP port:" port
read -p "Absolute path of the FOLDER to download:" path
read -p "Absolute path to save the FOLDER on local host:" save
scp -P $port -r $name@$ipn:$path $save
if [[ $? = 0 ]]; then
echo -e "\e[92mSuccessful\e[0m"
sleep 2
clear
else echo -e "\e[91mUnsuccessful\e[0m"
sleep 3
fi
clear
}

copy_file () {
ls
echo
read -p "User of remote host:" name
read -p "IP Address of remote host:" ipn
read -p "TCP port:" port
read -p "Absolute path of the FILE to upload:" path
read -p "Absolute path to save the FILE on remote host:" save
scp -P $port $path $name@$ipn:$save
if [[ $? = 0 ]]; then
echo -e "\e[92mSuccessful\e[0m"
sleep 2
clear
else echo -e "\e[91mUnsuccessful\e[0m"
sleep 3
fi
clear
}

copy_folder () {
ls
echo
read -p "User of remote host:" name
read -p "IP Address of remote host:" ipn
read -p "TCP port:" port
read -p "Absolute path of the FOLDER to upload:" path
read -p "Absolute path to save the FOLDER on remote host:" save
scp -P $port -r $path $name@$ipn:$save
if [[ $? = 0 ]]; then
echo -e "\e[92mSuccessful\e[0m"
sleep 2
clear
else echo -e "\e[91mUnsuccessful\e[0m"
sleep 3
fi
clear
}

conn_sftp () {
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

until [[ $choice = [yY]* ]]; do
echo -e "\e[91mWhat is the working directory/path to work under?\e[0m:"
read under
clear; ls $under
echo
echo -e "\e[92mIs this the correct path/directory\e[0m: $under"
read choice
if [[ $choice = [yY]* ]]; then
echo -e "\e[92mOK\e[0m"; sleep 2
clear
cd $under
elif [[ $choice = [nN]* ]]; then
unset under
echo -e "\e[91mTry again\e[0m:"
fi
done
count=5
while true 
do
echo -e "\t \t \t\e[96mMENU\e[0m \n"
echo -e "\t \e[32m1) Download a file with SCP\e[0m"
echo -e "\t \e[33m2) Download a folder with SCP\e[0m"
echo -e "\t \e[32m3) Copy a file to remote host with SCP\e[0m"
echo -e "\t \e[33m4) Copy a folder to remote host with SCP\e[0m"
echo -e "\t \e[32m5) Connect with SFTP\e[0m"
echo -e "\t \e[91m6) EXIT\e[0m"
echo
read input
clear
case $input in
1) down_file ;;
2) down_folder ;;
3) copy_file ;;
4) copy_folder ;;
5) conn_sftp ;;
6) until [[ $count = 0 ]]; do
echo -e -n "\r\e[91mEXITING...\e[0m\e[96m$count\e[0m"
count=$(($count-1))
sleep 1
done
clear; break ;;
*) echo -e "\e[91mWrong Option Only 1-6\e[0m"
sleep 3; clear ;;
esac
done
