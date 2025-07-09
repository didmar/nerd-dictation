#!/bin/bash
# Wrapper script for nerd-dictation tray that prefers the project's virtual environment if it exists.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TRAY_SCRIPT="$SCRIPT_DIR/nerd-dictation-tray.py"

# If virtual environment exists, use its Python interpreter; otherwise, fall back to system python3.
if [ -f "$SCRIPT_DIR/venv/bin/python" ]; then
    exec "$SCRIPT_DIR/venv/bin/python" "$TRAY_SCRIPT" "$@"
else
    exec python3 "$TRAY_SCRIPT" "$@"
fi