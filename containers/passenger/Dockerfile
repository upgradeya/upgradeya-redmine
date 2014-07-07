# Using instructions from https://github.com/phusion/passenger-docker

# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-ruby20:0.9.11

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

# Add redmine project
ADD redmine /home/app/redmine

# Build gems
RUN cd /home/app/redmine && bundle install --without development test

# Enable nginx
RUN rm -f /etc/service/nginx/down

# Configure nginx
ADD redmine.conf /etc/nginx/sites-enabled/redmine.conf
ADD redmine_vars.conf /etc/nginx/main.d/redmine_vars.conf
RUN rm /etc/nginx/sites-enabled/default

# =======================================================

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# vi: set tabstop=4 expandtab :
