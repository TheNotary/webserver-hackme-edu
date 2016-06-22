FROM nginx:1.9.7

###############
# System Deps #
###############

RUN apt-get update && apt-get install -y fcgiwrap curl && apt-get clean

RUN apt-get update && \
  apt-get install -y wget git nodejs ruby-dev curl patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev sudo vim && \
  apt-get clean


######################
# Make non-root user #
######################

RUN useradd -ms /bin/bash app
RUN echo 'app     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers


##############
# SETUP RUBY #
##############

USER app
RUN mkdir /home/app/source
WORKDIR /home/app/source
RUN wget https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz
RUN tar -zxvf ruby-2.3.1.tar.gz
WORKDIR /home/app/source/ruby-2.3.1
RUN ./configure --prefix=/usr
RUN make
RUN sudo make install
RUN sudo chown -R app /usr/lib/ruby

# Install base gems
RUN /bin/bash -l -c "sudo gem install thin"
RUN /bin/bash -l -c "sudo gem install bundle"

RUN echo "[user]\n  email = no@email.plz\n  name = TheNotary\n[push]\n  default = matching" > /home/app/.gitconfig

COPY resources/conf /etc/nginx

# these get a worked ruby demo available on port 80
COPY sample/web /usr/share/nginx/html


# Install the opinionator gem deps
ADD sample/rails_style/period_opinionator/Rakefile /period_opinionator/Rakefile
ADD sample/rails_style/period_opinionator/Gemfile /period_opinionator/Gemfile
ADD sample/rails_style/period_opinionator/lib/period_opinionator/version.rb /period_opinionator/lib/period_opinionator/version.rb
ADD sample/rails_style/period_opinionator/period_opinionator.gemspec /period_opinionator/period_opinionator.gemspec
WORKDIR /period_opinionator
RUN sudo bundle install

RUN sudo chown -R app /period_opinionator
WORKDIR /period_opinionator

RUN git init && \
  git add . && \
  git commit -m "commit for rake"

RUN sudo rake install

# TODO: remove me since I copy pasted this below some other installs...
COPY sample/rails_style/period_opinionator /period_opinionator

RUN git init && \
  git add . && \
  git commit -m "commit for rake"

RUN sudo rake install
RUN sudo chown -R app /period_opinionator

##################
# Setup the apps #
##################

RUN sudo mkdir /apps
RUN sudo mkdir /apps/rack
RUN sudo mkdir /apps/rails
RUN sudo chown -R app /apps

# Rails app dependencies
ADD sample/rails_style/text_correct/Gemfile /apps/rails/Gemfile
ADD sample/rails_style/text_correct/Gemfile.lock /apps/rails/Gemfile.lock
WORKDIR /apps/rails/text_correct
RUN /bin/bash -l -c "cd /apps/rails/text_correct && sudo bundle install"

# Installs period_opinionator
WORKDIR /period_opinionator
COPY sample/rails_style/period_opinionator /period_opinionator
RUN sudo chown -R app /period_opinionator
RUN sudo rake install


######################
# Setup the rack app #
######################

ADD sample/rackup_style/config.ru /apps/rack/config.ru
WORKDIR /apps/rack
RUN /bin/bash -l -c "thin config -C /apps/rack/a_ruby_server.yml -c /apps/rack --servers 3 -e production -p 3000"


#######################
# Setup the rails app #
#######################

COPY sample/rails_style/ /apps/rails/
RUN sudo chown -R app /apps

WORKDIR /apps/rails/text_correct
RUN /bin/bash -l -c "cd /apps/rails/text_correct && sudo bundle install"
RUN /bin/bash -l -c "cd /apps/rails/text_correct && sudo bundle exec rake assets:precompile"
RUN /bin/bash -l -c "thin config -C /apps/rails/text_correct.yml -c /apps/rails/text_correct --servers 3 -e production -p 3003"


###########
# Install #
###########

ADD sample/hackme/production.db /usr/share/nginx/html/cgi-bin/production.db
ADD sample/hackme/migrate_database /usr/share/nginx/html/cgi-bin/migrate_database
ADD sample/hackme/intelligence /usr/share/nginx/html/cgi-bin/intelligence
ADD sample/hackme/hackme.html /usr/share/nginx/html/hackme.html


RUN sudo gem install sqlite3


############
# Conclude #
############

RUN sudo chown -R app /apps

COPY entrypoint.sh /sbin/entrypoint.sh
RUN echo ". /sbin/entrypoint.sh" > /home/app/.bash_history
WORKDIR /apps/rails/text_correct
WORKDIR /usr/share/nginx/html/cgi-bin/

ENTRYPOINT ["/sbin/entrypoint.sh"]
