#!/bin/bash

# Exit on error
set -e

echo "Installing dotool..."

# Install dependencies
echo "Installing dependencies..."
# sudo apt update
# sudo apt install -y libxkbcommon-dev wget tar golang-go scdoc

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download dotool
echo "Downloading dotool v1.5..."
wget https://git.sr.ht/~geb/dotool/archive/1.5.tar.gz

# Extract archive
echo "Extracting archive..."
tar -xzf 1.5.tar.gz
cd dotool-1.5

# Build and install
echo "Building dotool..."
./build.sh

echo "Installing dotool..."
sudo ./build.sh install

# Clean up
cd /
rm -rf "$TEMP_DIR"

echo "dotool installation completed successfully!"
