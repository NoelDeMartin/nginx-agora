# usage: uninstall [name]
# summary: Uninstall a site. Name defaults to the current directory name.
# shellcheck shell=bash

base_dir=${base_dir:?}

name=${1:-$(basename "$PWD")}

[[ -f "$base_dir/sites_installed/$name" ]] || die "Site '$name' is not installed"

config=$(sed -n "2p" "$base_dir/sites_installed/$name")

if [[ -n "$config" ]]; then
	if [[ -e "$base_dir/sites_enabled/$config" || -L "$base_dir/sites_enabled/$config" ]]; then
		rm "$base_dir/sites_enabled/$config"
	fi

	rm -f "$base_dir/sites_available/$config"
fi

rm "$base_dir/sites_installed/$name"

remove_container

network="nginx-agora-$name"
remove_network "$network"

info "Site '$name' has been uninstalled"
