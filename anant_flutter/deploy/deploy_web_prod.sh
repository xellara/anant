#!/bin/bash

# Anant Flutter Web - Cloud Run Deployment for PRODUCTION
# Deploys to the Prod Project

set -e

# Configuration
PROJECT_ID="anant-prod"
REGION="us-central1"
SERVICE_NAME="anant-web"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Deploying Anant Web (PROD) to Cloud Run"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Set Project
echo "📦 Setting project to $PROJECT_ID..."
gcloud config set project "$PROJECT_ID" || { echo "❌ Failed to set project. Make sure you have access."; exit 1; }

# Check directory
if [ ! -f pubspec.yaml ]; then
    echo "Run this script from the root of your flutter directory (anant_flutter)."
    echo "Current directory: $(pwd)"
    exit 1
fi

echo ""

# Build Docker Image
echo "🔨 Building Docker Image..."
IMAGE_NAME="gcr.io/$PROJECT_ID/$SERVICE_NAME"
# Use --platform linux/amd64 to ensure compatibility
docker build --platform linux/amd64 -t $IMAGE_NAME .

echo ""
echo "Pw Pushing Docker Image..."
docker push $IMAGE_NAME

echo ""

# Deploy
echo "🌐 Deploying Web Server..."
echo ""

gcloud run deploy $SERVICE_NAME \
  --image $IMAGE_NAME \
  --region=$REGION \
  --project=$PROJECT_ID \
  --platform=managed \
  --port=80 \
  --allow-unauthenticated

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Deployment failed!"
    exit 1
fi

# Get service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME \
    --region=$REGION \
    --project=$PROJECT_ID \
    --format="value(status.url)")

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Web Deployment Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Website URL: $SERVICE_URL"
echo ""
