# Custom World Files (APWorld)

This directory contains custom Archipelago World (.apworld) files that add support for additional games not included in the base Archipelago installation.

## How to Use

1. Place any `.apworld` files in this directory
2. Build the Docker image - custom worlds will be automatically installed
3. You can then reference these custom games in your player YAML files

## What are APWorld Files?

APWorld files are custom game implementations for Archipelago that:
- Add support for new games not in the base installation
- Extend existing games with new features or randomization options
- Are created by the community and distributed separately

## Finding APWorld Files

You can find community-created APWorld files from:
- The Archipelago Discord server
- Community repositories and forums
- Game-specific modding communities
- Direct from APWorld developers

## Installing APWorld Files

Simply place the `.apworld` files in this directory. The Docker build process will:
1. Copy them to the Archipelago installation
2. Make them available during world generation
3. Allow players to select these games in their YAML configurations

## Using Custom Worlds in YAML

Once an APWorld is installed, you can reference it in player YAML files:

```yaml
name: PlayerName
game: CustomGameName  # This should match the game name from the APWorld
CustomGameName:
  # Custom game-specific options defined by the APWorld
  option1: value1
  option2: value2
```

## Important Notes

- APWorld files must be compatible with your Archipelago version
- Some APWorlds may require additional setup or ROM files
- Check the APWorld documentation for specific requirements
- Not all APWorlds may work in a Docker environment

## Example Structure

```
worlds/
├── SuperMetroidAPWorld.apworld
├── HollowKnight.apworld
└── CustomGame.apworld
```

Each APWorld typically includes its own documentation about available options and setup requirements.
