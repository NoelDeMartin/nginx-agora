#!/usr/bin/env bash

config="$1"
root=`cd $2 && pwd`
name="$3"

if [[ -z $name ]]; then
    name=`basename $config`
    while [[ $name =~ \. ]]; do
        name="${name%.?*}"
    done
fi

if [[ ! $config =~ .*\.conf$ ]]; then
    echo "Configuration file must end with '.conf'!"
    exit
fi

echo "Installing site $name"
cp $config $base_dir/sites_available
echo $root > $base_dir/sites_installed/$name

if [[ `docker container ls --quiet --filter name=nginx-agora` ]]; then
    echo "Stopping container 'nginx-agora'"
    docker stop nginx-agora
fi

if [[ `docker container ls --all --quiet --filter name=nginx-agora` ]]; then
    echo "Removing container 'nginx-agora'"
    docker rm nginx-agora
fi
