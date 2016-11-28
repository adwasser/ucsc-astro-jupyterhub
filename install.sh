#!/bin/bash

# Installs jupyterhub on a MacOSX server.
# Requires npm and pip.

if  [ $UID -ne 0 ] ; then echo "Please run $0 as root." && exit 1; fi

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

# create a self-signed certificate, see http://stackoverflow.com/a/23038211
echo "Creating jupyterhub.cert and jupyterhub.key"
openssl req -x509 -newkey rsa:4096 -keyout jupyterhub.key -out jupyterhub.cert -days 365 -nodes -subj "/CN=localhost"

# create the jupyter cookie secret
echo "Creating jupyterhub_cookie_secret"
openssl rand -base64 2048 > jupyterhub_cookie_secret

# copy files and scripts
cp oauth.sh $RUNTIME_DIR
cp add_user.sh $RUNTIME_DIR
cp remove_user.sh $RUNTIME_DIR
cp launch.sh $RUNTIME_DIR
cp jupyterhub.cert $RUNTIME_DIR
cp jupyterhub.key $RUNTIME_DIR
cp jupyterhub_cookie_secret $RUNTIME_DIR
cp jupyterhub_config.py $RUNTIME_DIR

echo "Finished copying over to "$RUNTIME_DIR

# set permissions

# change group ownership of notebook dir to staff
# will fail on linux
chown :staff $NOTEBOOK_DIR
chown :staff $SHARE_DIR
chmod 770 $SHARE_DIR
# ACL settings, see
# https://gist.github.com/nelstrom/4988643
if [[ "$OSTYPE" == "darwin"* ]]; then
    chmod -R +a "group:staff allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" $SHARE_DIR
else
    # maybe setfacl will work
    setfacl -d -m g::rwx $SHARE_DIR
fi
# remove read access from groups or others
chmod 700 $RUNTIME_DIR/*.sh
chmod 600 $RUNTIME_DIR/jupyterhub*

# cleanup
rm jupyterhub.cert jupyterhub.key jupyterhub_cookie_secret


