#!/bin/bash
# Script to toggle the nerd-dictation process (start/stop)
# Create a begin.sh script with your command to start nerd-dictation
# with the parameters you want to use.

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Path to the cookie file used by nerd-dictation
COOKIE_FILE="/tmp/nerd-dictation.cookie"

# Check if nerd-dictation is running
if [ -f "$COOKIE_FILE" ]; then
    # Cookie file exists, check if the process is still running
    PID=$(cat "$COOKIE_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "nerd-dictation is running (PID: $PID). Stopping it..."
        # Show notification that we're stopping
        notify-send "🎤 Nerd Dictation" "⏸️ Stopping voice dictation" --icon=audio-input-microphone
        # Kill the process (the command to stop it gracefully is not working)
        kill -9 $PID
        rm $COOKIE_FILE
        echo "nerd-dictation stopped."
        exit 0
    fi
fi

# Cookie file doesn't exist, start nerd-dictation
echo "Starting nerd-dictation..."
# Show notification that we're starting
notify-send "🎤 Nerd Dictation" "⏺️ Starting voice dictation" --icon=audio-input-microphone
./begin.sh
echo "nerd-dictation started."
