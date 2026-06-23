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

BASHRC="$HOME/.bashrc"

echo "[INFO] Updating ~/.bashrc..."

# Avoid duplicate entries
grep -q "### BEGIN MODERN BASH CONFIG ###" "$BASHRC" 2>/dev/null || cat >> "$BASHRC" <<'EOF'

### BEGIN MODERN BASH CONFIG ###

# Enable bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# Enable ble.sh (autosuggestions and syntax highlighting)
if [ -f "$HOME/.blesh/out/ble.sh" ]; then
    source "$HOME/.blesh/out/ble.sh"
fi

# Enable Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

### END MODERN BASH CONFIG ###

EOF

echo "[OK] Installation complete."
echo
echo "Restart your shell or run:"
echo
echo "    source ~/.bashrc"
echo
