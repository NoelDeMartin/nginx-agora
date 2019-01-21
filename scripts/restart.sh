#!/usr/bin/env bash

if [[ `docker container ls --quiet --filter name=nginx-agora` ]]; then
    echo "Restarting container 'nginx-agora'"
    docker restart nginx-agora
else
    echo "Container 'nginx-agora' is not running"
fi
