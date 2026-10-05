# usage: enable [name]
# summary: Enable a site. Name defaults to the current directory name.
# shellcheck shell=bash

base_dir=${base_dir:?}
cli_name=${cli_name:?}

name=${1:-$(basename "$PWD")}

[[ -f "$base_dir/sites_installed/$name" ]] || die "Site '$name' is not installed"

info "Enabling site '$name'"

config=$(sed -n "2p" "$base_dir/sites_installed/$name")
[[ -n "$config" ]] || die "Site '$name' configuration is missing or corrupted"

ln -sf "../sites_available/$config" "$base_dir/sites_enabled"

network="nginx-agora-$name"
ensure_network "$network"

if is_container_running; then
	connect_network "$network"
	info "Site enabled, make sure to run '$cli_name restart' to make this change effective"
else
	info "Site enabled"
fi
