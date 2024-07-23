#!/bin/sh

OPWD="$PWD"
BASE="$(dirname "$(realpath "$0")")"
if [ "$OPWD" != "$BASE" ]; then
	echo "... $BASE is not the same as $PWD ..."
	echo "Going into $BASE and coming back here in a bit"
	cd "$BASE" || exit 1
fi
trap 'cd "$OPWD"' EXIT

# Function to log to stdout with green color
log() {
	_Xashstd_reset="\033[m"
	_Xashstd_color_code="\033[32m"
	printf "${_Xashstd_color_code}->${_Xashstd_reset} %s\n" "$*"
}

# Function to log_warning to stdout with yellow color
log_warning() {
	_Xashstd_reset="\033[m"
	_Xashstd_color_code="\033[33m"
	printf "${_Xashstd_color_code}->${_Xashstd_reset} %s\n" "$*"
}

# Function to log_error to stdout with red color
log_error() {
	_Xashstd_reset="\033[m"
	_Xashstd_color_code="\033[31m"
	printf "${_Xashstd_color_code}->${_Xashstd_reset} %s\n" "$*"
	exit 1
}

unnappear() {
	"$@" >/dev/null 2>&1
}

# Check if a dependency is available.
available() {
	unnappear which "$1" || return 1
}

# Exit if a dependency is not available
require() {
	available "$1" || log_error "[$1] is not installed. Please ensure the command is available [$1] and try again."
}

CC="${CC:=cc}"

case "$1" in
"" | "build")
	require "$CC"
	log "Using CC to build \"$(basename "$BASE")\""
	"$CC" -std=c99 ./m_ascii85.c -o ./m_ascii85 || log_error "\"$CC\" command failed"
	;;
"clean")
	shift
	log "Starting clean process"
	unnappear rm ./m_ascii85
	echo "rm ./m_ascii85"
	log "Clean process completed"
	;;
"retrieve")
	readlink -f ./m_ascii85
	;;
*)
	echo "Usage: $0 {build|clean}"
	exit 1
	;;
esac
