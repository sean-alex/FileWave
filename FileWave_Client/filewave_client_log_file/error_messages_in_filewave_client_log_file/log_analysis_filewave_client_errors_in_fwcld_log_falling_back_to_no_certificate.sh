#!/bin/bash

# checks last 50,000 lines of fwcld.log, grep for current day, then check for a FileWave error entry specific to:

currentDate=$(date "+%Y-%m-%d")

tail -n 50000 /var/log/fwcld.log | grep "$currentDate" | grep -c "|main|INFO|CLIENT|Falling back to no certificate"

exit 0