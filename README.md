# arch.dotfiles

Personal Arch Linux dotfiles, package lists, installation scripts and system
configuration.

## Scope and assumptions

This repository targets a personal Arch Linux workstation running KDE Plasma.
The configuration also covers Flatpak applications, rootless Podman,
development tools, Rust, pnpm and selected user-level systemd units.

The installer is designed to be run as a normal user from a local checkout. It
uses `sudo` only for operations that need system privileges. Do not run the
installer as `root`.

The repository assumes:

- Arch Linux with a working network connection.
- Git, GNU Make, `sudo`, `curl` and a configured `base-devel` environment.
- An interactive desktop user account.
- rEFInd as the bootloader when AppArmor kernel parameters are configured
  automatically.
- A checkout containing this repository and its submodules.

Review the package lists and configuration files before applying them to a
different machine. They are intentionally opinionated and include desktop,
engineering, networking and development software.

## Quick start

From the repository root, run:

```sh
make -C home/.scripts/installation all
```

The `all` target runs every normal installation step except the optional
Firefox/Arkenfox step and the optional `system-config` step. It is safe to
rerun the targets; package managers, systemd and the individual scripts skip
or preserve already configured resources where possible.

To see the available targets:

```sh
make -C home/.scripts/installation help
```

After the `stow` target has linked the dotfiles into `$HOME`, the Makefile can
also be invoked through the symlink:

```sh
make -C "$HOME/.scripts/installation" all
```

Each script resolves the repository from its own physical location. The
current working directory and an exported `REPO_ROOT` are therefore not
required.

## Installation targets

The Makefile targets are ordered by their dependencies:

| Target | Purpose |
| --- | --- |
| `prerequisites` | Verifies Arch Linux, required commands, Git, `sudo`, Make and `curl`. |
| `submodules` | Initializes and updates Git submodules recursively. |
| `rust` | Installs `rustup`/`base-devel` when needed, selects Rust nightly and installs the listed Cargo tools. |
| `paru` | Builds and installs the local `paru` package from `paru/PKGBUILD` when `paru` is missing. |
| `packages` | Installs `system_packages.txt` with `paru` and configures AppArmor/audit integration. |
| `apparmor` | Convenience target that runs the package target, including AppArmor configuration. |
| `flatpak` | Installs the listed applications into the current user's Flatpak installation. |
| `stow` | Links the contents of `home/` into `$HOME` with GNU Stow. |
| `systemd` | Reloads the user manager and enables/starts the configured user units. |
| `pnpm` | Installs the listed global pnpm packages. |
| `hooks` | Installs the repository's pre-commit hook. |
| `system-config` | Optionally installs the repository's pacman and makepkg configuration into `/etc`. |
| `firefox` | Optionally updates the Arkenfox profile when one is present. |

Individual targets can be run with:

```sh
make -C home/.scripts/installation packages
make -C home/.scripts/installation apparmor
make -C home/.scripts/installation flatpak
make -C home/.scripts/installation stow
make -C home/.scripts/installation systemd
make -C home/.scripts/installation pnpm
make -C home/.scripts/installation hooks
make -C home/.scripts/installation firefox
```

The target dependencies may run earlier steps as needed. For example,
`systemd` requires `stow`, and `packages` requires the local `paru` setup.

## Package lists and package installation

System packages are listed in
[`home/.scripts/installation/system_packages.txt`](/home/juchap/arch.dotfiles/home/.scripts/installation/system_packages.txt).
Blank lines and comments are ignored. The list includes, among other things:

- KDE Plasma, desktop applications and Flatpak integration.
- Compilers, language servers, linters and development tools.
- Podman and rootless container tooling.
- Networking, storage, multimedia and engineering tools.
- AppArmor, `audit`, `python-notify2`, `python-psutil`, `tk` and `refind`.

The `packages` script invokes:

```sh
paru -S --needed --noconfirm ...
```

