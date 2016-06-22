FROM nginx:1.9.7

###############
# System Deps #
###############

RUN apt-get update && apt-get install -y fcgiwrap curl && apt-get clean

# for compiling asm files
RUN sudo apt-get install nasm

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
ADD sample/rails_style/text_correct/Gemfile /apps/rails/Gemfile
ADD sample/rails_style/text_correct/Gemfile.lock /apps/rails/Gemfile.lock
WORKDIR /apps/rails/text_correct
RUN sudo bundle install


############################
# Compile Assembly CGI bin #
############################



RUN sudo mkdir /assembly
ADD /sample/assembly/hello_asm.asm /assembly/hello_asm.asm
RUN sudo chown -R app /assembly
WORKDIR /assembly
RUN nasm -f elf64 hello_asm.asm
RUN ld -e _start -o hello_asm hello_asm.o
RUN sudo mv hello_asm /usr/share/nginx/html/cgi-bin/


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


############
# Conclude #
############

RUN sudo chown -R app /apps

COPY entrypoint.sh /sbin/entrypoint.sh
RUN echo ". /sbin/entrypoint.sh" > /home/app/.bash_history
WORKDIR /apps/rails/text_correct
WORKDIR /usr/share/nginx/html/cgi-bin/

ENTRYPOINT ["/sbin/entrypoint.sh"]
