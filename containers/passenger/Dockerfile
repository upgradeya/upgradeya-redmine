# Using instructions from https://github.com/phusion/passenger-docker

# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
# OR live on the wild side and use latest
FROM phusion/passenger-ruby20

# Set correct environment variables.
ENV HOME /root

# ============ Custom build code steps here =============

# Requirements to build gems for redmine
RUN apt-get update
# nokogirl
RUN apt-get -y install libxslt1-dev libxml2-dev
# rmagick
RUN apt-get -y install imagemagick libmagickwand-dev
# mysql
RUN apt-get -y install libmysqlclient-dev

# COPY redmine project
COPY redmine /home/app/redmine
COPY database.yml /home/app/redmine/config
COPY configuration.yml /home/app/redmine/config
COPY secrets.yml /home/app/redmine/config

# COPY plugins
COPY redmine_plugins/. /home/app/redmine/plugins

# Build gems
RUN cd /home/app/redmine && bundle install --without development test

# Enable nginx
RUN rm -f /etc/service/nginx/down

# Configure nginx
COPY redmine.conf /etc/nginx/sites-enabled/redmine.conf
COPY redmine_vars.conf /etc/nginx/main.d/redmine_vars.conf
RUN rm /etc/nginx/sites-enabled/default

# Copy generated version file
COPY version.txt /home/app/redmine/public

# =======================================================

# Create redmine volumes
RUN install -dm777 /home/app/redmine/tmp && \
  install -dm777 /home/app/redmine/log && \
  install -dm777 /home/app/redmine/files \
  install -dm777 /home/app/redmine/public/plugin_assets
VOLUME /home/app/redmine/tmp
VOLUME /home/app/redmine/log
VOLUME /home/app/redmine/files
VOLUME /home/app/redmine/public/plugin_assets

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/app/redmine

# vi: set tabstop=4 expandtab :
