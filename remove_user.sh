#!/bin/bash

# Remove a user in MacOSX using dscl, and remove the user from the secondary
# group with dseditgroup.
# The only (required) argument is the username.
# Saving this link for posterity, 
# http://arstechnica.com/civis/viewtopic.php?t=113164

USERNAME=$1
GROUP=$(id -Gn $USERNAME | awk '{print $1}')
# remove user from group
dseditgroup -o edit -d $USERNAME -t user $GROUP
# remove user from system
dscl . -rm /Users/$USERNAME

