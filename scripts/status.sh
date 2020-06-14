#!/usr/bin/env bash

if [[ -z `docker container ls --all --quiet --filter name=nginx-agora` ]]; then
    echo "'nginx-agora' container is not created"
elif [[ -z `docker container ls --quiet --filter name=nginx-agora` ]]; then
    printf "\033[0;31m'nginx-agora' container is not running\033[0m\n"
else
    printf "\033[0;32m'nginx-agora' container is running\033[0m\n"
fi

echo ""

for name in `ls $base_dir/sites_installed`; do
    siteroot=`sed -n "1p" $base_dir/sites_installed/$name`
    siteconfig=`sed -n "2p" $base_dir/sites_installed/$name`

    if [[ -f "$base_dir/sites_enabled/$siteconfig" ]]; then
        printf "\033[0;32m[enabled]\033[0m  $name [$siteroot]\n"
    else
        printf "\033[0;31m[disabled]\033[0m $name [$siteroot]\n"
    fi
done
