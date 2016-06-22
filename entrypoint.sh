#!/bin/bash
set -e

# Enable root user to see ruby

# Boots the bare rack server (uses thin as the rack server)
# thin start -C /apps/rack/a_ruby_server.yml -A rack
bash -l -c "thin start -C /apps/rack/a_ruby_server.yml -A rack"

# Boots the rails app
bash -l -c "thin start -C /apps/rails/text_correct.yml"

# Boot up the fastcgi handler that executes arbitrary scripts on server side
sudo spawn-fcgi -s /var/run/fcgiwrap.socket /usr/sbin/fcgiwrap

# Boot the webserver which uses proxy_pass to get serverside execution of scripts
sudo nginx -g "daemon off;"

# sudo nginx -g "daemon on;"
