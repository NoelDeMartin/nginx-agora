# usage: install-proxy <config> [name]
# summary: Install a new site as a proxy. Name defaults to config filename without extension.
# shellcheck shell=bash

base_dir=${base_dir:?}
cli_name=${cli_name:?}

config_arg=${1:-}
[[ -n "$config_arg" ]] || die 2 "Missing configuration file. Usage: $cli_name install-proxy <config> [name]"

config=$(readlink -f "$config_arg")
[[ $config =~ \.conf$ ]] || die 2 "Configuration file must end with '.conf'"
[[ -f "$config" ]] || die 2 "Configuration file '$config' does not exist"

name=${2:-}
if [[ -z "$name" ]]; then
	name=$(basename "$config")
	name="${name:0:-5}"
fi

info "Installing site '$name'"

cp "$config" "$base_dir/sites_available"

echo "proxy" >"$base_dir/sites_installed/$name"
basename "$config" >>"$base_dir/sites_installed/$name"

remove_container
