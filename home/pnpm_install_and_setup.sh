#!/usr/bin/bash

# install js stuff not in Void repos
pnpm setup
source ~/.config/fish/config.fish
pnpm install --global markdownlint-cli2 prettier
