#!/bin/bash

# exec 1>>/var/log/fwcld.log
# exec 2>>/var/log/fwcld.log

#-------------------------------------------------------------------------------
# Purpose:
#
#-------------------------------------------------------------------------------
# History:
# next date, salexander
#	- what changed #1
#	- what changed #2, etc
# 2020-08-13, salexander, initial draft
#-------------------------------------------------------------------------------
# References:
#
#
################################################################################
# VARIABLES
#################################################################################
# Determine OS version
# major.minor.patch reference: https://semver.org/
osvers_build=$(sw_vers -buildVersion)
osvers_all=$(sw_vers -productVersion)
osvers_major=$(sw_vers -productVersion | awk -F. '{print $1}')
osvers_minor=$(sw_vers -productVersion | awk -F. '{print $2}')
osvers_patch=$(sw_vers -productVersion | awk -F. '{print $3}')

theDate=$( date "+%Y-%m-%d %H:%M:%S %Z" )

# -----------------------------------------------------------------------------
# Add context to log messages
# -----------------------------------------------------------------------------
writelog() {
    DATE=$( date "+%Y-%m-%d %H:%M:%S %Z" )
    echo "$DATE" " $1"
}

################################################################################
# FUNCTIONS
#################################################################################

check_client_at_macOS_11 ()
{
# Determine OS version
# major.minor.patch reference: https://semver.org/
osvers_build=$(sw_vers -buildVersion)
osvers_all=$(sw_vers -productVersion)
osvers_major=$(sw_vers -productVersion | awk -F. '{print $1}')
osvers_minor=$(sw_vers -productVersion | awk -F. '{print $2}')
osvers_patch=$(sw_vers -productVersion | awk -F. '{print $3}')

writelog "[check_client_at_macOS_11] System version: $osvers_all (Build: $osvers_build)"

if [[ ( ${osvers_major} -eq 11 && ${osvers_minor} -eq 7 && ${osvers_patch} -ne 5 ) ]]; then
		writelog "[check_client_at_macOS_11] SUCCESS: this client meets scope of this fileset. Continuing."
	else
		writelog "[check_client_at_macOS_11] WARNING: this client does NOT meet scope of this fileset. Exiting."
		exit 1
fi
}

check_client_is_NOT_at_login_screen ()
{

# Checking to see if the Finder and Dock is running now before continuing. This can help
# in scenarios where an end user is not configuring the device.
  FINDER_PROCESS=$(pgrep -l "Finder")
  DOCK_PROCESS=$(pgrep -l "Dock")

writelog "[check_client_is_NOT_at_login_screen] Checking for Finder and Dock processes."
if [ "$FINDER_PROCESS" != "" ] && [ "$DOCK_PROCESS" != "" ]; then
		writelog "[check_client_is_NOT_at_login_screen] SUCCESS: this client meets scope of this fileset. Continuing."
	else
		writelog "[check_client_is_NOT_at_login_screen] WARNING: this client does NOT meet scope of this fileset. Exiting."
		exit 1
fi

}

check_display_sleep_assertions ()
{
# Detect if there is an app actively making a display sleep assertion, e.g.
# KeyNote, PowerPoint, Zoom, or Webex.
# See: https://developer.apple.com/documentation/iokit/iopmlib_h/iopmassertiontypes
    # Get the names of all apps with active display sleep assertions
    local apps="$(/usr/bin/pmset -g assertions | /usr/bin/awk '/NoDisplaySleepAssertion | PreventUserIdleDisplaySleep/ && match($0,/\(.+\)/) && ! /coreaudiod/ {gsub(/^.*\(/,"",$0); gsub(/\).*$/,"",$0); print};')"

    if [[ ! "${apps}" ]]; then
        # No display sleep assertions detected
        writelog "[check_display_sleep_assertions] SUCCESS: this client meets scope of this fileset. Continuing."
    else
    	writelog "[check_display_sleep_assertions] WARNING: this client does NOT meet scope of this fileset. Exiting."
    	# Create an array of apps that need to be ignored
    		local ignore_array=("${(@s/,/)IGNORE_DND_APPS}")

			for app in ${(f)apps}; do
				if (( ! ${ignore_array[(Ie)${app}]} )); then
					# Relevant app with display sleep assertion detected
					writelog "[check_display_sleep_assertions] Display sleep assertion detected by ${app}."
					return 0
				fi
			done
    	exit 1
    fi
    
}

# -----------------------------------------------------------------------------
# Determine if the amount of free and purgable drive space is sufficient for 
# the upgrade to take place.
# The JavaScript osascript is used to give us the purgeable space as this is 
# not available via any shell commands (Thanks to Pico). 
# However, this does not work at the login window, so then we have to fall 
# back to using df -h, which will not include purgeable space.
# -----------------------------------------------------------------------------
check_free_space() {
	min_drive_space=45

    free_disk_space=$(osascript -l 'JavaScript' -e "ObjC.import('Foundation'); var freeSpaceBytesRef=Ref(); $.NSURL.fileURLWithPath('/').getResourceValueForKeyError(freeSpaceBytesRef, 'NSURLVolumeAvailableCapacityForImportantUsageKey', null); Math.round(ObjC.unwrap(freeSpaceBytesRef[0]) / 1000000000)")

    if [[ ! "$free_disk_space" ]] || [[ "$free_disk_space" == 0 ]]; then
        # fall back to df -h if the above fails
        free_disk_space=$(df -Pk . | column -t | sed 1d | awk '{print $4}' | xargs -I{} expr {} / 1000000)
    fi

    # 
    if [[ $free_disk_space -ge $min_drive_space ]]; then
        writelog "[check_free_space] OK - $free_disk_space GB free/purgeable disk space detected"
        writelog "[check_free_space] SUCCESS: this client meets scope of this fileset. Continuing."
    else
        writelog "[check_free_space] ERROR - $free_disk_space GB free/purgeable disk space detected"
        writelog "[check_free_space] WARNING: this client does NOT meet scope of this fileset. Exiting."
		exit 1
    fi
}

################################################################################
# SCRIPT
################################################################################

echo "#----------------------------------------------------------------------------------"
echo "# Date: $theDate"
echo "# macOS version: $osvers_all"
echo "# macOS build: $osvers_build"
echo "# Requirement script before running a fileset to update/upgrade macOS on the Mac."
echo "# Fileset has to meet requirement checks in order to run the fileset."
echo "#----------------------------------------------------------------------------------"

# check to make sure client is at a specific macOS version
check_client_at_macOS_11

# check to make sure client is NOT at login screen
check_client_is_NOT_at_login_screen

# check if there is an app actively making a display sleep assertion
check_display_sleep_assertions

# check to make sure client has minimum free space
check_free_space

# exit
writelog "[exit] SUMMARY: All requirements have been successfully met."
exit 0

