#!/usr/bin/env bash

base_dir=${base_dir:?}

if [[ -z $(docker container ls --all --quiet --filter name=nginx-agora) ]]; then
	printf "\033[0;31m'nginx-agora' is not running\033[0m\n"
elif [[ -z $(docker container ls --quiet --filter name=nginx-agora) ]]; then
	printf "\033[0;31m'nginx-agora' is not running\033[0m\n"
else
	printf "\033[0;32m'nginx-agora' is running\033[0m\n"
fi

echo ""

for site in "$base_dir/sites_installed"/*; do
	[ -e "$site" ] || continue
	name=$(basename "$site")
	siteroot=$(sed -n "1p" "$site")
	siteconfig=$(sed -n "2p" "$site")

	if [[ -f "$base_dir/sites_enabled/$siteconfig" ]]; then
		printf "\033[0;32m[enabled]\033[0m  %s [%s]\n" "$name" "$siteroot"
	else
		printf "\033[0;31m[disabled]\033[0m %s [%s]\n" "$name" "$siteroot"
	fi
done
