#!/bin/bash
set -e

echo "Generating Archipelago world..."

# Change to Archipelago directory for generation
cd Archipelago

# Create necessary directories
mkdir -p Players
mkdir -p custom_worlds

# Copy user YAML files to Players directory
if [ -d "players" ] && [ "$(ls -A players/*.y*ml 2>/dev/null)" ]; then
    echo "Copying YAML files..."
    cp players/*.y*ml Archipelago/Players/ 2>/dev/null || true
else
    echo "Warning: No YAML files found in players/ directory"
    echo "Creating a default single-player YAML for testing..."
    cat > Archipelago/Players/Player1.yaml << EOF
name: Player1
game: A Link to the Past
A Link to the Past:
  progression_balancing: 50
  accessibility: items
EOF
fi

# Copy APWorld files to worlds directory if they exist
if [ -d "worlds" ] && [ "$(ls -A worlds/*.apworld 2>/dev/null)" ]; then
    echo "Copying APWorld files..."
    cp worlds/*.apworld Archipelago/custom_worlds/ 2>/dev/null || true
fi

# Run the generation
echo "Running Archipelago generation..."
./ArchipelagoGenerate

# Check if generation was successful
if [ ! -d "output" ] || [ -z "$(ls -A output/*.archipelago 2>/dev/null)" ]; then
    echo "Error: Generation failed or no .archipelago file was created"
    exit 1
fi

echo "World generation completed successfully"
echo "Generated files:"
ls -la output/*
