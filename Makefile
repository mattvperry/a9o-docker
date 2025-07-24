.PHONY: help build run stop clean logs shell test

# Default image name and tag
IMAGE_NAME ?= archipelago-server
IMAGE_TAG ?= latest
CONTAINER_NAME ?= archipelago-server

help: ## Show this help message
	@echo "Archipelago Docker Server - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	@echo "Building Archipelago server image..."
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

run: ## Run the container with default settings
	@echo "Starting Archipelago server..."
	docker run -d --name $(CONTAINER_NAME) -p 38281:38281 $(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Server started! Connect to localhost:38281"

run-fg: ## Run the container in foreground (see logs)
	@echo "Starting Archipelago server in foreground..."
	docker run --rm --name $(CONTAINER_NAME) -p 38281:38281 $(IMAGE_NAME):$(IMAGE_TAG)

stop: ## Stop the running container
	@echo "Stopping Archipelago server..."
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

logs: ## View container logs
	docker logs -f $(CONTAINER_NAME)

shell: ## Open a shell in the running container
	docker exec -it $(CONTAINER_NAME) /bin/bash

test: ## Build and run a quick test
	@echo "Building and testing Archipelago server..."
	$(MAKE) build
	$(MAKE) run
	@echo "Waiting for server to start..."
	@sleep 10
	@echo "Testing connection..."
	@nc -z localhost 38281 && echo "✅ Server is responding!" || echo "❌ Server is not responding"
	$(MAKE) stop

clean: ## Remove containers and images
	@echo "Cleaning up..."
	docker stop $(CONTAINER_NAME) 2>/dev/null || true
	docker rm $(CONTAINER_NAME) 2>/dev/null || true
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) 2>/dev/null || true

compose-up: ## Start with docker-compose
	docker-compose up -d

compose-down: ## Stop docker-compose services
	docker-compose down

compose-logs: ## View docker-compose logs
	docker-compose logs -f

# Example usage with custom image name
# make build IMAGE_NAME=my-game IMAGE_TAG=v1
# make run IMAGE_NAME=my-game IMAGE_TAG=v1 CONTAINER_NAME=my-game-server
