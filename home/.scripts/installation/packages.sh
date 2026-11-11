#!/usr/bin/env bash

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/common.sh"

require_command paru
PACKAGE_FILE="$REPO_ROOT/home/.scripts/installation/system_packages.txt"

mapfile -t packages < <(awk '
  /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
  { sub(/[[:space:]]+#.*/, ""); gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length) print }
' "$PACKAGE_FILE")

if ((${#packages[@]} == 0)); then
	skip 'No Arch packages are listed.'
	exit 0
fi

paru -S --needed --noconfirm "${packages[@]}"
info 'Arch packages are installed.'
if pacman -Q apparmor audit python-notify2 python-psutil tk >/dev/null 2>&1; then
	info 'AppArmor notification packages are installed.'
else
	info 'One or more AppArmor notification packages could not be verified with pacman -Q.'
fi

require_command sudo

desktop_user="${SUDO_USER:-${USER:-}}"
if [[ -z "$desktop_user" || "$desktop_user" == root ]] || ! id "$desktop_user" >/dev/null 2>&1; then
	desktop_user="$(id -un)"
fi
desktop_home="$(getent passwd "$desktop_user" | cut -d: -f6)"
desktop_group="$(id -gn "$desktop_user")"

configure_kernel_parameters() {
	local changed=0
	local refind_config

	for refind_candidate in /boot/refind_linux.conf /boot/EFI/refind/refind_linux.conf /efi/EFI/refind/refind_linux.conf; do
		if [[ -f "$refind_candidate" ]]; then
			refind_config="$refind_candidate"
			break
		fi
	done

	if [[ -n "$refind_config" ]]; then
		if ! sudo grep -Eq '^[[:space:]]*[^#].*apparmor=1([[:space:]"$]|$)' "$refind_config"; then
			sudo sed -Ei '/^[[:space:]]*[^#]/ s/"$/ apparmor=1"/' "$refind_config"
			changed=1
		fi
		if ! sudo grep -Eq '^[[:space:]]*[^#].*lsm=[^"[:space:]]*apparmor' "$refind_config"; then
			if sudo grep -Eq '^[[:space:]]*[^#].*lsm=' "$refind_config"; then
				sudo sed -Ei '/^[[:space:]]*[^#]/ s/(lsm=[^"[:space:]]*)(["[:space:]]|$)/\1,apparmor\2/g' "$refind_config"
			else
				sudo sed -Ei '/^[[:space:]]*[^#]/ s/"$/ lsm=apparmor"/' "$refind_config"
			fi
			changed=1
		fi
		if ((changed)); then
			if ! sudo grep -Eq '^[[:space:]]*[^#].*apparmor=1([[:space:]"$]|$)' "$refind_config" ||
				! sudo grep -Eq '^[[:space:]]*[^#].*lsm=[^"[:space:]]*apparmor' "$refind_config"; then
				info "rEFInd parameters in $refind_config were not safely recognized; add apparmor=1 and lsm=...apparmor manually."
				return
			fi
			info "rEFInd kernel parameters updated in $refind_config; reboot to apply them."
		else
			skip "rEFInd already contains the required AppArmor parameters in $refind_config."
		fi
		return
	fi

	info 'rEFInd configuration was not found in the standard locations; add apparmor=1 and lsm=...apparmor to the active rEFInd options manually.'
}

configure_audit() {
	if ! getent group audit >/dev/null; then
		sudo groupadd --system audit
		info 'Created the audit system group.'
	fi
	if ! id -nG "$desktop_user" | tr ' ' '\n' | grep -Fxq audit; then
		sudo usermod --append --groups audit "$desktop_user"
		info "Added $desktop_user to the audit group; log out and back in to refresh group membership."
	fi

	if sudo grep -Eq '^[[:space:]]*#?[[:space:]]*log_group[[:space:]]*=' /etc/audit/auditd.conf; then
		sudo sed -Ei 's/^[[:space:]]*#?[[:space:]]*log_group[[:space:]]*=.*/log_group = audit/' /etc/audit/auditd.conf
	else
		printf '%s\n' 'log_group = audit' | sudo tee -a /etc/audit/auditd.conf >/dev/null
	fi

	if [[ ! -f /etc/tmpfiles.d/audit.conf ]]; then
		printf '%s\n' 'z /var/log/audit 750 root audit - -' | sudo tee /etc/tmpfiles.d/audit.conf >/dev/null
	elif sudo grep -Fxq 'z /var/log/audit 750 root audit - -' /etc/tmpfiles.d/audit.conf; then
		skip 'Audit tmpfiles override is already configured.'
	else
		info 'Existing /etc/tmpfiles.d/audit.conf was preserved; verify /var/log/audit permissions manually.'
	fi
}

configure_autostart() {
	local autostart_dir="$desktop_home/.config/autostart"
	local autostart_file="$autostart_dir/apparmor-notify.desktop"
	local temporary_file

	temporary_file="$(mktemp)"
	cat >"$temporary_file" <<'EOF'
[Desktop Entry]
Type=Application
Name=AppArmor Notify
Comment=Receive on-screen notifications of AppArmor denials
TryExec=/usr/bin/aa-notify
Exec=/usr/bin/aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log
StartupNotify=false
NoDisplay=true
EOF
	if [[ ! -d "$autostart_dir" ]]; then
		sudo install -d -m 700 -o "$desktop_user" -g "$desktop_group" "$autostart_dir"
	fi
	if [[ ! -f "$autostart_file" ]]; then
		sudo install -m 644 -o "$desktop_user" -g "$desktop_group" "$temporary_file" "$autostart_file"
	else
		skip "Preserved existing $autostart_file."
	fi
	rm -f "$temporary_file"
	info "Configured KDE autostart for aa-notify for $desktop_user."
}

configure_parser_cache() {
	if [[ ! -f /etc/apparmor/parser.conf ]]; then
		info '/etc/apparmor/parser.conf is unavailable; AppArmor cache was not configured.'
		return
	fi
	if sudo grep -Eq '^[[:space:]]*write-cache([[:space:]]|$)' /etc/apparmor/parser.conf; then
		skip 'AppArmor parser cache is already enabled.'
	elif sudo grep -Eq '^[[:space:]]*#[[:space:]]*write-cache([[:space:]]|$)' /etc/apparmor/parser.conf; then
		sudo sed -Ei 's/^[[:space:]]*#[[:space:]]*write-cache([[:space:]]|$)/write-cache\1/' /etc/apparmor/parser.conf
		info 'Enabled the AppArmor parser cache.'
	else
		printf '%s\n' 'write-cache' | sudo tee -a /etc/apparmor/parser.conf >/dev/null
		info 'Enabled the AppArmor parser cache.'
	fi
}

configure_kernel_parameters
configure_audit
configure_parser_cache

if [[ -x "$(command -v systemctl 2>/dev/null || true)" && -d /run/systemd/system ]]; then
	sudo systemctl enable --now apparmor.service
	sudo systemctl enable --now auditd.service
	if systemctl is-active --quiet apparmor.service; then
		info 'apparmor.service is active.'
	else
		info 'apparmor.service is enabled but not active.'
	fi
	if systemctl is-active --quiet auditd.service; then
		info 'auditd.service is active.'
	else
		info 'auditd.service is enabled but not active.'
	fi
else
	info 'systemd is not running; AppArmor and auditd services will be enabled on the next boot or by rerunning this step.'
fi

if command -v aa-notify >/dev/null 2>&1; then
	configure_autostart
else
	info 'aa-notify is unavailable in the installed AppArmor package; desktop notifications were not configured.'
fi

if command -v aa-enabled >/dev/null 2>&1; then
	if aa-enabled >/dev/null 2>&1; then
		info 'AppArmor kernel module is active.'
	else
		info 'AppArmor package is installed, but the kernel module is not active yet; reboot after applying kernel parameters.'
	fi
fi
if command -v aa-status >/dev/null 2>&1; then
	sudo aa-status || info 'AppArmor status is unavailable until the kernel module is active.'
fi
if [[ -r /sys/kernel/security/lsm ]]; then
	info "Active LSMs: $(cat /sys/kernel/security/lsm)"
fi
if [[ -d /etc/apparmor.d ]]; then
	info "System AppArmor profiles are available in /etc/apparmor.d; no additional profiles were enabled automatically."
fi
if [[ -d /usr/share/apparmor/extra-profiles ]]; then
	info 'Optional AppArmor profiles are available in /usr/share/apparmor/extra-profiles; review them before use.'
fi
if [[ -d /var/cache/apparmor ]]; then
	info 'AppArmor profile cache directory exists.'
else
	info 'AppArmor profile cache will be created when profiles are loaded.'
fi
if [[ -r /var/log/audit/audit.log ]]; then
	info "Audit log is readable by the installer account: $desktop_user."
else
	info "Audit log is not readable in the current session; log out and back in after joining the audit group."
fi
if command -v pgrep >/dev/null 2>&1 && pgrep -ax aa-notify >/dev/null 2>&1; then
	info 'aa-notify is running.'
else
	info 'aa-notify will start from KDE autostart at the next login.'
fi
if command -v systemd-analyze >/dev/null 2>&1 && [[ -d /run/systemd/system ]]; then
	systemd-analyze blame | grep apparmor || info 'No AppArmor timing entry is available yet.'
fi
