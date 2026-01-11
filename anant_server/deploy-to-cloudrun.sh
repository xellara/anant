#!/bin/bash

# Anant Server - Cloud Run Deployment (Adapted from Serverpod official script)
# Uses Neon Database instead of Cloud SQL for FREE deployment

set -e

# Configuration
PROJECT_ID="anant-prod"
REGION="us-central1"
RUNMODE="production"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Deploying Anant Server to Cloud Run"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Set Project
echo "📦 Setting project to $PROJECT_ID..."
gcloud config set project "$PROJECT_ID"

# Neon Database (no need for Cloud SQL!)
echo "Using Neon PostgreSQL Database (FREE tier)"

# Check that we are running the script from the correct directory
if [ ! -f config/production.yaml ]; then
    echo "Run this script from the root of your server directory."
    echo "Current directory: $(pwd)"
    echo "Expected file: config/production.yaml"
    exit 1
fi

echo ""

# Comment out serverpod_test for deployment
if grep -q "^  serverpod_test:" pubspec.yaml; then
    echo "📝 Preparing pubspec.yaml..."
    sed -i 's/^  serverpod_test:/  # serverpod_test:/' pubspec.yaml
    echo "   ✓ Commented out dev dependencies"
fi

echo ""

# Deploy the API server (monolith mode)
echo "🌐 Deploying API server..."
echo ""

gcloud run deploy anant-server \
  --source=. \
  --region=$REGION \
  --project=$PROJECT_ID \
  --platform=managed \
  --port=8080 \
  --execution-environment=gen2 \
  --allow-unauthenticated \
  --min-instances=0 \
  --max-instances=10 \
  --memory=512Mi \
  --cpu=1 \
  --timeout=300 \
  --set-env-vars="runmode=$RUNMODE,role=monolith,DB_HOST=ep-nameless-flower-ahysl36o-pooler.c-3.us-east-1.aws.neon.tech,DB_NAME=neondb,DB_USER=neondb_owner" \
  --set-secrets="SERVERPOD_PASSWORD_database=db-password:latest"

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Deployment failed!"
    exit 1
fi

# Get service URL
SERVICE_URL=$(gcloud run services describe anant-server \
    --region=$REGION \
    --project=$PROJECT_ID \
    --format="value(status.url)")

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Deployment Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Service URL: $SERVICE_URL"  
echo ""
echo "💰 Monthly Cost: \$0 (FREE tier)"
echo "   • Cloud Run: FREE"
echo "   • Neon Database: FREE"
echo ""
echo "📋 Next Steps:"
echo "   1. Run migrations on your local machine"
echo "   2. Update Flutter app with: $SERVICE_URL"
echo "   3. Test API: curl $SERVICE_URL"
echo ""
