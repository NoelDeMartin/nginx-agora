#!/usr/bin/env bash

if [ -n `docker container ls --quiet --filter name=nginx-agora` ]; then
    echo "Stopping container 'nginx-agora'"
    docker stop nginx-agora
fi
