#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
export REPO_ROOT
cd "$REPO_ROOT"

# install system packages + setup rust/rustup
source /etc/os-release
echo "Detected OS: ${NAME}"
case "$ID" in
arch)
  awk '!/^\s*($|#)/' "$REPO_ROOT/home/.scripts/arch_packages.txt" |
    paru -S --needed --noconfirm -
  rustup toolchain install nightly
  rustup default nightly
  pushd home/.scripts || exit
  ./haskell_install.sh
  popd
  ;;
void)
  awk '!/^\s*($|#)/' "$REPO_ROOT/home/.scripts/void_packages.txt" |
    xargs sudo xbps-install -Sy -u
  rustup-init -y --default-toolchain nightly --profile default
  # install vscode
  pushd home/.scripts || exit
  ./install_vscode.sh
  ./haskell_install.sh
  popd
  ;;
*)
  echo "Unsupported OS: ${NAME}"
  exit 1
  ;;
esac

# download git submodules
git -C "$REPO_ROOT" submodule update --init --recursive

# create symlinks
stow -d "$REPO_ROOT/home" -t "$HOME" --adopt .

# install fisher and tide theme
curl -sL https://git.io/fisher | fish -c "source; fisher install jorgebucaran/fisher; fisher install IlanCosman/tide@v6"
# tide configure # run by hand to set up the theme

# pnpm setup
pushd "$REPO_ROOT/home/.scripts" || exit
./pnpm_install.sh
popd

# setup Firefox profile
FIREFOX_DIR="$HOME/.mozilla/firefox/arkenfox"
if [ -d "$FIREFOX_DIR" ]; then
  pushd "$FIREFOX_DIR" || exit
  ./update-arkenfox.sh
  popd || exit
fi
