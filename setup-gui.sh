#!/bin/bash
# Setup script for nerd-dictation tray

echo "Setting up nerd-dictation tray..."

# Update package list
sudo apt update

# Install system dependencies for GTK AppIndicator3
echo "Installing system dependencies..."
sudo apt install -y \
    python3-gi \
    python3-gi-cairo \
    gir1.2-gtk-3.0 \
    gir1.2-appindicator3-0.1 \
    libgirepository1.0-dev \
    gcc \
    libcairo2-dev \
    pkg-config \
    gir1.2-gtk-3.0 \
    python3-pip \
    python3-venv

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install -r requirements-gui.txt

echo "Setup complete!"
echo ""
echo "To run the GUI: ./nerd-dictation-tray.py"
echo ""
echo "Make sure to adjust the path to nerd-dictation in the GUI scripts if needed." 
