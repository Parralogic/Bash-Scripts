 
Scripts Created by myself: David Parra-Sandoval

You just need to be a root/sudo user, with proper wifi chipset adapter/s.
execute "sudo ./bouncer.sh" in terminal to get started, bouncer has a walk through.
Put the trusted mac list in the MAC directory. Example of a mac address aa:bb:11:dd:ee:12
recommended to use lowercase letters for the list of trusted mac addresses.
NOTE!!
At the end of an enforcer attack which uses the timer.sh script,
once the countdown ends the timer will ask you to remove 
the files created by diff/validate!!!
it is safe to delete all 3 files, the only file that might be 
important is the realattack file which includes the "unknown" mac addresses!

If no Unknown MAC addresses are found then your wifi/system will
revert back to its original functionality.

UPDATE 10/30/2020
enforcer will revalidate mac addresses, so if a new unknown mac joins your network
it will be detected and deauthenticated. #minor change#
Also if you see <incomplete> during validation, no worries will not effect anything,
just a buffer/glitch in arp.

