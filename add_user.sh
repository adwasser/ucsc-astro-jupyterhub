#!/bin/bash

# Makes a new non-interactive user in MacOSX using dscl
# The first argument is the directory to contain the home directory, e.g., /Users
# The second argument is the username.
# The arguments are in a kludgy order to have the username be last, matching Jupyterhub's
# add_user_cmd specifications.
# Gratutiously lifted parts from SE, http://superuser.com/a/547151

getHiddenUserUid()
{
    local __UIDS=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ugr)

    #echo $__UIDS
    local __NewUID
    for __NewUID in $__UIDS
    do
	if [[ $__NewUID -lt 499 ]] ; then
	    break;
	fi
    done

    echo $((__NewUID+1))
}

if  [ $UID -ne 0 ] ; then echo "Please run $0 as root." && exit 1; fi


USERNAME=$2
HOMEDIR=$1/$USERNAME
SECONDARY_GROUPS="staff"
USERID=$(getHiddenUserUid)

dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/bash
dscl . -create /Users/$USERNAME UniqueID $USERID
# groupid 20 refers to staff
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory $HOMEDIR

# create home directory
mkdir $HOMEDIR
chown $USERNAME $HOMEDIR

# add to group
for GROUP in $SECONDARY_GROUPS ; do
    dseditgroup -o edit -t user -a $USERNAME $GROUP
done
