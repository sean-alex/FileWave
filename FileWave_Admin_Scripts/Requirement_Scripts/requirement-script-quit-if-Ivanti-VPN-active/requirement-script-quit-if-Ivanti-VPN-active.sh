#!/bin/bash

# REFERENCE: https://macadmins.slack.com/archives/CUVG2PKBJ/p1690897381270859

# send output to FileWave client log

exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

# script

if [[ $(scutil <<< "show State:/Network/Global/IPv4")  =~ "net.pulsesecure.pulse.nc.main" ]]; then
		    echo "Ivanti VPN is active, so we need to QUIT the fileset."
		    exit 1
	else 
		    echo "Ivanti VPN is NOT active, so we can CONTINUE with the fileset."
fi

exit 0
