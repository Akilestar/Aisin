#!/bin/bash

printf 'Department List\n'
printf '[1] Assembly\n'
printf '[2] Sensor\n'
printf '[3] Mounting\n'
prtinf '[4] Inspection\n'
printf '[5] Terminal Insertion \- Depanelizers\n'
printf '[6] EWP\n'
printf '[7] Other\n' 

read -t 30 -p "Select Department" dept
case $dept
	[1]* $dept='Assembly';;
	[2]* $dept='Sensor';;
	[3]* $dept='Mounting';;
	[4]* $dept='Inspection';;
	[5]* $dept='Terminal Insertion \- Depanelizers';;
	[6]* $dept='EWP';;
	[7]* $dept='Other'
	esac

printf 'You selected '; printf $dept

printf 'Line List'





read -t 30 -p "Select Line" line
if [$dept = 'Assembly'
case $line
        [1]* $line='AS1001';;
        [2]* $line='AS1002';;
        [3]* $line='AS1003';;
        [4]* $line='AS1004';;
        [5]* $line='AS1005';;
        [6]* $line='AS1007';;
        esac


