# usage: install [--link] <config> <root> [name]
# summary: Install a new site. Name defaults to config filename without extension.
# shellcheck shell=bash

base_dir=${base_dir:?}
cli_name=${cli_name:?}

validate_flags --link -- "$@"

link=0
if has_flag --link "$@"; then
	link=1
fi

readarray -t args < <(strip_flags "$@")

config_arg=${args[0]:-}
[[ -n "$config_arg" ]] || die 2 "Missing configuration file. Usage: $cli_name install [--link] <config> <root> [name]"

config=$(readlink -f "$config_arg")
[[ $config =~ \.conf$ ]] || die 2 "Configuration file must end with '.conf'"
[[ -f "$config" ]] || die 2 "Configuration file '$config' does not exist"

root_arg=${args[1]:-}
[[ -n "$root_arg" ]] || die 2 "Missing root directory. Usage: $cli_name install [--link] <config> <root> [name]"
[[ -d "$root_arg" ]] || die 2 "Root directory '$root_arg' does not exist"

root=$(cd "$root_arg" && pwd)

name=${args[2]:-}
if [[ -z "$name" ]]; then
	name=$(basename "$config")
	name="${name:0:-5}"
fi

info "Installing site '$name'"

if [[ $link -eq 1 ]]; then
	ln -sf "$config" "$base_dir/sites_available"
else
	cp "$config" "$base_dir/sites_available"
fi

echo "$root" >"$base_dir/sites_installed/$name"
basename "$config" >>"$base_dir/sites_installed/$name"

remove_container
