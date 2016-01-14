# https://github.com/phusion/passenger-docker#adding_web_app
server {
  server_name {{PROJECT_NGINX_VIRTUAL_HOST}};
  root /home/app/redmine/public;

  # The following deploys your Ruby/Python/Node.js/Meteor app on Passenger.

  # Not familiar with Passenger, and used (G)Unicorn/Thin/Puma/pure Node before?
  # Yes, this is all you need to deploy on Passenger! All the reverse proxying,
  # socket setup, process management, etc are all taken care automatically for
  # you! Learn more at https://www.phusionpassenger.com/.
  passenger_enabled on;
  passenger_user app;

  # If this is a Ruby app, specify a Ruby version:
  #passenger_ruby /usr/bin/ruby2.1;
  # For Ruby 2.0
  #passenger_ruby /usr/bin/ruby2.0;
  # For Ruby 1.9.3 (you can ignore the "1.9.1" suffix)
  #passenger_ruby /usr/bin/ruby1.9.1;
}

{{#PROJECT_NGINX_VIRTUAL_HOST_ALTS}}
# Redirect alternative domain names.
server {
  server_name {{PROJECT_NGINX_VIRTUAL_HOST_ALTS}};
  # $scheme will get the http protocol
  # and 301 is best practice for tablet, phone, desktop and seo
  return 301 $scheme://{{PROJECT_NGINX_VIRTUAL_HOST}}$request_uri;
}
{{/PROJECT_NGINX_VIRTUAL_HOST_ALTS}}

# vim:syntax=nginx
