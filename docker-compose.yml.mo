passenger:
  build: containers/passenger
  command: /sbin/my_init --enable-insecure-key
  links:
    - mariadb
  volumes:
    - ./containers/passenger/redmine:/home/app/redmine
  environment:
    - VIRTUAL_HOST={{PROJECT_NGINX_PROXY_VIRTUAL_HOSTS}}
#  volumes_from:
#    - source
mariadb:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: {{PROJECT_DB_ROOT_PASSWORD}}
    MYSQL_USER: {{PROJECT_DB_USER}}
    MYSQL_PASSWORD: {{PROJECT_DB_PASSWORD}}
    MYSQL_DATABASE: {{PROJECT_DB_DATABASE}}
    TERM: dumb
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}
# Data containers
#source:
#  build: containers/source/.
#  volumes:
#    - containers/passenger/redmine:/home/app/redmine
#  command: "true"
#  labels:
#    - "data_container=true"
        
# vi: set tabstop=2 expandtab syntax=yaml:
