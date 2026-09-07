#!/usr/bin/env bash

base_dir=${base_dir:?}

config=$(readlink -f "$1")
name="$2"

if [[ ! $config =~ .*\.conf$ ]]; then
	echo "Configuration file must end with '.conf'!"
	exit 1
fi

if [[ ! -f "$config" ]]; then
	echo "Configuration file '$config' does not exist!"
	exit 1
fi

if [[ -z $name ]]; then
	name=$(basename "$config")
	name="${name:0:-5}"
fi

if [[ ! -f "$base_dir/sites_installed/$name" ]]; then
	echo "Site $name is not installed!"
	exit 1
fi

target_config=$(sed -n "2p" "$base_dir/sites_installed/$name")

if [[ -z "$target_config" ]]; then
	echo "Site $name configuration is missing or corrupted!"
	exit 1
fi

if [[ -L "$base_dir/sites_available/$target_config" ]]; then
	echo "Site $name configuration is a symlink, cannot update!"
	exit 1
fi

echo "Updating site $name nginx configuration..."

cp "$config" "$base_dir/sites_available/$target_config"

if [[ $(docker container ls --quiet --filter name=nginx-agora) ]]; then
	echo "Reloading 'nginx-agora'..."
	docker exec nginx-agora nginx -t && docker exec nginx-agora nginx -s reload
fi
