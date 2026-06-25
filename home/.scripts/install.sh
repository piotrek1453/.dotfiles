#!/usr/bin/env bash

# Top-level setup script for this config

set -e

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
export REPO_ROOT
cd "$REPO_ROOT"

# download git submodules
git -C "$REPO_ROOT" submodule update --init --recursive

# install system packages + setup rust/rustup
source /etc/os-release
echo "Detected OS: ${NAME}"
case "$ID" in
  arch)
    # rustup install for paru build
    if ! command -v rustup > /dev/null 2>&1; then
      sudo pacman -S --noconfirm --needed rustup base-devel
      # install nightly rust toolchain and set as default
      rustup toolchain install nightly
      rustup default nightly
    fi

    # paru install
    if ! command -v paru > /dev/null 2>&1; then
      # cd into paru dir and build
      pushd "$REPO_ROOT/paru" || exit
      makepkg -si --noconfirm
      popd
    fi

    # parse packages and install with paru
    awk '!/^\s*($|#)/' "$REPO_ROOT/home/.scripts/arch_packages.txt" \
      | paru -S --needed --noconfirm -

    # execute other scripts
    pushd home/.scripts || exit
    # install haskell
    ./haskell_install.sh
    popd
    ;;

  void)
    awk '!/^\s*($|#)/' "$REPO_ROOT/home/.scripts/void_packages.txt" \
      | xargs sudo xbps-install -Sy -u
    rustup-init -y --default-toolchain nightly --profile default

    # execute other scripts
    pushd home/.scripts || exit
    # install vscode
    ./install_vscode.sh
    # install haskell
    ./haskell_install.sh
    popd
    ;;
  *)
    echo "Unsupported OS: ${NAME}"
    exit 1
    ;;
esac

# create symlinks
stow -d "$REPO_ROOT/home" -t "$HOME" --adopt .

# install fisher and tide theme
curl -sL https://git.io/fisher | fish -c "source; fisher install jorgebucaran/fisher; fisher install IlanCosman/tide@v6"
# tide configure # run by hand to set up the theme

# install flyline for bash
curl -sSfL https://raw.githubusercontent.com/HalFrgrd/flyline/master/install.sh | sh

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
