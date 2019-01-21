#!/usr/bin/env bash

if [[ -z `docker container ls --all --quiet --filter name=nginx-agora` ]]; then
    echo "'nginx-agora' container is not created"
elif [[ -z `docker container ls --quiet --filter name=nginx-agora` ]]; then
    echo "'nginx-agora' container is not running"
else
    echo "'nginx-agora' container is running"
fi
