#!/usr/bin/env bash

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/common.sh"

require_command flatpak

PACKAGE_FILE="$REPO_ROOT/home/.scripts/installation/flatpak_packages.txt"
mapfile -t packages < <(awk '
  /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
  { sub(/[[:space:]]+#.*/, ""); gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length) print }
' "$PACKAGE_FILE")

flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

if ((${#packages[@]} == 0)); then
	skip 'No Flatpak applications are listed.'
	exit 0
fi

flatpak --user install --noninteractive flathub "${packages[@]}"
info 'Flatpak applications are installed for the current user.'
