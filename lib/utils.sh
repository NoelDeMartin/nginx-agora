# shellcheck shell=bash
# Shared Docker and network helpers for nginx-agora.

# Docker container helpers

is_container_running() {
	local name="${1:-nginx-agora}"
	[[ -n $(docker container ls --quiet --filter "name=^${name}\$") ]]
}

container_exists() {
	local name="${1:-nginx-agora}"
	[[ -n $(docker container ls --all --quiet --filter "name=^${name}\$") ]]
}

stop_container() {
	local name="${1:-nginx-agora}"
	if is_container_running "$name"; then
		info "Stopping container '$name'"
		docker stop "$name"
	fi
}

remove_container() {
	local name="${1:-nginx-agora}"
	stop_container "$name"
	if container_exists "$name"; then
		info "Removing container '$name'"
		docker rm "$name"
	fi
}

# Docker network helpers

network_exists() {
	local name="$1"
	[[ -n $(docker network ls --quiet --filter "name=^${name}\$") ]]
}

ensure_network() {
	local name="$1"
	if ! network_exists "$name"; then
		info "Creating network '$name'"
		docker network create "$name"
	fi
}

is_connected_to_network() {
	local network="$1"
	local container="${2:-nginx-agora}"
	docker network inspect "$network" --format '{{range .Containers}}{{println .Name}}{{end}}' 2>/dev/null | grep -Fxq "$container"
}

connect_network() {
	local network="$1"
	local container="${2:-nginx-agora}"
	if ! is_connected_to_network "$network" "$container"; then
		info "Connecting $container to network '$network'"
		docker network connect "$network" "$container" 2>/dev/null || true
	fi
}

disconnect_network() {
	local network="$1"
	local container="${2:-nginx-agora}"
	if is_connected_to_network "$network" "$container"; then
		info "Disconnecting $container from network '$network'"
		docker network disconnect "$network" "$container" 2>/dev/null || true
	fi
}

remove_network() {
	local network="$1"
	if network_exists "$network"; then
		info "Removing network '$network'"
		if ! docker network rm "$network" 2>/dev/null; then
			warn "Warning: could not remove network '$network' (containers may still be attached)"
		fi
	fi
}
