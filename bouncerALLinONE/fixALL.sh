#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 11/15/2020
#Last modified: 11/17/2020
clear


FIXTIMER=$(cat timer.sh | head -10 | grep -w TIME | cut -d '"' -f2)
sed -i "s/$FIXTIMER/time/" timer.sh

FIXenforcer24=$(cat enforcer2.4GHz.sh | grep "BSSID24=")
sed -i "s/$FIXenforcer24/BSSID24="00:00:00:00:00:00"/" enforcer2.4GHz.sh
ADAPTER24=$(cat enforcer2.4GHz.sh | grep "GHZ24=")
sed -i "s/$ADAPTER24/GHZ24=adapter/" enforcer2.4GHz.sh

FIXenforcer5=$(cat enforcer5GHz.sh | grep "BSSID5=")
sed -i "s/$FIXenforcer5/BSSID5="00:00:00:00:00:00"/" enforcer5GHz.sh
ADAPTER5=$(cat enforcer5GHz.sh | grep "GHZ5=")
sed -i "s/$ADAPTER5/GHZ5=adapter/" enforcer5GHz.sh

rm ACTUALSTATIONS24-01.csv ACTUALSTATIONS5-01.csv realattack realattack5ghz validate validate5ghz