# Archipelago Docker Server

A Docker-based solution for hosting Archipelago multiworld servers with support for custom worlds and player configurations.

## Overview

This project provides a reusable Docker setup that:
- Downloads the latest Archipelago release automatically
- Supports custom APWorld files for additional games
- Generates multiworld games from player YAML configurations
- Hosts the resulting Archipelago server in a containerized environment
- Creates tagged images for different game configurations

## Quick Start

1. **Add your player configurations:**
   ```bash
   # Place player YAML files in the players/ directory
   cp your-player-config.yaml players/
   ```

2. **Add custom worlds (optional):**
   ```bash
   # Place any .apworld files in the worlds/ directory
   cp CustomGame.apworld worlds/
   ```

3. **Build and run (using Makefile):**
   ```bash
   make build    # Build the Docker image
   make run      # Run the server in background
   make logs     # View server logs
   ```

   **Or build manually:**
   ```bash
   docker build -t my-archipelago-game:v1 .
   docker run -p 38281:38281 my-archipelago-game:v1
   ```

4. **Connect to your server:**
   - Server: `localhost` (or your Docker host IP)
   - Port: `38281`
   - Use the slot names from your YAML files

### Available Make Commands

Run `make help` to see all available commands:
- `make build` - Build the Docker image
- `make run` - Run the server in background
- `make run-fg` - Run the server in foreground (see logs)
- `make stop` - Stop the running server
- `make logs` - View server logs
- `make test` - Build and test the server
- `make clean` - Remove containers and images

## Directory Structure

```
a9o-docker/
├── Dockerfile                 # Multi-stage Docker build
├── docker-compose.yml         # Compose setup for easy deployment
├── players/                   # Player YAML configuration files
│   ├── .gitignore
│   └── README.md             # Instructions for creating player configs
├── worlds/                    # Custom APWorld files
│   ├── .gitignore
│   └── README.md             # Instructions for custom worlds
├── scripts/                   # Build and runtime scripts
│   ├── download-archipelago.sh
│   ├── generate-world.sh
│   └── start-server.sh
├── .gitignore
├── .dockerignore
└── README.md
```

## Usage

### Building Different Game Configurations

Each build creates a unique image with a specific set of players and worlds:

```bash
# Build a game for your friend group
cp alice.yaml bob.yaml charlie.yaml players/
docker build -t friend-group-game:jan2025 .

# Build a different game with custom worlds
cp custom-world.apworld worlds/
cp different-players.yaml players/
docker build -t custom-world-game:v1 .
```

### Using Docker Compose

For easier deployment with environment configuration:

```bash
# Create a .env file (optional)
echo "ARCHIPELAGO_PORT=38281" > .env
echo "ARCHIPELAGO_PASSWORD=mypassword" >> .env

# Start the server
docker-compose up -d

# View logs
docker-compose logs -f
```

### Environment Variables

- `ARCHIPELAGO_PORT`: Server port (default: 38281)
- `ARCHIPELAGO_PASSWORD`: Optional server password

### Advanced Usage

#### Custom Port
```bash
docker run -p 9999:38281 -e ARCHIPELAGO_PORT=38281 my-game:v1
# Server accessible on port 9999 externally
```

#### Password Protection
```bash
docker run -p 38281:38281 -e ARCHIPELAGO_PASSWORD=secretpassword my-game:v1
```

## Player Configuration

See `players/README.md` for detailed instructions on creating player YAML files.

Quick example:
```yaml
name: PlayerName
game: A Link to the Past
A Link to the Past:
  progression_balancing: 50
  accessibility: items
```

## Custom Worlds

See `worlds/README.md` for instructions on adding custom APWorld files.

## How It Works

### Build Process (Generation)
1. Downloads latest Archipelago from GitHub
2. Installs custom APWorld files if present
3. Copies player YAML configurations
4. Runs Archipelago generation to create .archipelago file
5. Creates optimized runtime image with generated data

### Runtime Process (Hosting)
1. Starts Archipelago server with pre-generated .archipelago file
2. Exposes server on configured port
3. Provides health checks for monitoring

## Troubleshooting

### Build Issues
- Ensure YAML files are valid (check syntax)
- Verify APWorld files are compatible with current Archipelago version
- Check Docker build logs for specific errors

### Runtime Issues
- Verify port 38281 is not already in use
- Check that generated .archipelago file exists
- Review server logs: `docker logs <container-name>`

### Connection Issues
- Confirm server is running: `docker ps`
- Test port connectivity: `telnet localhost 38281`
- Verify slot names match YAML configurations

## Development

The project uses a multi-stage Docker build:
- **Builder stage**: Downloads Archipelago, installs worlds, generates game
- **Runtime stage**: Lightweight image with only server components

Scripts are modular and can be run independently for testing.

## License

MIT License - see LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Test your changes with different YAML/APWorld combinations
4. Submit a pull request

## Related Links

- [Archipelago Official Site](https://archipelago.gg/)
- [Archipelago GitHub](https://github.com/ArchipelagoMW/Archipelago)
- [Game Setup Guides](https://archipelago.gg/tutorial/)
- [APWorld Development](https://github.com/ArchipelagoMW/Archipelago/blob/main/docs/world%20api.md)
