#!/bin/bash
set -e

echo "Downloading latest Archipelago release..."

# Get the latest release download URL from GitHub API
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/ArchipelagoMW/Archipelago/releases/latest | grep "browser_download_url.*\.zip" | cut -d '"' -f 4)

if [ -z "$LATEST_RELEASE_URL" ]; then
    echo "Error: Could not find latest Archipelago release"
    exit 1
fi

echo "Found latest release: $LATEST_RELEASE_URL"

# Download the latest release
wget -O archipelago-latest.zip "$LATEST_RELEASE_URL"

# Extract the archive
unzip -q archipelago-latest.zip

# Find the extracted directory (it may have a version number)
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "*Archipelago*" | head -1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "Error: Could not find extracted Archipelago directory"
    exit 1
fi

# Rename to standard directory name
mv "$EXTRACTED_DIR" Archipelago

# Clean up
rm archipelago-latest.zip

echo "Archipelago downloaded and extracted successfully"

# Make executables runnable
chmod +x Archipelago/ArchipelagoGenerate
chmod +x Archipelago/ArchipelagoServer

echo "Archipelago setup complete"
