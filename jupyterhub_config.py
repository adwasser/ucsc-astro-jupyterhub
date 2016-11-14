# Configuration file for jupyterhub.

import sys
import os

platform = sys.platform
eviron = os.environ

runtime_dir = '/srv/jupyterhub/'
user_dir = '/Users/' if platform == 'darwin' else '/home/'

#------------------------------------------------------------------------------
# Debugging
#------------------------------------------------------------------------------

# c.JupyterHub.log_level = 'DEBUG'
# c.Spawner.debug = True
# c.LocalProcessSpawner.debug = True

#------------------------------------------------------------------------------
# JupyterHub configuration
#------------------------------------------------------------------------------

c.JupyterHub.admin_access = True
c.JupyterHub.authenticator_class = ('oauthenticator.google.'
                                    'LocalGoogleOAuthenticator')
c.JupyterHub.config_file = runtime_dir + 'jupyterhub_config.py'
c.JupyterHub.cookie_secret_file = runtime_dir + 'jupyterhub_cookie_secret'
c.JupyterHub.extra_log_file = runtime_dir + 'jupyterhub.log'
# c.JupyterHub.proxy_auth_token = ''
# c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'
c.JupyterHub.ssl_cert = runtime_dir + 'jupyterhub.cert'
c.JupyterHub.ssl_key = runtime_dir + 'jupyterhub.key'

#------------------------------------------------------------------------------
# Spawner configuration
#------------------------------------------------------------------------------

# `%U` will be expanded to the user's username
c.Spawner.default_url = '/tree/%U'
# `~` will be expanded to the user's home directory `%U` will be expanded to the
# user's username
c.Spawner.notebook_dir = user_dir + 'notebooks/'
# Disable user config files from being loaded
c.Spawner.disable_user_config = True

#------------------------------------------------------------------------------
# Authenticator configuration
#------------------------------------------------------------------------------

# c.Authenticator.admin_users = set()
# c.Authenticator.whitelist = set()

#------------------------------------------------------------------------------
# LocalAuthenticator configuration
#------------------------------------------------------------------------------

# Base class for Authenticators that work with local Linux/UNIX users
# Checks for local users, and can attempt to create them if they exist.

# The command to use for creating users as a list of strings.
# For each element in the list, the string USERNAME will be replaced with the
# user's username. The username will also be appended as the final argument.
# For Linux, the default value is:
# 
#     ['adduser', '-q', '--gecos', '""', '--disabled-password']
# 
# To specify a custom home directory, set this to:
# 
#     ['adduser', '-q', '--gecos', '""', '--home', '/customhome/USERNAME', '--
# disabled-password']
# 
# This will run the command:
# 
# adduser -q --gecos "" --home /customhome/river --disabled-password river
# 
# when the user 'river' is created.

# New user command for MacOSX.
if platform == 'darwin':
    c.LocalAuthenticator.add_user_cmd = [runtime_dir + 'make_user.sh']

c.LocalAuthenticator.create_system_users = True

#------------------------------------------------------------------------------
# GoogleOAuthenticator configuration
#------------------------------------------------------------------------------

c.LocalGoogleOAuthenticator.client_id = environ['OAUTH_CLIENT_ID']
c.LocalGoogleOAuthenticator.client_secret = environ['OAUTH_CLIENT_SECRET']
c.LocalGoogleOAuthenticator.oauth_callback_url = environ['OAUTH_CALLBACK_URL']
c.LocalGoogleOAuthenticator.hosted_domain = environ['OAUTH_HOSTED_DOMAIN']
c.LocalGoogleOAuthenticator.login_service = environ['OAUTH_LOGIN_SERVICE']
