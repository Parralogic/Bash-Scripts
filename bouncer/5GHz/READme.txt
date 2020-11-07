UPDATE! 11/06/2020
After inputing your router info, bouncer5GHz will create
a "mybssid and mychannel" files so next time you run the script
it will not ask you to obtain the info via launching an xterm session
with airodump-ng. ##just delete the files "mybssid/mychannel" to get that prompt back##
Bouncer5Ghz will detect that your wifi card is in monitor mode and
will bypass un-needed info input/..and just some minor changes! ;)
**Please open bouncer5GHz.sh in a text editor and add "#" in the beginning of the 6th line or delete the 6th line out
containing my working directory for bouncer5GHz, for the script to work properly.
cd /home/david/Templates/Bash-Scripts/bouncer/5GHz to #cd /home/david/Templates/Bash-Scripts/bouncer/5GHz

UPDATE! 11/05/2020
tested working under archbang linux 0111, thanx to MrGreen!.
bouncer5GHz will deauth all unknown 5GHz clients connected to your
network @ the "same time".
Starting the timer requires you to press enter;
At the end of the timer, it will ask you to re-execute the script,
or exit.

00/00/2020
This script "will" deauthenticate your 5GHz WiFi network.
enforcer5GHz.sh extension has been removed, it is now 
a function, less problems with sed.

still a work in progress.....


