passenger:
  build: containers/passenger
  command: /sbin/my_init --enable-insecure-key
  links:
    - mariadb
  volumes:
    - {{PROJECT_NAMESPACE}}_files:/home/app/redmine/files
    - {{PROJECT_NAMESPACE}}_tmp:/home/app/redmine/tmp
    - {{PROJECT_NAMESPACE}}_log:/home/app/redmine/log
    - {{PROJECT_NAMESPACE}}_plugin_assets:/home/app/redmine/public/plugin_assets
{{#DEVELOPMENT}}
    - ./containers/passenger/redmine:/home/app/redmine
    - ./containers/passenger/redmine_plugins:/home/app/redmine/plugins
{{/DEVELOPMENT}}
  environment:
    - VIRTUAL_HOST={{PROJECT_NGINX_PROXY_VIRTUAL_HOSTS}}
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
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}
        
# vi: set tabstop=2 expandtab syntax=yaml:
