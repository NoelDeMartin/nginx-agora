#!/usr/bin/env bash

name="$1"

if [[ ! -f "$base_dir/sites_installed/$name" ]]; then
    echo "Site $name is not installed!"
    exit
fi

config=`sed -n "2p" $base_dir/sites_installed/$name`

if [[ -f "$base_dir/sites_enabled/$config" ]]; then
    rm "$base_dir/sites_enabled/$config"
fi

rm "$base_dir/sites_installed/$name"
rm "$base_dir/sites_available/$config"

if [[ `docker container ls --quiet --filter name=nginx-agora` ]]; then
    echo "Stopping container 'nginx-agora'"
    docker stop nginx-agora
fi

if [[ `docker container ls --all --quiet --filter name=nginx-agora` ]]; then
    echo "Removing container 'nginx-agora'"
    docker rm nginx-agora
fi

echo "Site $name has been uninstalled"
