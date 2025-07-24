# Player Configuration Files

This directory contains YAML configuration files for each player in your Archipelago multiworld.

## How to Use

1. Place your player YAML files in this directory
2. Each YAML file represents one player/slot in the multiworld
3. File names can be anything ending in `.yaml` or `.yml`

## Creating YAML Files

You can create YAML files in several ways:

### Option 1: Download from Archipelago Website
1. Visit https://archipelago.gg/games
2. Click on your game's "Options Page"
3. Configure your settings
4. Click "Export Options" to download the YAML

### Option 2: Generate Templates Locally
If you have Archipelago installed locally:
1. Run `ArchipelagoLauncher.exe`
2. Click "Generate Template Options"
3. Templates will be created in `Players/Templates/`

## Example YAML Structure

```yaml
name: YourPlayerName
game: A Link to the Past
A Link to the Past:
  progression_balancing: 50
  accessibility: items
  # ... other game-specific options
```

## Important Notes

- Each player needs a unique `name` field
- The `game` field specifies which game this player will play
- Game-specific options go under the game name section
- YAML is case-sensitive and whitespace-sensitive

## For Multiplayer Games

If you're setting up a multiplayer game:
1. Collect YAML files from all players
2. Place all files in this directory
3. Build the Docker image - it will generate a multiworld for all players

The generated server will host slots for all players defined in the YAML files.
