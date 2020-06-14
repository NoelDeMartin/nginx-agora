#!/usr/bin/env bash

config=`readlink -f $1`
name="$2"

if [[ ! $config =~ .*\.conf$ ]]; then
    echo "Configuration file must end with '.conf'!"
    exit
fi

if [[ -z $name ]]; then
    name=`basename $config`
    name="${name:0:-5}"
fi

echo "Installing site $name"

cp $config $base_dir/sites_available

echo "proxy" > $base_dir/sites_installed/$name
echo `basename $config` >> $base_dir/sites_installed/$name

if [[ `docker container ls --quiet --filter name=nginx-agora` ]]; then
    echo "Stopping container 'nginx-agora'"
    docker stop nginx-agora
fi

if [[ `docker container ls --all --quiet --filter name=nginx-agora` ]]; then
    echo "Removing container 'nginx-agora'"
    docker rm nginx-agora
fi
