#!/usr/bin/env bash

base_dir=${base_dir:?}

link=0

if [[ "$1" == "--link" ]]; then
	link=1
	shift
fi

config=$(readlink -f "$1")
name="$3"

if [[ ! $config =~ .*\.conf$ ]]; then
	echo "Configuration file must end with '.conf'!"
	exit 1
fi

if [[ -z "$2" || ! -d "$2" ]]; then
	echo "Root directory '$2' does not exist!"
	exit 1
fi

root=$(cd "$2" && pwd)

if [[ -z $name ]]; then
	name=$(basename "$config")
	name="${name:0:-5}"
fi

echo "Installing site $name"

if [[ $link = 1 ]]; then
	ln -sf "$config" "$base_dir/sites_available"
else
	cp "$config" "$base_dir/sites_available"
fi

echo "$root" >"$base_dir/sites_installed/$name"
basename "$config" >>"$base_dir/sites_installed/$name"

if [[ $(docker container ls --quiet --filter name=nginx-agora) ]]; then
	echo "Stopping container 'nginx-agora'"
	docker stop nginx-agora
fi

if [[ $(docker container ls --all --quiet --filter name=nginx-agora) ]]; then
	echo "Removing container 'nginx-agora'"
	docker rm nginx-agora
fi
