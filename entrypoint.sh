#!/bin/bash
set -e

# Enable root user to see ruby
# sudo ln `bash -l -c "which ruby"` /usr/bin/ruby
# source ~/.rvm/scripts/rvm
# export GEM_HOME=/home/app/.rvm/gems/ruby-2.3.0
# export GEM_PATH=/home/app/.rvm/gems/ruby-2.3.0:/home/app/.rvm/gems/ruby-2.3.0@global
# sudo ln `bash -l -c "which gem"` /usr/bin/gem


# Boots the bare rack server (uses thin as the rack server)
# thin start -C /apps/rack/a_ruby_server.yml -A rack
bash -l -c "thin start -C /apps/rack/a_ruby_server.yml -A rack"

# Boots the rails app
# bash -l -c "cd /apps/rails/text_correct && sudo bundle exec thin start -C /apps/rails/text_correct.yml"
# cd /apps/rails/text_correct && sudo bundle exec thin start -C /apps/rails/text_correct.yml
bash -l -c "thin start -C /apps/rails/text_correct.yml"





# Boot up the fastcgi handler that executes arbitrary scripts on server side
sudo spawn-fcgi -s /var/run/fcgiwrap.socket /usr/sbin/fcgiwrap

# Boot the webserver which uses proxy_pass to get serverside execution of scripts
# sudo nginx -g "daemon off;"

sudo nginx -g "daemon on;"
