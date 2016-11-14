#!/bin/bash

# Installs jupyterhub on a MacOSX server.
# Requires npm and pip.

RUNTIME_DIR=/srv/jupyterhub

python3 -m pip install jupyterhub
python3 -m pip install notebook
python3 -m pip install oauthenticator
npm install -g configurable-http-proxy

# create a self-signed certificate, see http://stackoverflow.com/a/23038211
echo "Creating jupyterhub.cert and jupyterhub.key, defaults are fine."
openssl req -x509 -newkey rsa:4096 -keyout jupyterhub.key -out jupyterhub.cert -days 365 -nodes

# create the jupyter cookie secret
echo "Creating jupyterhub_cookie_secret"
openssl rand -base64 2048 > jupyterhub_cookie_secret

# install
mkdir $RUNTIME_DIR

cp oauth.sh $RUNTIME_DIR
cp make_user.sh $RUNTIME_DIR
cp launch.sh $RUNTIME_DIR
cp jupyterhub.cert $RUNTIME_DIR
cp jupyterhub.key $RUNTIME_DIR
cp jupyterhub_cookie_secret $RUNTIME_DIR
cp jupyterhub_config.py $RUNTIME_DIR

echo "Finished copying over to "$RUNTIME_DIR

# restrict cookie sharing
chmod 600 $RUNTIME_DIR/jupyterhub_cookie_secret

# cleanup
rm jupyterhub.cert jupyterhub.key jupyterhub_cookie_secret


