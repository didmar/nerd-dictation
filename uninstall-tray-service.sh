#!/bin/bash
# Uninstall systemd user service for nerd-dictation tray

set -e

# Get the current directory (where nerd-dictation is located)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_NAME="nerd-dictation-tray.service"
USER_SYSTEMD_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$USER_SYSTEMD_DIR/$SERVICE_NAME"
WRAPPER_SCRIPT="$SCRIPT_DIR/nerd-dictation-tray-wrapper.sh"

echo "Uninstalling Nerd Dictation Tray service..."

# Stop and disable the service if it exists
if systemctl --user is-enabled --quiet "$SERVICE_NAME" 2>/dev/null; then
    echo "Stopping and disabling service..."
    systemctl --user stop "$SERVICE_NAME" 2>/dev/null || true
    systemctl --user disable "$SERVICE_NAME" 2>/dev/null || true
else
    echo "Service is not enabled, stopping if running..."
    systemctl --user stop "$SERVICE_NAME" 2>/dev/null || true
fi

# Remove the service file
if [ -f "$SERVICE_FILE" ]; then
    rm "$SERVICE_FILE"
    echo "Service file removed: $SERVICE_FILE"
else
    echo "Service file not found: $SERVICE_FILE"
fi

# Reload systemd user daemon
systemctl --user daemon-reload

echo ""
echo "✅ Nerd Dictation Tray service uninstalled!"
echo ""