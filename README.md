# UpgradeYa's Redmine decompose environment

This project is designed to allow a developer to quickly get a Redmine environment setup for both local development and production on a single server.

The project uses [docker-compose](http://docs.docker.com/compose/) to orchestrate docker containers so that Redmine works as with a MariaDB database backend.

## Prerequisites

- [Docker](http://docs.docker.com/installation/#installation)
- [Docker Compose](http://docs.docker.com/compose/)
- [decompose](https://github.com/dmp1ce/decompose)

## Quick Start

Use `git clone --recursive` to download the project because of the Redmine submodule.

Create the file `.decompose/elements` and add the following data.

```
# Include constant elements
#source $(_decompose-project-root)/elements

PROJECT_ENVIRONMENT="development"
PROJECT_NGINX_VIRTUAL_HOST="localhost"
PROJECT_NGINX_VIRTUAL_HOST_ALTS=""

# Database settings
PROJECT_DB_DATABASE="redmine_db"
PROJECT_DB_USER="redmine_user"
PROJECT_DB_PASSWORD="mypassword_db"
PROJECT_DB_ROOT_PASSWORD="rootpassword_db"

# vim:syntax=sh
```

The first time this project is started you should use the `decompose initialize_redmine` process.  For all subsequent runs you should use, `decompose build && decompose up`.

Visit `http://localhost` to view Redmine.

## Running and stoping containers

After running `decompose initialize_redmine` your Redmine instance should be running.  If you want to stop the containers then run `docker-compose stop`.  If you want to start it up again, use `decompose up`.

## Configuration

First, configure your settings in the `.decompose/elements` file. See the [Redmine decompose envirnment](https://github.com/dmp1ce/decompose-redmine).
For the initial Redmine configuration, the `decompose initialize_redmine` script should be used.

At this point http://$PROJECT_NGINX_VIRTUAL_HOST should show a running Redmine instance, where $PROJECT_NGINX_VIRTUAL_HOST is defined in the `.decompose/elements` file.
