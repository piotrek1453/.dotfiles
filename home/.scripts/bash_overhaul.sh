#!/usr/bin/env bash

# Install modern Bash enhancements:
# - bash-completion
# - starship prompt
# - ble.sh (autosuggestions + syntax highlighting)

# CAUTION: only works on Arch

set -euo pipefail

echo "[INFO] Installing required packages..."

sudo pacman -S --needed --noconfirm \
    bash-completion \
    git \
    starship

# Install ble.sh if not already present
if [ ! -d "$HOME/.blesh" ]; then
    echo "[INFO] Installing ble.sh..."
    git clone --recursive https://github.com/akinomyoga/ble.sh.git "$HOME/.blesh"

    pushd "$HOME/.blesh" >/dev/null
    make
    popd >/dev/null
else
    echo "[INFO] ble.sh already installed."
fi

echo "[OK] Installation complete."
echo
echo "Restart your shell or run:"
echo
echo "    source ~/.bashrc"
echo
