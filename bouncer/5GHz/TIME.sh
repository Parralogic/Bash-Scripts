 #!/bin/bash
 
 TIME=60
 
 until [ $TIME = 0 ]; do
 echo -en "$TIME\\"
 sleep 1
 TIME=$(( TIME - 1 ))
 done
 PID=$(ps -e | grep aireplay-ng | cut -d " " -f 4)
 sudo kill $PID
 
