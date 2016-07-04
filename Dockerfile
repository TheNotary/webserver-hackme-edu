FROM nginx:1.9.7

###############
# System Deps #
###############

# IMPORTANT NOTE:  some of this stuff didn't install clean on another machine.
# May need to add an apt-get install -y apt-utils and --fix-missing to
# apt-get install commands

# For fastcgi
RUN apt-get update && apt-get install -y fcgiwrap curl && apt-get clean

# For Compiling ruby and other langs
RUN apt-get update && \
  apt-get install -y wget git nodejs ruby-dev curl patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev sudo vim && \
  apt-get clean

# for compiling asm files
RUN apt-get update && apt-get install -y nasm

# For apache bench
RUN apt-get update && apt-get install -y apache2-utils

RUN echo deb http://http.debian.net/debian jessie-backports main >> /etc/apt/sources.list

# JAVA:  Install Java.
RUN apt-get update && apt-get install -y openjdk-8-jdk
RUN update-alternatives --config java


# JAVA:  Define commonly used JAVA_HOME variable
# ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


RUN apt-get clean
  

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
RUN sudo gem install thin
RUN sudo gem install bundle
RUN sudo gem install sqlite3

RUN echo "[user]\n  email = no@email.plz\n  name = TheNotary\n[push]\n  default = matching" > /home/app/.gitconfig


##################
# Setup the apps #
##################

RUN sudo mkdir /assembly
RUN sudo chown -R app /assembly
RUN sudo mkdir -p /usr/share/nginx/html/cgi-bin
RUN sudo mkdir /apps
RUN sudo mkdir /apps/rack
RUN sudo mkdir /apps/rails
RUN sudo chown -R app /apps

# Rails app dependencies
ADD sample/rails_style/text_correct/Gemfile /apps/rails/text_correct/Gemfile
ADD sample/rails_style/text_correct/Gemfile.lock /apps/rails/text_correct/Gemfile.lock
WORKDIR /apps/rails/text_correct
RUN sudo bundle install


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
RUN sudo bundle install
RUN sudo bundle exec rake assets:precompile
RUN /bin/bash -l -c "thin config -C /apps/rails/text_correct.yml -c /apps/rails/text_correct --servers 3 -e production -p 3003"


############################
# Compile Assembly CGI bin #
############################

COPY /sample/assembly /assembly
RUN sudo chown -R app /assembly

# Make all the assembly projects
WORKDIR /assembly
RUN for D in *; do [ -d "${D}" ] && cd ${D} && make && sudo mv ${D} /usr/share/nginx/html/cgi-bin/ && cd ..; done


###########
# Install #
###########

# Nginx configs
COPY resources/conf /etc/nginx
COPY sample/web /usr/share/nginx/html

ADD sample/hackme/production.db /usr/share/nginx/html/cgi-bin/production.db
ADD sample/hackme/migrate_database /usr/share/nginx/html/cgi-bin/migrate_database
ADD sample/hackme/intelligence /usr/share/nginx/html/cgi-bin/intelligence
ADD sample/hackme/hackme.html /usr/share/nginx/html/hackme.html
RUN sudo chmod -R 0777 /usr/share/nginx/html/cgi-bin

#############
# perf_test #
#############

RUN sudo mkdir /perf_test
COPY perf_test /perf_test
RUN sudo chown -R app /perf_test


############
# Conclude #
############

RUN sudo chown -R app /apps

COPY entrypoint.sh /sbin/entrypoint.sh
RUN echo ". /sbin/entrypoint.sh" > /home/app/.bash_history
WORKDIR /apps/rails/text_correct
WORKDIR /usr/share/nginx/html/cgi-bin/
WORKDIR /perf_test

ENTRYPOINT ["/sbin/entrypoint.sh"]
