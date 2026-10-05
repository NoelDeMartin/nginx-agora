# usage: disable [name]
# summary: Disable a site. Name defaults to the current directory name.
# shellcheck shell=bash

base_dir=${base_dir:?}
cli_name=${cli_name:?}

name=${1:-$(basename "$PWD")}

[[ -f "$base_dir/sites_installed/$name" ]] || die "Site '$name' is not installed"

info "Disabling site '$name'"

config=$(sed -n "2p" "$base_dir/sites_installed/$name")
[[ -n "$config" ]] || die "Site '$name' configuration is missing or corrupted"

if [[ ! -e "$base_dir/sites_enabled/$config" && ! -L "$base_dir/sites_enabled/$config" ]]; then
	die "Site '$name' is already disabled"
fi

rm "$base_dir/sites_enabled/$config"

network="nginx-agora-$name"
if is_container_running; then
	disconnect_network "$network"
	info "Site disabled, make sure to run '$cli_name restart' to make this change effective"
else
	info "Site disabled"
fi
