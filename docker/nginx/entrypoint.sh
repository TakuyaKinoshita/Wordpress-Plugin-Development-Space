#!/bin/sh
set -e

# Define the environment variables to substitute
defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))

# Substitute environment variables in the Nginx configuration template
envsubst "$defined_envs" < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx
exec "$@"