#!/bin/bash

# Install dotoold systemd service
# This script helps you install a systemd service for dotoold daemon

set -e

# Check if dotoold exists
if ! command -v dotoold &> /dev/null; then
    echo "Error: dotoold not found in PATH. Please install dotool first."
    echo "You can install it from: https://git.sr.ht/~geb/dotool"
    exit 1
fi

# Check if running as root for system service
if [ "$EUID" -eq 0 ]; then
    echo "Installing dotoold as system service..."
    
    # Copy system service file
    cp dotoold.service /etc/systemd/system/
    
    # Set up udev rule for uinput access
    echo 'KERNEL=="uinput", GROUP="input", MODE="0620"' | sudo tee /etc/udev/rules.d/80-uinput.rules
    
    # Add user to input group
    echo "Adding current user to input group..."
    if [ -n "$SUDO_USER" ]; then
        usermod -a -G input "$SUDO_USER"
    else
        echo "Warning: Could not determine original user. Please add your user to input group manually:"
        echo "sudo usermod -a -G input \$USER"
    fi
    
    # Reload systemd and enable service
    systemctl daemon-reload
    systemctl enable dotoold.service
    
    echo "System service installed successfully!"
    echo "To start the service: sudo systemctl start dotoold.service"
    echo "To check status: sudo systemctl status dotoold.service"
    echo "Note: You may need to log out and back in for group changes to take effect."
    
else
    echo "Installing dotoold as user service..."
    
    # Create user systemd directory
    mkdir -p ~/.config/systemd/user
    
    # Copy user service file
    cp dotoold-user.service ~/.config/systemd/user/dotoold.service
    
    # Add user to input group (requires sudo)
    echo "Adding user to input group (requires sudo)..."
    sudo usermod -a -G input "$USER"
    
    # Set up udev rule for uinput access (requires sudo)
    echo "Setting up udev rule for uinput access (requires sudo)..."
    echo 'KERNEL=="uinput", GROUP="input", MODE="0620"' | sudo tee /etc/udev/rules.d/80-uinput.rules
    
    # Reload systemd and enable service
    systemctl --user daemon-reload
    systemctl --user enable dotoold.service
    
    echo "User service installed successfully!"
    echo "To start the service: systemctl --user start dotoold.service"
    echo "To check status: systemctl --user status dotoold.service"
    echo "Note: You may need to log out and back in for group changes to take effect."
fi

echo ""
echo "After installation, you can test the service with:"
echo "echo 'type hello world' | dotoolc" 