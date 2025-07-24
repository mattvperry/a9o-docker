#!/bin/sh

echo "Starting Archipelago Server..."

# Check if custom host.yaml exists, otherwise use example
if [ -f "/app/config/host.yaml" ]; then
    echo "Using custom host.yaml configuration"
    cp /app/config/host.yaml /app/host.yaml
elif [ -f "/app/config/host.yaml.example" ]; then
    echo "Using example host.yaml configuration"
    cp /app/config/host.yaml.example /app/host.yaml
else
    echo "No host.yaml found, server will use defaults"
fi

# Look for .archipelago file in games directory
ARCHIPELAGO_FILE=$(find /app/games -name "*.archipelago" | head -1)

if [ -z "$ARCHIPELAGO_FILE" ]; then
    echo "ERROR: No .archipelago file found in /app/games directory"
    echo "Please mount a directory containing your .archipelago file to /app/games"
    exit 1
fi

echo "Found archipelago file: $ARCHIPELAGO_FILE"

# Find the ArchipelagoServer executable
SERVER_EXEC=$(find /app -name "ArchipelagoServer*" -type f | head -1)

if [ -z "$SERVER_EXEC" ]; then
    echo "ERROR: ArchipelagoServer executable not found"
    exit 1
fi

echo "Using server executable: $SERVER_EXEC"

# Make sure the server executable is executable
chmod +x "$SERVER_EXEC"

# Start the server with the found .archipelago file
echo "Starting Archipelago Server..."
exec "$SERVER_EXEC" "$ARCHIPELAGO_FILE"
