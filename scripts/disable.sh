#!/usr/bin/env bash

base_dir=${base_dir:?}

name="$1"

if [[ -z $name ]]; then
	pwd=$(pwd)
	name=$(basename "$pwd")
	# TODO make sure that this is actually installed and not just the name
fi

if [[ ! -f "$base_dir/sites_installed/$name" ]]; then
	echo "Site $name is not installed!"
	exit 1
fi

echo "Disabling $name site..."

config=$(sed -n "2p" "$base_dir/sites_installed/$name")

if [[ -z "$config" ]]; then
	echo "Site $name configuration is missing or corrupted!"
	exit 1
fi

if [[ ! -e "$base_dir/sites_enabled/$config" && ! -L "$base_dir/sites_enabled/$config" ]]; then
	echo "Site is already disabled!"
	exit 1
fi

rm "$base_dir/sites_enabled/$config"

network="nginx-agora-$name"
if [[ $(docker container ls --quiet --filter name=nginx-agora) ]]; then
	if docker network inspect "$network" --format '{{range .Containers}}{{println .Name}}{{end}}' 2>/dev/null | grep -Fxq "nginx-agora"; then
		echo "Disconnecting nginx-agora from network '$network'"
		docker network disconnect "$network" nginx-agora 2>/dev/null || true
	fi

	echo "Site disabled, make sure to run 'nginx-agora restart' to make this change effective"
else
	echo "Site disabled"
fi
