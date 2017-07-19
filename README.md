# ucsc-astro-jupyterhub
Documentation for installing a [Jupyterhub](http://jupyterhub.readthedocs.io) server on MacOSX. The server authenticates UCSC Google accounts and creates local users for whom individual Jupyter notebook servers can be started.

## File hierarchy
By default, all files will be stored in the runtime directory, `/srv/jupyterhub`.  Within this directory, the `notebooks` directory contains the home directories of all users as well as a shared directory.

## Requirements
You'll need to install `python3` and `npm`.  All other requirements are installed through their respective package managers.  

## Installation
As root, run 
```bash
./install.sh
cd /srv/jupyterhub
```
This installs the necessary python packages, creates a cookie secret file and copies over all necessary files to the runtime directory.

## HTTPS certificate
You can create a self-signed certificate with openssl, but most browsers will warn that this is insecure.
```bash
openssl req -x509 -newkey rsa:4096 -keyout jupyterhub.key -out jupyterhub.cert -days 365
```
Third party certificates can be obtained from [Let's Encrypt](https://letsencrypt.org/).

## Authentication
To authenticate through Google, follow the directions in the [Oauthenticator readme](https://github.com/jupyterhub/oauthenticator).  You'll need to create OAuth2.0 credentials, and then edit environment variables in `oauth.sh` with the client ID, client secret, and callback URL.

## Launching
From `/srv/jupyterhub`, run `./launch.sh` as root to start the Jupyterhub server.  This can be accessed at port 8000 by default.  The `http.sh` script starts up a python HTTP server to for redirects.

## Miscellanea
The `add_user.sh` and `remove_user.sh` scripts are for interfacing with Mac's directory service.  `add_user.sh` is called by Jupyterhub whenver a new user authenticates.

## TODO
Fill in documentation on automated backups with Duplicity.
