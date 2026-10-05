# usage: shell
# summary: Open shell in the running container.
# shellcheck shell=bash

if ! is_container_running; then
	die "Container 'nginx-agora' is not running"
fi

docker exec -it nginx-agora sh
