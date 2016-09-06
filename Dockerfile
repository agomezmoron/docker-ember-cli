FROM ubuntu:14.04
MAINTAINER Alejandro Gomez <amoron@emergya.com>

#================================
# Build arguments
#================================

#================================
# Env variables
#================================

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION 6.5.0
ENV WEBSITE_ROOT_DIR /var/www/html
ENV WATCHMAN_VERSION v4.6.0

#================================
# Instance build
#================================

# Adding the resources
ADD assets/etc/apt/apt.conf.d/99norecommends /etc/apt/apt.conf.d/99norecommends
ADD assets/etc/apt/sources.list /etc/apt/sources.list

# Updating the packages
RUN apt-get update -y \
  # Installing common stack
  && apt-get install -y -q wget apache2 git build-essential \
  # apache2 configuration
  && service apache2 restart \
  && a2enmod rewrite \
  && service apache2 reload \
  && service apache2 stop \
  # Installing nodejs from binaries
  && cd /tmp  \
  && wget "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" -O node-linux-x64.tar.gz --no-check-certificate \
  && tar -zxvf "node-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm node-linux-x64.tar.gz \
  # binding node globally
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  # Installing ember-cli stack
  && npm install ember-cli -g \
  && npm install bower -g \
  # Installing watchman
  && apt-get install -y -q automake autoconf python-dev \
  && git config --global http.sslVerify false \
  && git clone https://github.com/facebook/watchman.git \
	&& cd watchman \
	&& git checkout $WATCHMAN_VERSION \
	&& ./autogen.sh \
	&& ./configure \
	&& make \
	&& make install \
  && echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p \
  && apt-get -qqy clean && rm -rf /var/cache/apt/*

WORKDIR /src

# Apache port
EXPOSE 80
# Ember port
EXPOSE 4200

# Adding the entrypoint
COPY ./assets/bin/entrypoint /
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]