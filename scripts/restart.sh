#!/usr/bin/env bash

if [ -n `docker container ls --quiet --filter name=nginx-agora` ]; then
    echo "Restarting container 'nginx-agora'"
    docker restart nginx-agora
fi
