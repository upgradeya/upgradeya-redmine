#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Starting Initilize Redmine environment script"

# http://www.redmine.org/projects/redmine/wiki/redmineinstall
echo "Creating databases"

# Get mariadb container information
mariadb_container_id=$(docker ps | grep -e 'p[ ]*figredmine_mariadb_1,' | awk '{print $1}')
mariadb_container_ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $mariadb_container_id)
mariadb_super_password=$(docker logs $mariadb_container_id | grep MARIADB_PASS | awk '{split($0,a,"="); print a[2]}')
echo "Found mariadb container $mariadb_container_id at $mariadb_container_ip with super user password $mariadb_super_password"

# Create redmine user
echo -n "Please enter the password to use for the Redmine MySQL user [ENTER]: "
read password
fig run --rm mariadb mysql -u super -p$mariadb_super_password -h $mariadb_container_ip -e 'CREATE USER '"'"'redmine'"'"'@'"'"'172.%'"'"' IDENTIFIED BY '"'"$password"'"''
fig run --rm mariadb mysql -u super -p$mariadb_super_password -h $mariadb_container_ip -e 'GRANT ALL PRIVILEGES ON redmine_production.* TO '"'"'redmine'"'"'@'"'"'172.%'"'"''

# Create database.yml if it doesn't already exist
cp -n $DIR/database.yml ./redmine/config
sed -i 's/<password>/'$password'/g' ./redmine/config/database.yml

# Create redmine databse
fig run --rm passenger bash -c 'cd /home/app/redmine; RAILS_ENV=production rake db:create && RAILS_ENV=production rake db:migrate && rake generate_secret_token && RAILS_ENV=production rake redmine:load_default_data'

#fig run --rm mariadb mysql -u super -p$mariadb_super_password -h $mariadb_container_ip -e 'show databases'
