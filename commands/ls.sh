# usage: ls
# summary: Alias for status.
# shellcheck shell=bash

cli_dir=${cli_dir:?}

# shellcheck source=commands/status.sh
source "$cli_dir/commands/status.sh"
