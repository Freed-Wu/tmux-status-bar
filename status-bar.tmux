#!/usr/bin/env bash
# shellcheck disable=SC2155
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PWD=$CURRENT_DIR . "$CURRENT_DIR/.envrc"

has_cmd() {
	local opt
	for opt; do
		if command -v "$opt" >/dev/null; then
			continue
		else
			return $?
		fi
	done
}

if ! has_cmd tmux-powerline-compiler; then
	if ! has_cmd nix-shell; then
		nix-shell --run xmake
	else
		xmake
	fi
fi

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

do_interpolation() {
	local all_interpolated="$1"
	echo $PATH >/dev/shm/a.txt
	echo "$all_interpolated" | tmux-powerline-compiler
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
	update_tmux_option "window-status-current-format"
}
main
