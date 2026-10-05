# usage: status
# summary: Display nginx-agora container status.
# shellcheck shell=bash

base_dir=${base_dir:?}

if is_container_running; then
	printf "%s\n" "$(color_green "'nginx-agora' is running")"
else
	printf "%s\n" "$(color_red "'nginx-agora' is not running")"
fi

echo ""

for site in "$base_dir/sites_installed"/*; do
	[[ -e "$site" ]] || continue
	site_name=$(basename "$site")
	siteroot=$(sed -n "1p" "$site")
	siteconfig=$(sed -n "2p" "$site")

	if [[ -n "$siteconfig" && -f "$base_dir/sites_enabled/$siteconfig" ]]; then
		printf "%s  %s [%s]\n" "$(color_green "[enabled]")" "$site_name" "$siteroot"
	else
		printf "%s %s [%s]\n" "$(color_red "[disabled]")" "$site_name" "$siteroot"
	fi
done
