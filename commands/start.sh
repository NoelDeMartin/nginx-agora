# usage: start
# summary: Start nginx-agora network and container.
# shellcheck shell=bash

base_dir=${base_dir:?}

ensure_network "nginx-agora"

if ! container_exists; then
	info "Creating container 'nginx-agora'"

	volumes=()
	for site in "$base_dir/sites_installed"/*; do
		[[ -e "$site" ]] || continue
		site_name=$(basename "$site")
		siteroot=$(sed -n "1p" "$site")

		if [[ "$siteroot" != "proxy" ]]; then
			volumes+=("--volume" "$siteroot:/var/www/$site_name:ro")
		fi
	done

	docker run -d \
		--name nginx-agora \
		--restart unless-stopped \
		--publish 80:80 \
		--publish 443:443 \
		--volume "$base_dir/sites_available:/etc/nginx/sites_available" \
		--volume "$base_dir/sites_enabled:/etc/nginx/conf.d" \
		--volume /etc/letsencrypt/live:/etc/letsencrypt/live:ro \
		--volume /etc/letsencrypt/archive:/etc/letsencrypt/archive:ro \
		"${volumes[@]}" \
		--network nginx-agora \
		nginx

elif ! is_container_running; then
	info "Starting container 'nginx-agora'"
	docker start nginx-agora
fi

for site in "$base_dir/sites_installed"/*; do
	[[ -e "$site" ]] || continue
	site_name=$(basename "$site")
	siteconfig=$(sed -n "2p" "$site")
	network="nginx-agora-$site_name"

	if [[ -n "$siteconfig" && -f "$base_dir/sites_enabled/$siteconfig" ]]; then
		ensure_network "$network"
		connect_network "$network"
	else
		disconnect_network "$network"
	fi
done
