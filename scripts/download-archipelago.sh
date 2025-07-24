#!/bin/bash
set -e

echo "Downloading latest Archipelago release..."

# Get the latest release version from GitHub API
LATEST_VERSION=$(curl -s https://api.github.com/repos/ArchipelagoMW/Archipelago/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not find latest Archipelago release version"
    exit 1
fi

echo "Found latest version: $LATEST_VERSION"

# Construct the download URL for the Linux tar.gz file
DOWNLOAD_URL="https://github.com/ArchipelagoMW/Archipelago/releases/download/${LATEST_VERSION}/Archipelago_${LATEST_VERSION}_linux-x86_64.tar.gz"

echo "Downloading from: $DOWNLOAD_URL"

# Download the latest release
wget -O archipelago-latest.tar.gz "$DOWNLOAD_URL"

# Extract release
tar -xzf archipelago-latest.tar.gz

# Clean up
rm archipelago-latest.tar.gz

echo "Archipelago downloaded and extracted successfully"

# Verify executables exist and make them runnable
if [ -f "Archipelago/ArchipelagoGenerate" ]; then
    chmod +x Archipelago/ArchipelagoGenerate
    echo "ArchipelagoGenerate ready"
else
    echo "Warning: ArchipelagoGenerate not found"
fi

if [ -f "Archipelago/ArchipelagoServer" ]; then
    chmod +x Archipelago/ArchipelagoServer
    echo "ArchipelagoServer ready"
else
    echo "Warning: ArchipelagoServer not found"
fi

echo "Archipelago setup complete"
