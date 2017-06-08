#!/bin/bash

#RDP Start Script
#created by Nathan Knight
#last updated June 5th 2017

RPIhostname=$(awk '/a/ {print $0}' /etc/hostname)

xfreerdp -f -u $RPIhostname -p andon -v 'AEIL-AndonTS'
