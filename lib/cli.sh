# shellcheck shell=bash
# Shared CLI helpers for bash tools.
# Expects: cli_name, cli_dir set by the dispatcher.

cli_name=${cli_name:?}
cli_dir=${cli_dir:?}

# Colours (only when stderr/stdout is a TTY)
_cli_color() { [[ -t 2 ]] && tput "$@" 2>/dev/null || true; }
_cli_stdout_color() { [[ -t 1 ]] && tput "$@" 2>/dev/null || true; }

info() { printf '%s\n' "$*" >&2; }
warn() { printf '%s%s%s\n' "$(_cli_color setaf 3)" "$*" "$(_cli_color sgr0)" >&2; }
error() { printf '%s%s%s\n' "$(_cli_color setaf 1)" "$*" "$(_cli_color sgr0)" >&2; }

# Helper to format text with color on stdout when stdout is a TTY
color_text() {
	local color=$1
	shift
	if [[ -t 1 ]]; then
		printf '%s%s%s' "$(_cli_stdout_color setaf "$color")" "$*" "$(_cli_stdout_color sgr0)"
	else
		printf '%s' "$*"
	fi
}

color_red() { color_text 1 "$@"; }
color_green() { color_text 2 "$@"; }
color_yellow() { color_text 3 "$@"; }

# die [code] message...
die() {
	local code=1
	if [[ ${1:-} =~ ^[0-9]+$ ]]; then
		code=$1
		shift
	fi
	error "$@"
	exit "$code"
}

# cli_help: reads "# usage:" / "# summary:" from commands/*.sh and prints the list
cli_help() {
	local file usage summary max_len=0
	local -a usages=() summaries=()

	for file in "$cli_dir/commands"/*.sh; do
		[[ -f "$file" ]] || continue
		usage=$(sed -n 's/^# usage: *//p' "$file" | head -n 1)
		summary=$(sed -n 's/^# summary: *//p' "$file" | head -n 1)
		[[ -n "$usage" ]] || continue
		usages+=("$usage")
		summaries+=("$summary")
		if ((${#usage} > max_len)); then
			max_len=${#usage}
		fi
	done

	printf "Usage: %s <command> [options]\n\nCommands:\n" "$cli_name"
	local i
	for ((i = 0; i < ${#usages[@]}; i++)); do
		printf "  %-${max_len}s  %s\n" "${usages[i]}" "${summaries[i]}"
	done
}

# has_flag --name "$@": true if the flag is present anywhere in the arguments
has_flag() {
	local flag="$1"
	shift || return 1
	local arg
	for arg in "$@"; do
		[[ "$arg" == "$flag" ]] && return 0
	done
	return 1
}

# validate_flags [allowed...] -- "$@": dies with a usage error on any --flag not in the allowed list
validate_flags() {
	local -a allowed=()
	while (($#)) && [[ "$1" != "--" ]]; do
		allowed+=("$1")
		shift
	done
	shift || true
	local arg
	for arg in "$@"; do
		[[ "$arg" == --* ]] || continue
		has_flag "$arg" "${allowed[@]}" || die 2 "Unknown flag '$arg'"
	done
}

# strip_flags "$@": prints the positional arguments only
strip_flags() {
	local arg
	for arg in "$@"; do
		[[ "$arg" == --* ]] || printf '%s\n' "$arg"
	done
}
