#!/bin/bash

# checks last 50,000 lines of fwcld.log, grep for current day, then check for a FileWave error entry specific to:

currentDate=$(date "+%Y-%m-%d")

tail -n 50000 /var/log/fwcld.log | grep "$currentDate" | grep -c "FATAL|CLIENT|Could not send list of profiles to be installed via MDM"

exit 0