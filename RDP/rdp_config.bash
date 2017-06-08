#!/bin/bash

#RDP Configuration Script
#created by Nathan Knight
#last updated June 7th 2017


##FUNCTIONS
source /home/pi/scripts/RDP/functions/tput.bash
source /home/pi/scripts/RDP/functions/packageCheck.bash

#countdown
countdown () {
printf "\n"
i=$1 && while [ $i -gt 0 ]; do
	i=$(($i-1))
	sleep 1
	printf "$i.."
	done
printf "\n"
}

#notify-send
notifysend () {
timeout=$2
message="$1"
timeout=$(($2*1000))
sudo -u pi DISPLAY=:0.0 notify-send -t $timeout "Andon System" "$message"
}


##VARIABLES
#hostname
RPIhostname=$(awk '/a/ {print $0}' /etc/hostname)

##START SCRIPT
tc
notifysend "Connecting to Andon Server" 60
tgreen
printf "%s\n" "ANDON TERMINAL SERVICE CONNECTION"
sleep 2
tclear
#wait for connection to MDT server
(
until ping -nq -c3 AEIL-AndonMDT; do
	tred
	printf "%s\n" "Retrying Network Connection in:";  countdown 6
	tclear
done
)
notifysend "Connected to Andon Server" 4
#check xfreerdp is missing and install if needed
packagecheck "freerdp-x11"
sleep 5
tc

#Begin Correct User Confirmation
tgreen
printf "%s\n" "ANDON TERMINAL SERVICE CONNECTION"
tput cup 3 15
tgreen
printf '%s\n' "Confirm Username"
tput cup 5 15
tput rev
printf "Current User: %s\n" "$RPIhostname"
tclear
tput cup 7 15
tbold
printf "%s\n %s\n" "Do you want to Change Users?" "Type Y or N"
read -t 30 -n 1 -p " " answer
case $answer in
        [Yy]* ) sudo bash /home/pi/scripts/RDP/changeHostname.bash;;
        [Nn]* ) printf "Login using: %s\n" "$RPIhostname";;
        esac
#connect to terminal server
notifysend "Launching RDP Client" 5
sudo bash /home/pi/scripts/RDP/launchRDP.bash
