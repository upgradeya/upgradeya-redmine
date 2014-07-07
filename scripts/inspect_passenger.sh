#!/bin/bash

container_ip=$(fig ps -q passenger | xargs docker inspect -f '{{ .NetworkSettings.IPAddress }}')

# Current directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set correct permissions on insecure_key
chmod 600 $dir/insecure_key

ssh -i $dir/insecure_key root@$container_ip
