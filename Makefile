# Makefile for MySQL Graph Visualizer

.PHONY: help install generate format test build run clean docker-up docker-down

# Default target
help:
	@echo "MySQL Graph Visualizer - Development Commands"
	@echo ""
	@echo "Available targets:"
	@echo "  install    - Install dependencies and tools"
	@echo "  generate   - Generate GraphQL code"
	@echo "  format     - Format Go code"
	@echo "  test       - Run tests"
	@echo "  build      - Build the application"
	@echo "  run        - Run the application"
	@echo "  clean      - Clean build artifacts"
	@echo "  docker-up  - Start Docker services (Neo4j)"
	@echo "  docker-down- Stop Docker services"
	@echo "  ci-check   - Run CI checks locally"
	@echo ""

# Install dependencies and tools
install:
	@echo "Installing dependencies..."
	go mod download
	go mod tidy
	@echo "Installing gqlgen..."
	go install github.com/99designs/gqlgen@v0.17.78
	@echo "Installation complete"

# Generate GraphQL code
generate:
	@echo "Generating GraphQL code..."
	$(HOME)/go/bin/gqlgen generate
	@echo "GraphQL code generated"

# Format Go code
format:
	@echo "Formatting Go code..."
	gofmt -s -w .
	@echo "Code formatted"

# Run tests
test:
	@echo "Running unit tests..."
	go test -v -race -coverprofile=coverage.out -covermode=atomic \
		$(shell go list ./... | grep -v '/internal/tests/integration')
	@echo "Tests completed"

# Run integration tests (requires Docker services)
test-integration:
	@echo "Running integration tests..."
	go test -v -timeout 15m -tags=integration \
		-coverprofile=integration-coverage.out \
		-covermode=atomic \
		./internal/tests/integration/...
	@echo "Integration tests completed"

# Build the application
build:
	@echo "Building application..."
	go build -o mysql-graph-visualizer cmd/main.go
	@echo "Build completed"

# Run the application
run:
	@echo "Starting application..."
	go run cmd/main.go

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -f mysql-graph-visualizer
	rm -f coverage.out
	rm -f integration-coverage.out
	@echo "Clean completed"

# Start Docker services
docker-up:
	@echo "Starting Docker services..."
	docker-compose up -d neo4j-test
	@echo "Docker services started"

# Stop Docker services
docker-down:
	@echo "Stopping Docker services..."
	docker-compose down
	@echo "Docker services stopped"

# Run CI checks locally
ci-check: install generate format
	@echo "Running CI checks locally..."
	@echo "Checking Go modules consistency..."
	go mod tidy
	@if [ -n "$$(git diff go.mod go.sum)" ]; then \
		echo "go.mod or go.sum are not up to date"; \
		git diff go.mod go.sum; \
		exit 1; \
	fi
	@echo "Checking code formatting..."
	@if [ -n "$$(gofmt -s -l .)" ]; then \
		echo "Code is not formatted properly:"; \
		gofmt -s -d .; \
		exit 1; \
	fi
	@echo "Running go vet..."
	go vet ./...
	@echo "Building..."
	go build -v ./...
	@echo "Running tests..."
	$(MAKE) test
	@echo "All CI checks passed"

# Development workflow
dev: install generate format test
	@echo "Development environment ready"

# Quick rebuild and test
quick: generate format test
	@echo "Quick rebuild completed"
