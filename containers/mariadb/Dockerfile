FROM paintedfox/mariadb

# Create redmine database with bootstrap script
ADD bootstrap.sql /tmp/bootstrap.sql
ADD bootstrap.sh /tmp/bootstrap.sh
RUN /tmp/bootstrap.sh

# vi: set tabstop=4 expandtab :
