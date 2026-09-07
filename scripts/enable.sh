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

echo "Enabling $name site..."

config=$(sed -n "2p" "$base_dir/sites_installed/$name")

if [[ -z "$config" ]]; then
	echo "Site $name configuration is missing or corrupted!"
	exit 1
fi

ln -sf "../sites_available/$config" "$base_dir/sites_enabled"

network="nginx-agora-$name"
if [[ -z $(docker network ls --quiet --filter name="^${network}$") ]]; then
	echo "Creating network '$network'"
	docker network create "$network"
fi

if [[ $(docker container ls --quiet --filter name=nginx-agora) ]]; then
	if ! docker network inspect "$network" --format '{{range .Containers}}{{println .Name}}{{end}}' 2>/dev/null | grep -Fxq "nginx-agora"; then
		echo "Connecting nginx-agora to network '$network'"
		docker network connect "$network" nginx-agora 2>/dev/null || true
	fi

	echo "Site enabled, make sure to run 'nginx-agora restart' to make this change effective"
else
	echo "Site enabled"
fi
