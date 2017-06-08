#!/bin/bash
##Change Hostname Script
##Created by Nathan Knight
##Last Updated June 7th 2017

##functions
#notify-send
notifysend () {
timeout=$3
title="$1"
message="$2"
timeout=$(($3*1000))
sudo -u pi DISPLAY=:0.0 notify-send -t $timeout "$title" "$message"
}
#tput colors
source /home/pi/scripts/RDP/functions/tput.bash

#variables
export lineSelect='1'
export lineName='No Line Selected'
export namePrefix='Andon'
export dept="No Department Selected"
export lineTextList="~/scripts/RDP/text\ files/AssemblyUsernames.text"
export rowNum='1'
export RPIhostname=$(awk '/a/ {print $0}' /etc/hostname)

printf '%s\t%s\n' "Current User:" "$RPIhostname"

###Department List###

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

while [ "$dept" == "No Department Selected" ]; do
	tput bold
	tput cup 14 15
        printf "%s\n" "Select Department [1-7]"
        read -p "" deptSelect
        case $deptSelect in
                [1]* ) dept='Assembly';;
                [2]* ) dept='Sensor';;
                [3]* ) dept='Mounting';;
                [4]* ) dept='Inspection';;
                [5]* ) dept='Terminal Insertion \- Depanelizers';;
                [6]* ) dept='EWP';;
                [7]* ) dept='Other';;
        esac
done
#tput cleanup
tput clear
tput sgr0
tput rc

#set text list to correct file
lineTextList="/home/pi/scripts/RDP/text files/""$dept""Usernames.text"

#map text file lines to array
mapfile -t lineList < "$lineTextList"


###Line List###
#move cursor
tput cup 3 15

tput setaf 2
printf '%s\n' "Change Username"

tput cup 5 15
tput rev
printf '%s %s\n' "$dept" "Line List"
tput sgr0

#print line selection list
curPost='7'
while IFS= read -r line; do
        tput cup $curPost 15
	printf "[%s]\t%s\n" "$rowNum" "$line"
        rowNum=$(($rowNum+1))
	curPost=$(($curPost+1))
done < "$lineTextList"


#get user input
while [ "$lineName" == "No Line Selected" ]; do
        tput bold
        tput cup $curPost 15
	printf "%s\n" "Select Line"
        #set line based on user input
        read -p "" lineSelect
        lineSelect=$(($lineSelect-1))
        lineName=${lineList[$lineSelect]}
done
#tput cleanup
tput clear
tput sgr0
tput rc

#Change Hostname
HOSTNAME="$dept $lineName"
notifysend "New User" "$HOSTNAME" 5
HOSTNAME="$namePrefix$lineName"

tput setaf 3
printf "%s %s\n" "System will restart to change user to" "$HOSTNAME"
printf "%s\n" "Press Y to continue or N to restart without changes"

read -p "" keypress
case $keypress in
	[Yy]* ) sudo hostname $HOSTNAME;;
	[Nn]* ) sudo bash /home/pi/scripts/RDP/startAndon.bash; exit;;
esac

#restart machine
sudo shutdown -r -t 30

sleep 5
exit 0
