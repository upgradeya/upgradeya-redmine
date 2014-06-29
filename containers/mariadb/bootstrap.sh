#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user mysql > /dev/null

/usr/sbin/mysqld --bootstrap --verbose=0 $MYSQLD_ARGS < /tmp/bootstrap.sql
