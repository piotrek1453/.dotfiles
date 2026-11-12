# arch.dotfiles

Dotfiles, package lists and installation scripts for Arch Linux.

## Installation

Run the installer as a normal user from the repository checkout:

```sh
make -C home/.scripts/installation all
```

The installation is split into independently runnable steps. To run only one
step, for example:

```sh
make -C home/.scripts/installation packages
make -C home/.scripts/installation flatpak
make -C home/.scripts/installation stow
make -C home/.scripts/installation pnpm
make -C home/.scripts/installation hooks
make -C home/.scripts/installation systemd
make -C home/.scripts/installation system-config
make -C home/.scripts/installation firefox
```

After the dotfiles have been linked into `$HOME`, the same Makefile can be
called through the symlink:

```sh
make -C "$HOME/.scripts/installation" all
```

Use `make -C home/.scripts/installation help` to list all available steps. Each
step resolves the repository from its own physical path, so it does not depend
on the current working directory or on an exported `REPO_ROOT`.

The installer currently requires Arch Linux, Git, `sudo`, network access and a
checkout of this repository. It installs system packages with `paru`, builds the
local `paru` package when needed, configures Rust nightly, global pnpm packages
and the Flatpak applications listed in
`home/.scripts/installation/flatpak_packages.txt`, and links files from `home/`
with GNU Stow. Re-running the
targets is supported; already configured components are detected and skipped
where possible.

The `flatpak` target installs applications for the current user only. It uses
the default Flatpak sandbox without adding filesystem or device access, while
`xdg-desktop-portal` and `xdg-desktop-portal-kde` provide controlled KDE
integration for file pickers, URLs and MIME handlers. Discover and `flatpak-kcm`
can manage the same user installation.

The `hooks` target runs `pre-commit install` in the repository. Hook definitions
are versioned in `.pre-commit-config.yaml`; the configured hooks remove trailing
whitespace, ensure a final newline and format shell scripts with `shfmt`.

The `systemd` target reloads the user systemd manager and enables and starts all
timer and service units listed in `home/.scripts/installation/systemd.sh`. It
is safe to run repeatedly. It requires an active `systemd --user` manager and
the units linked into `$HOME` by the `stow` target. Add future unit names to the
`USER_TIMERS` or `USER_SERVICES` list in that script. The Rust step installs the
Cargo packages listed in `home/.scripts/installation/rust_packages.txt` when
they are not already installed, so `lspmux.service` can be started automatically.

The optional `system-config` target installs `system/etc/pacman.conf` and
`system/etc/makepkg.conf` into `/etc` using `sudo`. It is not part of `all` and
replaces the active system configuration, so inspect those files before running
it. The Arch-based container test runs this target before the full installation
to verify package builds with these settings. Container-only environments can
set `PACMAN_DISABLE_SANDBOX=1` when the runtime does not support pacman's
Landlock sandbox.

The `firefox` step updates the Arkenfox profile only when
`$HOME/.mozilla/firefox/arkenfox` exists, and is intentionally not part of `all`
because it may require Firefox to be closed and an interactive cleanup of
`prefs.js`. If the profile has no `prefs.js`, the step is skipped. Stow can fail
when an unmanaged file already occupies a target path; resolve such conflicts
before retrying.

Some steps execute installers or update scripts downloaded from the network
(pnpm and Arkenfox). Review that trust boundary before running
`all`. The VS Code installer script was removed because VS Code is installed
from the AUR package list.

## Continuous integration

GitHub Actions builds the Arch-based `Containerfile` on pushes and pull
requests. The image performs the full dotfiles installation and runs all
repository hooks during the build, so a broken installation or formatting
configuration fails CI. Building the image includes compiling `paru` and
installing the complete Arch package list, so the workflow is intentionally an
integration test rather than a fast lint-only job.
