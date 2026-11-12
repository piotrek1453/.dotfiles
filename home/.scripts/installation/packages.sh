#!/usr/bin/env bash

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/common.sh"

require_command paru
PACKAGE_FILE="$REPO_ROOT/home/.scripts/installation/system_packages.txt"

mapfile -t packages < <(awk '
  /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
  { sub(/[[:space:]]+#.*/, ""); gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length) print }
' "$PACKAGE_FILE")

if ((${#packages[@]} == 0)); then
	skip 'No Arch packages are listed.'
	exit 0
fi

paru -S --needed --noconfirm "${packages[@]}"
info 'Arch packages are installed.'
