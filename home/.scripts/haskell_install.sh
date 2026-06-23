#!/usr/bin/env bash
set -e

# Check if GHC is already installed
if command -v ghc >/dev/null 2>&1; then
  echo "[INFO] Haskell is already installed."
  exit 0
fi

echo "[INFO] Haskell not found. Installing GHCup..."

export BOOTSTRAP_HASKELL_NONINTERACTIVE=1

curl --proto '=https' --tlsv1.2 -sSf \
  https://get-ghcup.haskell.org | sh

# Load ghcup for THIS script session only
if [ -f "$HOME/.ghcup/env" ]; then
  . "$HOME/.ghcup/env"
fi

echo "[INFO] Installing GHC..."
ghcup install ghc recommended

echo "[INFO] Installing Cabal..."
ghcup install cabal latest

ghcup set ghc recommended
ghcup set cabal latest

echo "[INFO] Done."
echo "[WARNING] You must reload shell:"
echo "  source ~/.ghcup/env"
