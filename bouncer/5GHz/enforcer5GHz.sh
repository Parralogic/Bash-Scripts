#!/bin/bash
#created: 10/11/2020
#extension to bouncer!
#enforcer5GHz relies on bouncer.sh
if [[ ${UID} -ne 0 ]]; then
exit 1
fi
  
exec xterm -e sudo airodump-ng -b a -c 40 $wlan0 &
PID=$!
    
loopall () {
cat untrustmac | tail -n -$actual -f | while read mac; do 
exec sudo xterm -e aireplay-ng -D --deauth 50 -a $MYBSSID -c $mac $wlan0 &
done
}

wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
lines=$(wc -l untrustmac | cut -d " " -f1)
actual=$(($lines-1))

MYBSSID="E8:65:D4:60:94:45"

loopall
kill $PID

