#!/bin/bash

# Test script to simulate Cloud Run environment locally

echo "🚀 Building Docker image..."
docker build -t test-build .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed"
    exit 1
fi

echo "✅ Build successful"
echo ""

# Run the container locally to test startup
# Mimic Cloud Run environment variables
echo "🚀 Starting container..."
docker run --rm -p 8080:8080 \
  -e runmode=production \
  -e role=monolith \
  -e PORT=8080 \
  -e SERVERPOD_DATABASE_HOST=ep-nameless-flower-ahysl36o-pooler.c-3.us-east-1.aws.neon.tech \
  -e SERVERPOD_DATABASE_PORT=5432 \
  -e SERVERPOD_DATABASE_NAME=neondb \
  -e SERVERPOD_DATABASE_USER=neondb_owner \
  -e SERVERPOD_PASSWORD_database="npg_FHpno9hUOg6d" \
  test-build