The `--needed` flag avoids reinstalling packages that are already installed.
The script then performs privileged AppArmor and audit configuration. The
package list itself is the source of truth; edit it before adding or removing
system packages.

The Flatpak list is maintained separately in
[`home/.scripts/installation/flatpak_packages.txt`](/home/juchap/arch.dotfiles/home/.scripts/installation/flatpak_packages.txt).
Flatpaks are installed for the current user only. The script does not add
filesystem, device or host-system permissions. KDE integration is provided by
the portal packages already present in the system package list.

## AppArmor, rEFInd and audit notifications

The `packages` target installs AppArmor and the audit notification
dependencies, enables the AppArmor parser cache, configures `auditd`, and
creates a KDE autostart entry for `aa-notify`.

### rEFInd kernel parameters

The installer looks for an existing rEFInd Linux options file in this order:

1. `/boot/refind_linux.conf`
2. `/boot/EFI/refind/refind_linux.conf`
3. `/efi/EFI/refind/refind_linux.conf`

When it finds one, it adds the following parameters without removing existing
LSM entries:

```text
apparmor=1
lsm=existing_modules,apparmor
```

The update is idempotent and preserves the existing order and values. The
installer does not modify GRUB, systemd-boot or arbitrary EFI files. If no
rEFInd options file is found, it prints a manual-action message instead of
guessing a bootloader path.

After changing rEFInd options, reboot manually. The installer never reboots
the computer.

Verify the active kernel configuration after reboot:

```sh
aa-enabled
cat /sys/kernel/security/lsm
cat /proc/cmdline
```

`aa-enabled` confirms whether the AppArmor kernel module is active. The LSM
file should contain `apparmor`, and `/proc/cmdline` should contain
`apparmor=1` plus an `lsm=` value containing AppArmor. A running systemd
service alone does not prove that the kernel module was activated.

### Services and profiles

When systemd is running, the installer executes:

```sh
sudo systemctl enable --now apparmor.service
sudo systemctl enable --now auditd.service
```

It reports the active state of both services. In a container or another
environment without a running systemd instance, service activation is skipped
with an explicit message.

The installer does not create profiles for desktop applications, KDE Plasma,
Flatpak applications, compilers, development tools or Podman. It does not
download or install the community `apparmor.d` project. Review existing
profiles before enabling them:

- `/etc/apparmor.d/` contains installed system profiles.
- `/usr/share/apparmor/extra-profiles/` may contain optional profiles that
  need manual review and adaptation.
- The community `apparmor.d` project is not assumed to be stable or compatible
  with every Arch Linux update.

Use `aa-complain` for a profile during testing. Complain mode logs most policy
violations without blocking them; explicit `deny` rules can still block
access. Use `aa-enforce` only after reviewing the profile and its logs.
Enforce mode blocks violations. No additional profile is automatically placed
in either mode by this repository.

The parser cache is enabled by adding `write-cache` to
`/etc/apparmor/parser.conf`. The default cache directory is
`/var/cache/apparmor/`; the installer never edits or removes its contents.
`systemd-analyze blame | grep apparmor` can be used to compare startup times
before and after the cache is populated.

### KDE `aa-notify`

The notification setup:

1. Creates the system `audit` group if necessary.
2. Adds the invoking desktop user to that group. When invoked through `sudo`,
   `SUDO_USER` is used instead of `root`.
3. Sets `log_group = audit` in `/etc/audit/auditd.conf` without replacing
   other settings.
4. Preserves or creates the `/etc/tmpfiles.d/audit.conf` override:

   ```text
   z /var/log/audit 750 root audit - -
   ```

5. Creates
   `~/.config/autostart/apparmor-notify.desktop` for the desktop user when it
   does not already exist.

The autostart command is:

```text
/usr/bin/aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log
```

`aa-notify` reports AppArmor `DENIED` actions, not every audit event. If the
desktop becomes noisy, review `/etc/apparmor/notify.conf` and profile rules
instead of disabling notifications automatically. Log out and back in after
the group change, then verify:

