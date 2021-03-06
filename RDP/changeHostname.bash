#!/bin/bash
##Change Hostname Script
##Created by Nathan Knight
##Last Updated June 16th 2017

#########################
#       FUNCTIONS       #
#########################

#       TPUT            #
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

#notify-send
notifysend () {
timeout=$3
title="$1"
message="$2"
timeout=$(($3*1000))
sudo -u pi DISPLAY=:0.0 notify-send -t $timeout "$title" "$message"
}
#tput colors


#variables
lineName='No Line Selected'
lineTextList="textfiles/AssemblyUsernames.text"
rowNum='1'
RPIhostname=$(awk '/a/ {print $0}' /etc/hostname)

#parent_path=$( cd "$(dirname "$[BASH_SOURCE[0]}")"; pwd -P )
#cd "$parent_path


printf '%s\t%s\n' "Current User:" "$RPIhostname"

	#########################################
	#					#
	#	Department List Section		#
	#					#
	#########################################

#clear the screen
tput clear

#move cursor
tput cup 3 15

tgreen
printf '%s\n' "Change Username"

tput cup 5 15
tput rev
printf '%s\n' "Department Selection"
tput sgr0

tput cup 7 15
printf '%s\n' "[1] Assembly"

tput cup 8 15
printf '%s\n' "[2] Sensor"

tput cup 9 15
printf '%s\n' "[3] Mounting"

tput cup 10 15
printf '%s\n' "[4] Inspection"

tput cup 11 15
printf '%s\n' "[5] Terminal Insertion \ Depanelizers"

tput cup 12 15
printf '%s\n' "[6] EWP"

tput cup 13 15
printf '%s\n' "[7] Other"

#department variables
dept="No Department Selected"
deptSelect='0'

#read user input tp select department
tput bold
tput cup 14 15
while [ "$dept" == "No Department Selected" ]; do
	printf "%s\n" "Select Department [1-7]"
        if [ $deptSelect -lt 8 ]; then
		read -p "" deptSelect
		case $deptSelect in
                	[1]* ) dept='Assembly';;
                	[2]* ) dept='Sensor';;
                	[3]* ) dept='Mounting';;
                	[4]* ) dept='Inspection';;
                	[5]* ) dept='Terminal Insertion \- Depanelizers';;
                	[6]* ) dept='EWP';;
                	[7]* ) dept='Other';;
			[cancel]* ) dept='Cancel';;
        	esac
	else
		printf '%s\n' "Enter [1-7] or type cancel to start over"
		deptSelect='0'
	fi
done
if [ $dept = 'Cancel' ]; then
	#tput cup 15 15
	#read -n 1 -t 10 -p "Are you sure you want to cancel?"
	#exec "$0" "$@"
	sudo reboot
fi

#tput cleanup
tput clear
tput sgr0
tput rc

#set text list to correct file
lineTextList="textfiles/""$dept""Usernames.text"


###End Department List Section###

	#################################
	#				#
	#	Line List Section	#
	#				#
	#################################

#map text file lines to array
mapfile -t lineList < "$lineTextList"

#move cursor
tput cup 3 15

tput setaf 2
printf '%s\n' "Change Username"

tput cup 5 15
tput rev
printf '%s %s\n' "$dept" "Line List"
tput sgr0


#variables
lineSelect="1"
curPost="7"
countLines="1"
#print line selection list
while IFS= read -r line; do
        tput cup $curPost 15
	printf "[%s]\t%s\n" "$rowNum" "$line"
        rowNum=$(($rowNum+1))
	curPost=$(($curPost+1))
	countLines=$(($countLines+1))
done < "$lineTextList"

#read user input to select line
tput bold
tput cup $curPost 15
while [ "$lineName" == "No Line Selected" ]; do
	printf "%s\n" "Select Line"
	read -n 2 -p "" lineSelect
	if [ "$lineSelect" -lt "$countLines" ]; then
	 	lineSelect=$(($lineSelect-1))
        	lineName=${lineList[$lineSelect]}
	else
		tred
		printf "\nEnter [1-%s] Only \n" "$countLines"
                lineSelect='0'
		tclear
	fi
done
#tput cleanup
tput clear
tput sgr0
tput rc

#Change Hostname
HOSTNAME=$(hostname)
namePrefix='Andon'
NEW_HOSTNAME="$dept $lineName"
#notifysend "New User" "$NEW_HOSTNAME" 5
NEW_HOSTNAME="$namePrefix$lineName"

#DEBUG
#printf "\n%s %s" "DEBUGING HOSTNAME" "$NEW_HOSTNAME"
#sleep 10

hostname $NEW_HOSTNAME
echo $NEW_HOSTNAME > /etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts

tput setaf 3
printf "\n%s %s\n" "System will restart to change user to" "$(hostname)"

sleep 5

#restart machine
sudo shutdown -r now
