#!/bin/bash

# checks last 50,000 lines of fwcld.log for a fatal FileWave error entry specific to:
# |FATAL|CLIENT|Qt: Cannot mix incompatible Qt library (5.5.1) with this library (5.15.1)

tail -n 50000 /var/log/fwcld.log | grep -c "Log Analysis - |FATAL|CLIENT|Qt: Cannot mix incompatible Qt library"

exit 0