# Multi-stage Dockerfile for Archipelago Server
# Stage 1: Download and extract latest Archipelago release
FROM alpine:latest AS downloader

# Install curl and jq for downloading and extracting
RUN apk add --no-cache curl jq

# Create working directory
WORKDIR /tmp

# Download latest Archipelago Linux release
RUN LATEST_URL=$(curl -s https://api.github.com/repos/ArchipelagoMW/Archipelago/releases/latest | \
    jq -r '.assets[] | select(.name | contains("linux-x86_64.tar.gz")) | .browser_download_url') && \
    echo "Downloading: $LATEST_URL" && \
    curl -L -o archipelago.tar.gz "$LATEST_URL" && \
    tar -xzf archipelago.tar.gz && \
    mv Archipelago/* . && \
    rmdir Archipelago && \
    rm archipelago.tar.gz && \
    ls -la .

# Stage 2: Create runtime image
FROM debian:latest

# Create app directory and user
RUN addgroup --gid 1000 archipelago && \
    adduser --shell /bin/bash -u 1000 --ingroup archipelago archipelago

WORKDIR /app

# Copy Archipelago files from downloader stage
COPY --from=downloader --chown=archipelago:archipelago /tmp /app

# Create necessary directories
RUN mkdir -p /app/config /app/games /app/data && \
    chown -R archipelago:archipelago /app

# Create entrypoint script
COPY --chown=archipelago:archipelago entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Switch to non-root user
USER archipelago

# Expose default Archipelago port
EXPOSE 38281

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
