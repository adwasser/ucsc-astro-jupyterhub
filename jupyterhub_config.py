# Configuration file for jupyterhub.

import sys

platform = sys.platform

runtime_dir = '/srv/jupyterhub/'
user_dir = '/Users/' if platform == 'darwin' else '/home/'
log_dir = '/var/log/'

#------------------------------------------------------------------------------
# For debugging
#------------------------------------------------------------------------------

# c.JupyterHub.log_level = 'DEBUG'
# c.Spawner.debug = True
# c.LocalProcessSpawner.debug = True

#------------------------------------------------------------------------------
# JupyterHub configuration
#------------------------------------------------------------------------------

# Grant admin users permission to access single-user servers.
# 
# Users should be properly informed if this is enabled.
c.JupyterHub.admin_access = True

# Class for authenticating users.
c.JupyterHub.authenticator_class = 'oauthenticator.google.LocalGoogleOAuthenticator'

# The config file to load
c.JupyterHub.config_file = runtime_dir + 'jupyterhub_config.py'

# File in which to store the cookie secret.
c.JupyterHub.cookie_secret_file = runtime_dir + 'jupyterhub_cookie_secret'

# Send JupyterHub's logs to this file.
# This will *only* include the logs of the Hub itself, not the logs of the proxy
# or any single-user servers.
c.JupyterHub.extra_log_file = log_dir + 'jupyterhub.log'

# The Proxy Auth token.
# Loaded from the CONFIGPROXY_AUTH_TOKEN env variable by default.
# c.JupyterHub.proxy_auth_token = ''

# Should be a subclass of Spawner.
# c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'

# Path to SSL certificate file for the public facing interface of the proxy
# 
# Use with ssl_key
c.JupyterHub.ssl_cert = runtime_dir + 'jupyterhub.cert'

# Path to SSL key file for the public facing interface of the proxy
# 
# Use with ssl_cert
c.JupyterHub.ssl_key = runtime_dir + 'jupyterhub.key'

#------------------------------------------------------------------------------
# Spawner configuration
#------------------------------------------------------------------------------

# The default URL for the single-user server.
# Can be used in conjunction with --notebook-dir=/ to enable  full filesystem
# traversal, while preserving user's homedir as landing page for notebook
# `%U` will be expanded to the user's username
c.Spawner.default_url = '/tree/%U'

# The notebook directory for the single-user server
# `~` will be expanded to the user's home directory `%U` will be expanded to the
# user's username
c.Spawner.notebook_dir = user_dir + 'notebooks/'

#------------------------------------------------------------------------------
# Authenticator configuration
#------------------------------------------------------------------------------

# Set of usernames of admin users
# If unspecified, only the user that launches the server will be admin.
# c.Authenticator.admin_users = set()

# Username whitelist.
# Use this to restrict which users can login. If empty, allow any user to
# attempt login.
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
    c.LocalAuthenticator.add_user_cmd = ['./make_user.sh']

# If a user is added that doesn't exist on the system, should I try to create
# the system user?
c.LocalAuthenticator.create_system_users = True

#------------------------------------------------------------------------------
# GoogleOAuthenticator configuration
#------------------------------------------------------------------------------

# c.LocalGoogleOAuthenticator.client_id = ''
# c.LocalGoogleOAuthenticator.client_secret = ''
# c.LocalGoogleOAuthenticator.oauth_callback_url = ''
# c.LocalGoogleOAuthenticator.hosted_domain = ''
# c.LocalGoogleOAuthenticator.login_service = ''
