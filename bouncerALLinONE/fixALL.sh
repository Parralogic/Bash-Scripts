#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 11/15/2020
#Last modified: 11/15/2020
clear


FIXTIMER=$(cat timer.sh | head -10 | grep -w TIME | cut -d '"' -f2)
sed -i "s/$FIXTIMER/time/" timer.sh

FIXenforcer24=$(cat enforcer2.4GHz.sh | grep "BSSID24=" | cut -d '"' -f2)
sed -i "s/$FIXenforcer24/00:00:00:00:00:00/" enforcer2.4GHz.sh
ADAPTER24=$(cat enforcer2.4GHz.sh | grep "GHZ24=" | cut -d "=" -f2)
sed -i "s/$ADAPTER24/adapter/" enforcer2.4GHz.sh

FIXenforcer5=$(cat enforcer5GHz.sh | grep "BSSID5=" | cut -d '"' -f2)
sed -i "s/$FIXenforcer5/00:00:00:00:00:00/" enforcer5GHz.sh
ADAPTER5=$(cat enforcer5GHz.sh | grep "GHZ5=" | cut -d "=" -f2)
sed -i "s/$ADAPTER5/adapter/" enforcer5GHz.sh

rm -i ACTUALSTATIONS24-01.csv ACTUALSTATIONS5-01.csv realattack realattack5ghz validate validate5ghz