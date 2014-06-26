#!/bin/bash

container_name=$(fig ps | grep figredmine_passenger_1 | awk '{print $1}')
container_ip=$(docker ps | grep $container_name | awk '{print $1}' | xargs docker inspect -f '{{ .NetworkSettings.IPAddress }}')

# Current directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ssh -i $dir/insecure_key root@$container_ip
