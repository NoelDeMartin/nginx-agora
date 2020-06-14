#!/usr/bin/env bash

name="$1"

if [[ -z $name ]]; then
    pwd=`pwd`
    name=`basename $pwd`
    # TODO make sure that this is actually installed and not just the name
fi

if [[ ! -f "$base_dir/sites_installed/$name" ]]; then
    echo "Site $name is not installed!"
    exit
fi

echo "Disabling $name site..."

config=`sed -n "2p" $base_dir/sites_installed/$name`

if [[ ! -f "$base_dir/sites_enabled/$config" ]]; then
    echo "Site is already disabled!"
    exit;
fi

rm $base_dir/sites_enabled/$config

if [[ `docker container ls --quiet --filter name=nginx-agora` ]]; then
    echo "Site disabled, make sure to run 'nginx-agora restart' to make this change effective"
else
    echo "Site disabled"
fi
