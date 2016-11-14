#!/bin/bash

# Makes a new non-interactive user in MacOSX using dscl
# The single argument should be the username.
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

getInteractiveUserUid()
{
    # Find out the next available user ID
    local __MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
    echo $((__MAXID+1))
}

if  [ $UID -ne 0 ] ; then echo "Please run $0 as root." && exit 1; fi

USERNAME=$1
SECONDARY_GROUPS="staff"
USERID=$(getHiddenUserUid)
# USERID=$#(getInteractiveUserUid)

dscl . -create /Users/"$USERNAME"
dscl . -create /Users/"$USERNAME" UserShell /bin/bash
dscl . -create /Users/"$USERNAME" UniqueID "$USERID"
# groupid 20 refers to staff
dscl . -create /Users/"$USERNAME" PrimaryGroupID 20
dscl . -create /Users/"$USERNAME" NFSHomeDirectory /Users/"$USERNAME"

# create home directory
createhomedir -c 2>&1 | grep -v "shell-init"

# add to staff group
for GROUP in $SECONDARY_GROUPS ; do
    dseditgroup -o edit -t user -a $USERNAME $GROUP
done

# make the notebook directory
mkdir /Users/notebooks/"$USERNAME"
chown "$USERNAME" /Users/notebooks/"$USERNAME"
