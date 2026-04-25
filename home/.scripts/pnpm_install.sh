#!/usr/bin/env fish

# IMPORTANT! never to be called standalone, only to be called by install.sh
# otherwise REPO_ROOT is not available and script will fail

# setup pnpm if not already configured and install global packages
if not grep -q "PNPM_HOME" ~/.config/fish/config.fish 2>/dev/null
	pnpm setup
	source ~/.config/fish/config.fish
end

awk '!/^\s*($|#)/' "$REPO_ROOT/home/.scripts/pnpm_packages.txt" |
	xargs pnpm install --global
