#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 5/17/2020
#Last Modified Date: 10/12/2020
clear

cd /home/david/Templates/Bash-Scripts

PS3="Script #?: "

select SCRIPT in $(find . -name "*.sh" ! -name "menu.sh")
do
if [[ $(command -v konsole) ]];then
exec konsole  -e ./$SCRIPT & 
elif [[ $(command -v xterm) ]];then
exec xterm -e ./$SCRIPT &
elif [[ $(command -v gnome-terminal) ]];then
gnome-terminal -- ./$SCRIPT &
else 
"$SCRIPT can't be executed, no compatible terminal."
fi
done
