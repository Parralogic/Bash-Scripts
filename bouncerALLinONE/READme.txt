UPDATE! 11/15/2020
NEW VERIFY file, it is a copy of bouncer2.4_5GHz.sh, do not remove!
it will be used to check if the script has been tampered with;
fixAll, will reset the timer and enforcer scripts incase anything
goes wrong.... like terminals just close/accidentally while preforming a task.
Security..still a work in progress....maybe its the best its going to get
on my end... still working on it.
Oh yeah dont forget that you can add different types of mac "lists":
Example: name it whatever you want,.. MYHOME, OFFTOWORK,...whatever
and just select that appropriate mac list to be trusted, just put it in the right MAC2.4/5ghz folder!
Also one last thought.....dont forget its always best to be connected with ethernet to your router
for best results for the script and just your security in general.

UPDATE! 11/14/2020
Troubleshooting the script!,..... make sure to input the BSSID's of your router in
capital letters, not lowercase. Example aa:bb:cc:d5:f6:e7 to AA:BB:CC:D5:F6:E7.
Working on securing the script of misuse!; Example: Using iptables to lock down your network
traffic on your system, if your not using the script on your own network! or tampering with the SCRIPT!

UPDATE! 11/13/2020
bouncer2.4_5GHz will now be albe to be relaunched without 
inputting any unnecessary info about your router after the first initiation,
script should take you to the trusted mac list selection.
Script creates MYINFO and MYROUTER, to get that prompt/s back
just delete MYINFO & MYROUTER files!
also security has been improved. 
still needs work......
NOTE! 
If for some reason you close the terminals and your adaperts are
still in monitor mode, just make sure the timer.sh has TIME="time" not TIME="how ever many seconds you inputted"
right underneath ADAPTER5=$(grep "mon" enforcer5GHz.sh | cut -d "=" -f2);
and just re-execut/run bouncer2.4_5GHz again and will take you back to the 
trusted mac list selection!
*If my script/s where helpful in any shape way or form or abstract idea
:FANTASTIC! thats all that matters; and if you feel to contribute to my leisure time for the script/s
please feel free to paypal me @ https://www.paypal.com/paypalme/Parralogic

UPDATE! 11/12/2020
So far both methods working under my setup
enforcer|enforce4all
Security measures still in the works!
After timer ends and you exit it will remove all files created by bouncer2.4_5GHZ/airodump-ng
and revert back your wifi adapters to normal aswell as the enforcer*.sh scripts.
Make sure if your connected to your AP/router via WiFi add the mac address
to the trusted MAC list.

UPDATE! 11/11/2020
Some security measures have been addressed/rectified.. still in the works!
Example: If your not actually connected to your own router via wifi/ethernet script will terminate.
So far bouncher2.4_5GHz has the enforce4all function working simultaneously and re-validating clients
:On my setup.
Please run bouncer2.4_5GHz.sh first before plugging in any wifi adapters that are going to be
used for packet injection! 

UPDATE! 11/10/2020
Started writing the script...

Under Construction