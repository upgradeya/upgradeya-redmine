# Redmine fig/docker environment README


This project is designed to allow a developer to quickly get a Redmine environment setup for both local development and production on a single server.

The project uses the [fig](http://orchardup.github.io/fig/) to orchestrate docker containers so that Redmine works as with a MariaDB database backend.

## Prerequisites


- [Docker](http://docs.docker.com/installation/#installation)
- [Fig](http://orchardup.github.io/fig/install.html)

## Quick Start

Use `git clone --recursive` to download the project because of the Redmine submodule.

The first time this project is started you should use the `initialize_redmine.sh` script.  For all subsequent runs you should just use fig, `fig up -d`.

## Running and stoping containers

After running `initialize_redmine.sh` your Redmine instance should be running.  If you want to top the containers then run `fig stop`.  If you want to start it up again, use `fig up -d`.

## Configuration

For the initial Redmine configuration, the `initialize_redmine.sh` script should be used.  For documentation purposes the initial configuration is described in the Manual Configuration section.

### Automatic Configuration

`./script/initialize_redmine.sh`

At this point http://localhost should show a running Redmine instance.

If you receive any errors then you can remove the mariadb container with `fig stop mariadb && fig rm mariadb && fig up -d` and try the manual configuration process.

### Manual Configuration

After the containers are built, Redmine needs to be configured. First start containers to get the database password and username from the logs.  Use `fig up` to start the containers and then `docker ps` to get a list of all the running containers.  The container that says "paintedfox/mariadb:lastest" as the IMAGE name is the database container.  Show the log for the database by running `docker logs <CONTAINER_ID>` where "<CONTAINER_ID>" is your container id will look something like "16bebb57262a".  The result should look somthing like this.

```
$ docker logs 16bebb57262a
*** Running /etc/rc.local...
*** Booting runit daemon...
*** Runit started as PID 7
*** Running /scripts/start.sh...
MARIADB_USER=super
MARIADB_PASS=rOUX0gi2gyOVo09p
MARIADB_DATA_DIR=/data
Initializing MariaDB at /data
Starting MariaDB...
140628 17:47:14 mysqld_safe Logging to syslog.
140628 17:47:14 mysqld_safe Starting mysqld daemon with databases from /data
```

Copy the "MARIADB_PASS" for later use in creating your own MySQL users. Use the following example as a guide to create your own databases.

TODO: Add instructions for getting the IP address for the MariaDB container.

- `fig run --rm mariadb bash`
- `mysql -u super -p -h <IP_ADDRESS>`
- Enter the "MARIADB_PASS" to enter the MySQL command line interface
- `CREATE USER 'redmine'@'172.%' IDENTIFIED BY 'my_password';`
- `GRANT ALL PRIVILEGES ON redmine_production.* TO 'redmine'@'172.%';`
- `quit`
- `exit`

You now need to create the database.yml.  You can copy the database.yml.example or use my example below.
The host and port for the database need to be obtained from environment variables because they can change on every container restart.  Here is an example.

```ruby
production: &default
  adapter: mysql2
  database: redmine_production
  host: <%= ENV.fetch('MARIADB_1_PORT_3306_TCP_ADDR', 'localhost') %> 
  port: <%= ENV.fetch('MARIADB_1_PORT_3306_TCP_PORT', '3306') %>
  username: redmine
  password: "my_password"
  encoding: utf8

development:
  <<: *default
  database: redmine_development

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: redmine_test
```

NOTE: Change "my_password' to a password of your choice.  development and test environments are not yet functional using these instructions.

To access the passenger, use the inspect_passenger.sh script and then run the following rake commands.  See [Redmine installation instructions](http://www.redmine.org/projects/redmine/wiki/redmineinstall) for details.

- `./scripts/inspect_passenger.sh`
- `cd /home/app/redmine/`
- `RAILS_ENV=production rake db:create`
- `RAILS_ENV=production rake db:migrate`
- `rake generate_secret_token`
- `RAILS_ENV=production rake redmine:load_default_data`
- `exit`

At this point you should be able to view a Redmine installation located at "http://localhost".
