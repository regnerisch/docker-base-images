#!/bin/bash

# The main entrypoint to the container
# Load global aliases
source ~/.bashrc

# Set default environment variables
export APACHE_WEBROOT=${APACHE_WEBROOT:-"/var/www/html"}
export APACHE_LOG_DIR=${APACHE_LOG_DIR:-"/var/www/logs"}
export PROJECT_ENV=${PROJECT_ENV:-"prod"}

# Create additional directories if required
if [ -f "/opt/bootstrap-dir.sh" ]; then
  source /opt/bootstrap-dir.sh
fi

# Allows child containers to extend the bootstrap
# This is used for the development container!
if [ -f "/opt/bootstrap-extension.sh" ]; then
  source /opt/bootstrap-extension.sh
fi

# Run project specific bootstrap if required
if [ -f "/opt/bootstrap-project.sh" ]; then
  source /opt/bootstrap-project.sh
fi

apache2-foreground