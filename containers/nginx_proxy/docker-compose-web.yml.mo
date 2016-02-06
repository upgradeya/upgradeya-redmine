proxy:
  image: {{PROJECT_NGINX_PROXY_IMAGE}}
  log_driver: {{PROJECT_DOCKER_LOG_DRIVER}}
  container_name: nginx_proxy
  labels:
    - "nginx_proxy"
  environment:
    - DEFAULT_HOST={{PROJECT_NGINX_DEFAULT_HOST}}
  volumes:
    - nginx_proxy_certs:/etc/nginx/certs
    - nginx_proxy_vhosts:/etc/nginx/vhost.d
    - nginx_proxy_html:/usr/share/nginx/html
    - /var/run/docker.sock:/tmp/docker.sock:ro
  ports:
    - "443:443"
    - "80:80"
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}
{{#PROJECT_LETSENCRYPT}}
letsencrypt:
  image: {{PROJECT_NGINX_PROXY_LETSENCRYPT_IMAGE}}
  log_driver: {{PROJECT_DOCKER_LOG_DRIVER}}
  container_name: nginx_proxy_letsencrypt_companion
  labels:
    - "nginx_proxy_letsencrypt_companion"
  volumes:
    - nginx_proxy_certs:/etc/nginx/certs:rw
    - /var/run/docker.sock:/var/run/docker.sock:ro
  volumes_from:
    - proxy
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}
{{/PROJECT_LETSENCRYPT}}

# vi: set tabstop=2 expandtab syntax=yaml:
