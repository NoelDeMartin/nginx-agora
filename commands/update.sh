# usage: update <config> [name]
# summary: Update a site configuration and reload. Name defaults to config filename without extension.
# shellcheck shell=bash

base_dir=${base_dir:?}
cli_name=${cli_name:?}

config_arg=${1:-}
[[ -n "$config_arg" ]] || die 2 "Missing configuration file. Usage: $cli_name update <config> [name]"

config=$(readlink -f "$config_arg")
[[ $config =~ \.conf$ ]] || die 2 "Configuration file must end with '.conf'"
[[ -f "$config" ]] || die 2 "Configuration file '$config' does not exist"

name=${2:-}
if [[ -z "$name" ]]; then
	name=$(basename "$config")
	name="${name:0:-5}"
fi

[[ -f "$base_dir/sites_installed/$name" ]] || die "Site '$name' is not installed"

target_config=$(sed -n "2p" "$base_dir/sites_installed/$name")
[[ -n "$target_config" ]] || die "Site '$name' configuration is missing or corrupted"

if [[ -L "$base_dir/sites_available/$target_config" ]]; then
	die "Site '$name' configuration is a symlink, cannot update"
fi

info "Updating site '$name' nginx configuration..."

cp "$config" "$base_dir/sites_available/$target_config"

if is_container_running; then
	info "Reloading 'nginx-agora'..."
	docker exec nginx-agora nginx -t && docker exec nginx-agora nginx -s reload
fi
