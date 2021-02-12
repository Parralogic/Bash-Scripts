#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 02/12/2021
#Last Modified: 02/12/2021
clear

    ALLFILES () {
    for FILE in $(find . -type f ! -name "permissions.sh"); do
    chmod 000 $FILE
    chmod -v u+$OWNER $FILE && chmod -v g+$GROUP $FILE && chmod -v o+$OTHERS $FILE
    done
    }
if [[ -z $@ ]]; then
echo "Usage $0 FILE1 FILE2 FILE3...etc"
echo "Place/copy script in the directory of the files to be modified."
else

for FILE in $@; do
if [[ ! -e $FILE ]];
then
echo -e "[\e[91m$FILE\e[00m] does not Exist!, check spelling."

else
chmod 000 $FILE
echo -e -n "USER|OWNER of the file [\e[91m$FILE\e[00m] will be able to [r]ead [w]rite e[x]ecute:? "; read OWNER
read -p "GROUP [r]ead [w]rite e[x]ecute:? " GROUP
read -p "OTHERS [r]ead [w]rite e[x]ecute:? " OTHERS
read -p "Apply to all FILES!? (y/n) " 
case $REPLY in
y | Y) ALLFILES; break ;;
n | N)
chmod -v u+$OWNER $FILE && chmod -v g+$GROUP $FILE && chmod -v o+$OTHERS $FILE
read -p "Press Enter" ; clear ;;
esac
fi
done
fi


