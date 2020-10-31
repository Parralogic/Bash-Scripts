 #!/bin/bash
 
 TIME=time
 
 while true; do
 echo -en "$TIME/"
 sleep 1
 TIME=$(( TIME - 1 ))
 if [[ $TIME = 0 ]]; then
 break
 fi
 done
 PID=$(ps -e | grep aireplay-ng | cut -d " " -f 3)
 sudo kill $PID
 
