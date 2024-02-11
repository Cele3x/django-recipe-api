#!/bin/sh

# Exit the script immediately if any command exits with a non-zero status.
set -e


# This command uses the `envsubst` utility to substitute environment variables in the `/etc/nginx/default.conf.tpl` file
# and redirects the output to the `/etc/nginx/conf.d/default.conf` file.
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf


# This script starts the nginx server and keeps it running in the foreground.
nginx -g 'daemon off;'
