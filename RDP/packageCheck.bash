#!/bin/bash

#Package Check Function Script
##Created by Nathan Knight
##Last Updated June 9th 2017

package="$1"
installFlag='2'

if [ $(dpkg-query -W -f='${Status}' $package | grep -c "ok installed") -eq 0 ]
then
        printf "Package %s Missing, Would you like to install it now?" "$package"
	while [ $installFlag -gt 1 ]; do
		read -t 5 -n 1 -p "[y]Yes or [n]No" yn
		case $yn in
			[Yy]* ) installFlag='1';;
			[Nn]* ) printf "Package will not be installed"; installFlag='0';;
		esac
	done
else
        installFlag='0'; printf "Package %s Installed" "$package"
fi

if [ installFlag == '1' ]; then
	sudo apt-get --force-yes --yes install $package
fi
sleep 5
