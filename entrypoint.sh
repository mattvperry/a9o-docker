#!/bin/sh

echo "Starting Archipelago Server..."

# Check if custom host.yaml exists, otherwise use example
if [ -f "/app/config/host.yaml" ]; then
    echo "Using custom host.yaml configuration"
    cp /app/config/host.yaml /app/host.yaml
elif [ -f "/config/host.yaml.example" ]; then
    echo "Using example host.yaml configuration"
    cp /app/config/host.yaml.example /host.yaml
else
    echo "No host.yaml found, server will use defaults"
fi

# Check if custom host.yaml exists, otherwise use example
if [ -f "/app/games/multiworld.archipelago" ]; then
    echo "Found .archipelago file in /app/games"
else
    echo "No .archipelago file found, server cannot start"
    exit 1
fi

# Make sure the server executable is executable
chmod +x /app/ArchipelagoServer

# Start the server with the found .archipelago file
echo "Starting Archipelago Server..."
/app/ArchipelagoServer /app/games/multiworld.archipelago
