#!/usr/bin/bash

set -e

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
cd "$REPO_ROOT"

# install system packages
awk '!/^\s*($|#)/ {print $1}' "$REPO_ROOT/home/.arch_packages.txt" |
	xargs paru -S --needed --noconfirm

# set Rust toolchain to nightly
rustup toolchain install nightly
rustup default nightly

# install fisher and tide theme
curl -sL https://git.io/fisher | fish -c "source; fisher install jorgebucaran/fisher; fisher install IlanCosman/tide@v6"
# tide configure # run by hand to set up the theme

# download git submodules
git -C "$REPO_ROOT" submodule update --init --recursive

# create symlinks
stow -d "$REPO_ROOT/home" -t "$HOME" --adopt .

# setup Firefox profile
FIREFOX_DIR="$HOME/.mozilla/firefox/arkenfox"

if [ -d "$FIREFOX_DIR" ]; then
	pushd "$FIREFOX_DIR" || exit
	./update-arkenfox.sh
	popd || exit
fi
