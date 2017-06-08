#!/bin/bash

#Package Check Function Script
##Created by Nathan Knight
##Last Updated June 7th 2017

packagecheck () {
package=$1
if [ $(dpkg-query -W -f='${Status}' $package | grep -c "ok installed") -eq 0 ]
then
        sudo apt-get --force-yes --yes install $package
else
        printf "Package %s Installed" "$package"

}
fi
