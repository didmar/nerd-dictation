#!/bin/bash
# Install systemd user service for nerd-dictation tray

set -e

# Get the current directory (where nerd-dictation is located)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_NAME="nerd-dictation-tray.service"
WRAPPER_SCRIPT="$SCRIPT_DIR/nerd-dictation-tray-wrapper.sh"

# Create systemd user directory if it doesn't exist
USER_SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$USER_SYSTEMD_DIR"

echo "Installing Nerd Dictation Tray service..."
echo "Script location: $SCRIPT_DIR"

# Ensure the wrapper script is executable
chmod +x "$WRAPPER_SCRIPT"

# Create the service file with the correct paths
cat > "$USER_SYSTEMD_DIR/$SERVICE_NAME" << EOF
[Unit]
Description=Nerd Dictation Tray GUI
Documentation=https://github.com/didmar/nerd-dictation
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=$WRAPPER_SCRIPT
WorkingDirectory=$SCRIPT_DIR
Restart=on-failure
RestartSec=5
StandardOutput=journal
StandardError=journal

# Environment variables for GUI applications
Environment=DISPLAY=:0
Environment=XDG_RUNTIME_DIR=%t

# Ensure the service stops gracefully
TimeoutStopSec=30
KillMode=mixed
KillSignal=SIGTERM

[Install]
WantedBy=default.target
EOF

echo "Service file created at: $USER_SYSTEMD_DIR/$SERVICE_NAME"

# Make sure the tray script is executable
chmod +x "$SCRIPT_DIR/nerd-dictation-tray.py"

# Reload systemd user daemon and (re)start service
systemctl --user daemon-reload
systemctl --user enable --now "$SERVICE_NAME"

echo "✅ Nerd Dictation Tray service installed and started!" 