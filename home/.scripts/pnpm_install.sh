#!/usr/bin/env fish

# IMPORTANT! never to be called standalone, only to be called by install.sh
# otherwise REPO_ROOT is not available and script will fail

# install pnpm if not available
if not command -v pnpm >/dev/null 2>&1
    echo "pnpm not found. Installing via official script..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -

    # Refresh config so pnpm available
    source ~/.config/fish/config.fish 2>/dev/null; or true

    # check if installation complete
    if not command -v pnpm >/dev/null 2>&1
        echo "ERROR: pnpm installation failed. Please install manually."
        exit 1
    end
end

# setup pnpm if not already configured and install global packages
if not grep -q "PNPM_HOME" ~/.config/fish/config.fish 2>/dev/null
	pnpm setup
	source ~/.config/fish/config.fish
end

awk '!/^\s*($|#)/' "$REPO_ROOT/home/.scripts/pnpm_packages.txt" |
	xargs pnpm install --global
