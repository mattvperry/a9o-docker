# Multi-stage build for Archipelago server
FROM python:3.11-slim as builder

# Install system dependencies needed for Archipelago
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy build scripts
COPY scripts/ ./scripts/
RUN chmod +x scripts/*.sh

# Download and extract latest Archipelago
RUN ./scripts/download-archipelago.sh

# Copy user files for generation
COPY worlds/ ./worlds/
COPY players/ ./players/

# Generate the .archipelago file
RUN ./scripts/generate-world.sh

# Runtime stage
FROM python:3.11-slim as runtime

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Create archipelago user
RUN useradd -m -u 1000 archipelago

# Set working directory
WORKDIR /app

# Copy Archipelago installation from builder
COPY --from=builder --chown=archipelago:archipelago /app/Archipelago/ ./Archipelago/

# Copy generated .archipelago file
COPY --from=builder --chown=archipelago:archipelago /app/output/ ./output/

# Copy startup script
COPY --chown=archipelago:archipelago scripts/start-server.sh ./
RUN chmod +x start-server.sh

# Switch to non-root user
USER archipelago

# Expose Archipelago default port
EXPOSE 38281

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python3 -c "import socket; socket.create_connection(('localhost', 38281), timeout=5)" || exit 1

# Start the server
CMD ["./start-server.sh"]
