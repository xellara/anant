#!/bin/bash

# Anant Server - Cloud Run Deployment for DEVELOPMENT
# Deploys to the Dev Project

set -e

# Configuration
PROJECT_ID="anant-dev-484011"
REGION="us-central1"
RUNMODE="staging"
SERVICE_NAME="anant-server-dev"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Deploying Anant Server (DEV) to Cloud Run"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Set Project
echo "📦 Setting project to $PROJECT_ID..."
gcloud config set project "$PROJECT_ID" || { echo "❌ Failed to set project. Make sure you have access."; exit 1; }

# Check directory
if [ ! -f config/staging.yaml ]; then
    echo "Run this script from the root of your server directory (anant_server)."
    echo "Current directory: $(pwd)"
    exit 1
fi

echo ""

# --- MIGRATIONS SECTION ---
echo ""
echo "🛠️  Database Migrations"
read -p "Do you want to CREATE a new migration? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Creating migration..."
    # Note: ensure serverpod cli is installed or use dart run
    serverpod create-migration
fi

read -p "Do you want to APPLY migrations to the REMOTE database? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Applying migrations to REMOTE (Staging)..."
    
    # Export Dev Password (matches the one in the gcloud deploy command below)
    # SERVERPOD_PASSWORD_database="npg_uCLeB71wwPtr" # HARDCODED REMOVED
    
    # Auto-read from config/passwords.yaml
    if [ -f config/passwords.yaml ]; then
        echo "🔑 Reading password from config/passwords.yaml..."
        # Extract staging password
        AUTO_PASSWORD=$(grep "staging:" config/passwords.yaml | awk '{print $2}' | tr -d '"')
        if [ ! -z "$AUTO_PASSWORD" ]; then
            SERVERPOD_PASSWORD_database="$AUTO_PASSWORD"
            echo "   ✓ Password loaded automatically"
        fi
    else
        echo "⚠️  config/passwords.yaml not found (likely gitignored). Automatic password loading skipped."
    fi
    
    if [ -z "$SERVERPOD_PASSWORD_database" ]; then
        echo "❌ Error: Could not load staging password from config/passwords.yaml"
        exit 1
    fi

    export SERVERPOD_PASSWORD_database
    
    # Runs the maintenance command locally securely connecting to the remote DB
    dart run bin/main.dart --apply-migrations --mode $RUNMODE --role maintenance
fi
echo ""
# --------------------------

# Deploy
echo "🌐 Deploying API server..."
echo ""

gcloud run deploy $SERVICE_NAME \
  --source=. \
  --region=$REGION \
  --project=$PROJECT_ID \
  --platform=managed \
  --port=8080 \
  --allow-unauthenticated \
  --set-env-vars="runmode=$RUNMODE,role=monolith,SERVERPOD_DATABASE_HOST=ep-ancient-bird-ahe553x9-pooler.c-3.us-east-1.aws.neon.tech,SERVERPOD_DATABASE_PORT=5432,SERVERPOD_DATABASE_NAME=neondb,SERVERPOD_DATABASE_USER=neondb_owner,SERVERPOD_PASSWORD_database=$SERVERPOD_PASSWORD_database"
# Note: Password is set via env var for "One Click" convenience. For higher security, use GCP Secrets.

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
echo "✅ DEV Deployment Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Service URL: $SERVICE_URL"
echo ""
echo "📋 Next Steps:"
echo "   1. Update 'anant_flutter/lib/main_dev.dart' with: $SERVICE_URL"
