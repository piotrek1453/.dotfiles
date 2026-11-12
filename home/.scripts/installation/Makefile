SHELL := /usr/bin/bash

INSTALLATION_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
REPO_ROOT := $(shell git -C "$(INSTALLATION_DIR)" rev-parse --show-toplevel 2>/dev/null || realpath "$(INSTALLATION_DIR)/../../..")

.PHONY: all help prerequisites submodules rust paru packages flatpak stow systemd pnpm hooks system-config firefox

all: prerequisites submodules rust paru packages flatpak stow systemd pnpm hooks

help:
	@printf '%s\n' \
		'Usage: make [target]' \
		'' \
		'Targets:' \
		'  all            Run every installation step except for firefox' \
		'  prerequisites  Check the host system and required bootstrap tools' \
		'  submodules     Initialize and update Git submodules' \
		'  rust           Install rustup and select the nightly toolchain' \
		'  paru           Build and install the local paru package' \
		'  packages       Install packages from system_packages.txt' \
		'  flatpak        Install Flatpak applications from flatpak_packages.txt' \
		'  stow           Link the dotfiles into HOME' \
		'  systemd        Enable and start the configured user systemd units' \
		'  pnpm           Install pnpm and global packages' \
		'  hooks          Install the pre-commit Git hook' \
		'  system-config  Install pacman and makepkg config into /etc (optional)' \
		'  firefox        Update the Arkenfox profile when present (optional)'

prerequisites:
	"$(INSTALLATION_DIR)/prerequisites.sh"

submodules: prerequisites
	"$(INSTALLATION_DIR)/submodules.sh"

rust: prerequisites
	"$(INSTALLATION_DIR)/rust.sh"

paru: rust
	"$(INSTALLATION_DIR)/paru.sh"

packages: paru
	"$(INSTALLATION_DIR)/packages.sh"

flatpak: packages
	"$(INSTALLATION_DIR)/flatpak.sh"

stow: packages
	"$(INSTALLATION_DIR)/stow.sh"

systemd: stow
	"$(INSTALLATION_DIR)/systemd.sh"

pnpm: stow
	"$(INSTALLATION_DIR)/pnpm.sh"

hooks: packages
	@if git -C "$(REPO_ROOT)" rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
		cd "$(REPO_ROOT)" && pre-commit install; \
	else \
		printf '[SKIP] pre-commit install skipped (no .git in repository root).\n'; \
	fi

system-config: prerequisites
	"$(INSTALLATION_DIR)/system-config.sh"

firefox: stow
	"$(INSTALLATION_DIR)/firefox.sh"
