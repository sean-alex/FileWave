#!/bin/bash

# requirement script to check if user account exists
# if user account exists, then do not run fileset

variable_user_account="user_account"

result=$(dscl . -list /Users | grep "$variable_user_account")

if [ "$result" = "" ]; then
		echo "$variable_user_account does not exist"
		# run fileset
		# exit 0
	else
 		echo "$variable_user_account already exists"
 		# do not run fileset
 		# exit 1
fi
