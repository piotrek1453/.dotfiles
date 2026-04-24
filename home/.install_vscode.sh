#!/usr/bin/env bash
set -euo pipefail

APP_NAME="vscode-insiders"
INSTALL_DIR="/opt/$APP_NAME"
BIN_PATH="/usr/local/bin/code-insiders"
DESKTOP_FILE="/usr/local/share/applications/code-insiders.desktop"

TMP_DIR="$(mktemp -d)"

cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "==> Installing / Updating VSCode Insiders"

# --- download ---
echo "==> Downloading..."
wget -q "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64" \
	-O "$TMP_DIR/vscode-insiders.tar.gz"

# --- extract ---
echo "==> Extracting..."
tar -xzf "$TMP_DIR/vscode-insiders.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name "VSCode-linux-x64")"

if [[ -z "$EXTRACTED_DIR" ]]; then
	echo "ERROR: extraction failed"
	exit 1
fi

# --- install (atomic replace) ---
echo "==> Installing to $INSTALL_DIR"

sudo rm -rf "$INSTALL_DIR.tmp"
sudo mkdir -p "$INSTALL_DIR.tmp"
sudo cp -r "$EXTRACTED_DIR/"* "$INSTALL_DIR.tmp/"

sudo rm -rf "$INSTALL_DIR"
sudo mv "$INSTALL_DIR.tmp" "$INSTALL_DIR"

# --- wrapper ---
echo "==> Creating wrapper"

sudo tee "$BIN_PATH" >/dev/null <<'EOF'
#!/usr/bin/env sh
# VSCode Insiders launcher (non-blocking)

exec setsid /opt/vscode-insiders/code-insiders "$@" >/dev/null 2>&1 &
EOF

sudo chmod +x "$BIN_PATH"

# --- desktop entry ---
echo "==> Creating desktop entry"

sudo tee "$DESKTOP_FILE" >/dev/null <<EOF
[Desktop Entry]
Name=VS Code Insiders
Comment=Code Editing. Redefined.
Exec=$BIN_PATH %F
Icon=$INSTALL_DIR/resources/app/resources/linux/code.png
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF

# --- refresh desktop db (optional) ---
if command -v update-desktop-database >/dev/null 2>&1; then
	sudo update-desktop-database >/dev/null 2>&1 || true
fi

echo "==> Done!"
echo "Run with: code-insiders"
