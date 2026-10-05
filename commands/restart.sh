# usage: restart
# summary: Restart nginx-agora running container.
# shellcheck shell=bash

if is_container_running; then
	info "Restarting container 'nginx-agora'"
	docker restart nginx-agora
else
	die "Container 'nginx-agora' is not running"
fi
