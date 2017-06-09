#!/bin/bash

#Starts the Andon RDP configuration and RDP launch scripts
##Created by Nathan Knight
##Last Updated June 9th 2017

sudo x-terminal-emulator -t "Download Files from Repository" -e sudo bash copyrepo.bash

sudo x-terminal-emulator -t "Andon RDP Config Sctipt" -e sudo bash rdp_config.bash

