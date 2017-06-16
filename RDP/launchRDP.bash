  GNU nano 2.2.6                                                                 File: launchRDP.bash                                                                                                                               Modified  

#!/bin/bash

#RDP Start Script
#created by Nathan Knight
#last updated June 16th 2017

RPIhostname=$(hostname)

xfreerdp -f -u $RPIhostname -p andon -v 'AEIL-AndonTS' 

#OUTPUT="$(ls -1)"

#printf "\n THIS IS THE ECHO \n%s\n" "$OUTPUT"

printf "Restarting"
sleep 5

sudo reboot

