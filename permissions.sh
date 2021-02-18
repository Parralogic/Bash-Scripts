#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 02/12/2021
#Last Modified: 02/17/2021
clear

    ALLFILES () {
    for FILE in $(find .  -maxdepth 1 -type f  ! -name permissions.sh | awk -F/ '{ print $2 }'); do
    if [[ ! -e backupFILESold.tar ]]; then
    tar -cf backupFILESold.tar $FILE
    wait $!
    sleep .5
    chmod 000 $FILE
    chmod -v u+$OWNER $FILE && chmod -v g+$GROUP $FILE && chmod -v o+$OTHERS $FILE
    echo "-----------------------------------------------------------------------------------"
    else
    tar -rf backupFILESold.tar $FILE
    wait $!
    sleep .5
    chmod 000 $FILE
    chmod -v u+$OWNER $FILE && chmod -v g+$GROUP $FILE && chmod -v o+$OTHERS $FILE
    echo "-----------------------------------------------------------------------------------"
    fi
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
echo "Apply to all FILES!?"
read -p "Warning! will apply to ALL files! even the ones already processed! given wildcard like so, ./permissions * : " 
case $REPLY in
y | Y) chmod -v u+$OWNER $FILE && chmod -v g+$GROUP $FILE && chmod -v o+$OTHERS $FILE
       echo "-----------------------------------------------------------------------------------"
       ALLFILES; break ;;
n | N)
       chmod -v u+$OWNER $FILE && chmod -v g+$GROUP $FILE && chmod -v o+$OTHERS $FILE
       read -p "Press Enter" ; clear ;;
esac
fi
done
fi


