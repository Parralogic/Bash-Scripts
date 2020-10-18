#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 10/18/2020
#Last Modified: 10/18/2020
clear

for trust in $(cat validate); do
echo Validating $trust
for untrust in $(cat macs); do
if [[ $untrust = $trust ]]; then
[[ $untrust != $trust ]]
#else
echo $trust >> attack
fi
done 
done
diff macsv attack | grep "<" >> realattack
