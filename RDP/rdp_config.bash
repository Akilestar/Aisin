#!/bin/bash

#########################################
#					#
#	RDP Configuration Script	#
#	created by Nathan Knight	#
#	last updated June 9th 2017	#
#					#
#########################################

#########################
#	FUNCTIONS	#
#########################

#	TPUT		#
#########################
#text colors
tblack () {
tput setaf 0
}
tred () {
tput setaf 1
}
tgreen () {
tput setaf 2
}
tyellow () {
tput setaf 3
}
tblue () {
tput setaf 4
}
tmagenta () {
tput setaf  5
}
tcyan () {
tput setaf 6
}
twhite () {
tput setaf 7
}
tbold () {
tput bold
}
#set text back to default
tclear () {
tput sgr0
}
#clear terminal window of all text
tc () {
tput clear
}

#	COUNTDOWN	#
#########################
countdown () {
printf "\n"
i=$1 && while [ $i -gt 0 ]; do
	i=$(($i-1))
	sleep 1
	printf "$i.."
	done
printf "\n"
}

#	NOTIFY-SEND	#
#########################
notifysend () {
timeout=$2
message="$1"
timeout=$(($2*1000))
sudo -u pi DISPLAY=:0.0 notify-send -t $timeout "Andon System" "$message"
}

#########################
#	VARIABLES	#
#########################

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
bash packageCheck.bash "freerdp-x11"
notifysend "RDP Client installed" 5
sleep 1
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
        [Yy]* ) sudo bash changeHostname.bash;;
        [Nn]* ) printf "Login using: %s\n" "$RPIhostname";;
        esac
#connect to terminal server
notifysend "Launching RDP Client" 5
sudo bash launchRDP.bash