```sh
systemctl status auditd.service
test -r /var/log/audit/audit.log
command -v aa-notify
test -f "$HOME/.config/autostart/apparmor-notify.desktop"
pgrep -ax aa-notify
```

## Dotfiles and GNU Stow

The `stow` target links the `home/` directory into `$HOME` and uses
`--no-folding`. It intentionally ignores the Arkenfox files that are managed
by the separate Firefox step.

Stow can stop when an unmanaged file already occupies a destination path. Do
not delete files blindly; inspect the conflict, back it up if necessary, and
rerun the target.

The repository contains user configuration for shells, Neovim, terminals,
media tools, systemd user units and other applications. Review the `home/`
tree before applying it to another account.

## User systemd units

[`systemd.sh`](/home/juchap/arch.dotfiles/home/.scripts/installation/systemd.sh)
enables and starts the units listed in its `USER_TIMERS` and `USER_SERVICES`
arrays:

- `backup-sync-poufne.timer`
- `lspmux.service`

The units must already be linked into `$HOME` by `stow`. The target requires an
active `systemd --user` manager. Add future unit names to the arrays before
running the target.

## Rust, pnpm and Firefox

Rust packages are listed in
[`rust_packages.txt`](/home/juchap/arch.dotfiles/home/.scripts/installation/rust_packages.txt).
The Rust step selects the nightly toolchain and installs missing Cargo
packages.

Global pnpm packages are listed in
[`pnpm_packages.txt`](/home/juchap/arch.dotfiles/home/.scripts/installation/pnpm_packages.txt).
The pnpm step requires pnpm to be available and installs that list globally.

The Firefox step is optional and not part of `all`. It runs only when
`$HOME/.mozilla/firefox/arkenfox` exists. It updates the Arkenfox submodule and
may run an interactive cleanup; close Firefox first. If the profile has no
`prefs.js`, the step is skipped.

Some of these steps execute update scripts obtained from the network. Review
the scripts and trust boundary before running them. The removed VS Code
installer is not needed because VS Code Insiders is installed from the package
list.

## Optional system configuration

The `system-config` target installs:

- [`system/etc/pacman.conf`](/home/juchap/arch.dotfiles/system/etc/pacman.conf)
  as `/etc/pacman.conf`;
- [`system/etc/makepkg.conf`](/home/juchap/arch.dotfiles/system/etc/makepkg.conf)
  as `/etc/makepkg.conf`.

This target is not part of `all` and replaces the active configuration files.
Inspect both files before running it:

```sh
make -C home/.scripts/installation system-config
```

For the Arch container test only, `PACMAN_DISABLE_SANDBOX=1` can disable
pacman's Landlock sandbox when the container runtime does not support it.

## Troubleshooting

- Run `make -C home/.scripts/installation help` to confirm target names.
- Run a prerequisite target first if a command is missing.
- Check `git submodule status` and rerun `submodules` when a submodule is
  unavailable.
- Resolve GNU Stow conflicts instead of overwriting unmanaged files.
- If AppArmor is installed but `aa-enabled` reports `No`, inspect
  `/proc/cmdline`, `/sys/kernel/security/lsm` and the rEFInd options file,
  then reboot after correcting the parameters.
- If `aa-notify` is not running immediately, log out and back in after joining
  the `audit` group and confirm that `/var/log/audit/audit.log` is readable.
- A missing profile is not an AppArmor installation failure. Profiles should
  be reviewed, tested in complain mode and only then enforced.

## Validation and continuous integration

The repository uses shell formatting and pre-commit hooks. Validate scripts
locally with:

```sh
for script in home/.scripts/installation/*.sh; do
	bash -n "$script" || exit 1
done
```

GitHub Actions builds the Arch-based [`Containerfile`](/home/juchap/arch.dotfiles/Containerfile)
on pushes and pull requests. The container runs the installation targets and
repository hooks as an integration test. It does not represent a full desktop
session, so user systemd, KDE autostart and bootloader behavior must be
verified on the target machine.
