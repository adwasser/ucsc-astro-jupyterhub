#!/bin/bash

# Installs jupyterhub on a MacOSX server.
# Requires npm and pip.

# install location
RUNTIME_DIR=/srv/jupyterhub
NOTEBOOK_DIR=$RUNTIME_DIR/notebooks
SHARE_DIR=$NOTEBOOK_DIR/share

mkdir $RUNTIME_DIR
mkdir $NOTEBOOK_DIR
mkdir $SHARE_DIR

# dependencies
python3 -m pip install jupyterhub
python3 -m pip install notebook
python3 -m pip install oauthenticator
npm install -g configurable-http-proxy

# create the jupyterhub cookie secret
openssl rand -base64 2048 > jupyterhub_cookie_secret

# copy files and scripts
cp *.sh $RUNTIME_DIR
cp jupyterhub* $RUNTIME_DIR
cp index.html $RUNTIME_DIR

# set permissions
# change group ownership of notebook dir to staff
chown :staff $NOTEBOOK_DIR
chown :staff $SHARE_DIR
chmod 770 $SHARE_DIR
# ACL settings, see https://gist.github.com/nelstrom/4988643
if [[ "$OSTYPE" == "darwin"* ]]; then
    chmod -R +a "group:staff allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" $SHARE_DIR
else
    # maybe setfacl will work?
    setfacl -d -m g::rwx $SHARE_DIR
fi
# remove read access from groups or others
chmod 700 $RUNTIME_DIR/*.sh
chmod 400 $RUNTIME_DIR/index.html
chmod 600 $RUNTIME_DIR/jupyterhub*

# cleanup
rm jupyterhub_cookie_secret


