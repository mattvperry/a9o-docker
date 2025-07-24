#!/bin/bash
set -e

echo "Starting Archipelago server..."

# Change to Archipelago directory
cd Archipelago

# Find the .archipelago file in the output directory
ARCHIPELAGO_FILE=$(find output -name "*.archipelago" | head -1)

if [ -z "$ARCHIPELAGO_FILE" ]; then
    echo "Error: No .archipelago file found in output directory"
    exit 1
fi

echo "Found Archipelago file: $ARCHIPELAGO_FILE"

# Get server port from environment variable, default to 38281
SERVER_PORT=${ARCHIPELAGO_PORT:-38281}

# Get server password from environment variable if set
SERVER_PASSWORD=${ARCHIPELAGO_PASSWORD:-}

echo "Starting Archipelago server on port $SERVER_PORT"

# Start the server with the generated file
if [ -n "$SERVER_PASSWORD" ]; then
    echo "Starting server with password protection"
    ./ArchipelagoServer "../$ARCHIPELAGO_FILE" --port "$SERVER_PORT" --password "$SERVER_PASSWORD"
else
    echo "Starting server without password"
    ./ArchipelagoServer "../$ARCHIPELAGO_FILE" --port "$SERVER_PORT"
fi
