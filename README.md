# Archipelago Docker Server

A Docker container for hosting Archipelago multiworld servers with automatic latest release downloads and persistent data storage.

## Features

- 🐳 **Docker & Docker Compose** - Industry standard containerization
- 📦 **Latest Release** - Automatically downloads the latest Archipelago Linux release during build
- ⚙️ **Configurable** - Support for custom `host.yaml` configurations
- 💾 **Persistent Data** - Named volume for server state and save data
- 🔒 **Security** - Runs as non-root user
- 🏗️ **Optimized Build** - Multi-stage Docker build with Alpine Linux for minimal image size
- 🔧 **BuildX Ready** - Optimized layer design for Docker BuildX

## Quick Start

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd a9o-docker
   ```

2. **Place your .archipelago file**
   ```bash
   cp /path/to/your/game.archipelago ./games/
   ```

3. **Start the server**
   ```bash
   docker-compose up -d
   ```

4. **Connect to your server**
   - **Host:** `localhost` (or your server's IP)
   - **Port:** `38281`
   - **Slot Name:** As configured in your YAML file
   - **Password:** As configured (if any)

## Directory Structure

```
a9o-docker/
├── docker-compose.yml          # Docker Compose configuration
├── Dockerfile                  # Multi-stage Docker build
├── entrypoint.sh              # Container startup script
├── .dockerignore              # Build optimization
├── config/
│   └── host.yaml.example      # Example server configuration
├── games/                     # Place .archipelago files here
└── data/                      # Persistent server data (managed by Docker)
```

## Configuration

### Custom Host Configuration

1. Copy the example configuration:
   ```bash
   cp config/host.yaml.example config/host.yaml
   ```

2. Edit `config/host.yaml` with your preferred settings:
   ```yaml
   # Example customizations
   server_password: "your-password"  # Require password to join
   auto_shutdown: 60                 # Auto-shutdown after 60 minutes of inactivity
   race: 1                          # Enable race mode
   ```

3. Restart the container:
   ```bash
   docker-compose restart
   ```

### Environment Variables

You can override certain settings via environment variables in `docker-compose.yml`:

- `PORT`: Server port (default: 38281)

## Usage

### Starting the Server

```bash
# Start in background
docker-compose up -d

# Start with logs visible
docker-compose up

# Build and start (after changes)
docker-compose up --build
```

### Viewing Logs

```bash
# Follow logs
docker-compose logs -f archipelago-server

# View recent logs
docker-compose logs --tail=50 archipelago-server
```

### Stopping the Server

```bash
# Stop the server
docker-compose down

# Stop and remove volumes (WARNING: This deletes save data!)
docker-compose down -v
```

## Building with Docker BuildX

For optimal builds with BuildX:

```bash
# Create and use a new builder
docker buildx create --name archipelago-builder --use

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t archipelago-server:latest .

# Build and push to registry
docker buildx build --platform linux/amd64,linux/arm64 -t your-registry/archipelago-server:latest --push .
```

## Persistent Data

The container uses a named Docker volume (`archipelago_data`) to persist server state and save data. This ensures your game progress is retained across container updates and restarts.

To backup your save data:
```bash
# Create a backup
docker run --rm -v archipelago_data:/data -v $(pwd):/backup alpine tar czf /backup/archipelago-backup.tar.gz -C /data .

# Restore from backup
docker run --rm -v archipelago_data:/data -v $(pwd):/backup alpine tar xzf /backup/archipelago-backup.tar.gz -C /data
```

## Troubleshooting

### Server Won't Start

1. Check that you have a `.archipelago` file in the `games/` directory:
   ```bash
   ls -la games/
   ```

2. Check the container logs:
   ```bash
   docker-compose logs archipelago-server
   ```

### Connection Issues

1. Verify the server is running:
   ```bash
   docker-compose ps
   ```

2. Check port binding:
   ```bash
   docker-compose port archipelago-server 38281
   ```

3. Ensure firewall allows connections on port 38281

### Performance Issues

1. Check container resource usage:
   ```bash
   docker stats archipelago-server
   ```

2. Consider allocating more resources in `docker-compose.yml`:
   ```yaml
   services:
     archipelago-server:
       deploy:
         resources:
           limits:
             memory: 1G
             cpus: '1.0'
   ```

## Advanced Usage

### Running Multiple Servers

To run multiple Archipelago servers, create separate docker-compose files or use different service names:

```yaml
# docker-compose.multi.yml
version: '3.8'
services:
  archipelago-server-1:
    # ... configuration for server 1
    ports:
      - "38281:38281"
  
  archipelago-server-2:
    # ... configuration for server 2  
    ports:
      - "38282:38281"
```

### Custom Archipelago Version

To use a specific Archipelago version instead of latest, modify the Dockerfile:

```dockerfile
# Replace the dynamic download with a specific version
RUN curl -L -o archipelago.zip "https://github.com/ArchipelagoMW/Archipelago/releases/download/0.4.4/Archipelago_0.4.4_linux.zip"
```

## Support

For Archipelago-specific questions, visit:
- [Archipelago Website](https://archipelago.gg)
- [Archipelago Discord](https://discord.gg/8Z65BR2)
- [Archipelago GitHub](https://github.com/ArchipelagoMW/Archipelago)

For Docker-related issues with this container, please open an issue in this repository.
