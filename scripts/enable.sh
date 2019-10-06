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

echo "Enabling $name site..."

config=`sed -n "2p" $base_dir/sites_installed/$name`

ln -sf ../sites_available/$config $base_dir/sites_enabled

echo "Site enabled, make sure to run 'nginx-agora restart' to make this change effective"
