passenger:
  build: containers/passenger
  command: /sbin/my_init --enable-insecure-key
  links:
    - mariadb
  volumes:
    - {{PROJECT_NAMESPACE}}_files:/home/app/redmine/files
{{#DEVELOPMENT}}
    - ./containers/passenger/redmine:/home/app/redmine
    - ./containers/passenger/redmine_plugins:/home/app/redmine/plugins
{{/DEVELOPMENT}}
  environment:
    - VIRTUAL_HOST={{PROJECT_NGINX_PROXY_VIRTUAL_HOSTS}}
    - PASSENGER_APP_ENV={{PROJECT_ENVIRONMENT}}
    - SECRET_KEY_BASE={{PROJECT_PASSENGER_SECRET_KEY_BASE}}
{{#PRODUCTION}}
    - LETSENCRYPT_HOST={{PROJECT_NGINX_PROXY_VIRTUAL_HOSTS}}
    - LETSENCRYPT_EMAIL={{PROJECT_LETSENCRYPT_EMAIL}}
{{/PRODUCTION}}
  log_driver: {{PROJECT_DOCKER_LOG_DRIVER}}
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}
mariadb:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: {{PROJECT_DB_ROOT_PASSWORD}}
    MYSQL_USER: {{PROJECT_DB_USER}}
    MYSQL_PASSWORD: {{PROJECT_DB_PASSWORD}}
    MYSQL_DATABASE: {{PROJECT_DB_DATABASE}}
    TERM: dumb
  log_driver: {{PROJECT_DOCKER_LOG_DRIVER}}
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}
# Backup
backup:
  build: containers/backup/.
  command: "/home/duply/backup_service"
  volumes:
    - {{PROJECT_NAMESPACE}}_files:{{PROJECT_BACKUP_SOURCE}}/files:ro
  links:
    - mariadb:db
  log_driver: {{PROJECT_DOCKER_LOG_DRIVER}}
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}
        
# vi: set tabstop=2 expandtab syntax=yaml:
