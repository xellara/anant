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
    # macOS requires an empty string for extension with -i
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/^  serverpod_test:/  # serverpod_test:/' pubspec.yaml
    else
        sed -i 's/^  serverpod_test:/  # serverpod_test:/' pubspec.yaml
    fi
    echo "   ✓ Commented out dev dependencies"
fi

echo ""

# --- MIGRATIONS SECTION ---
echo ""
echo "🛠️  Database Migrations (PRODUCTION)"
read -p "Do you want to APPLY migrations to the PRODUCTION database? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "⚠️  Applying migrations to PRODUCTION..."
    
    # Check for password
    # Check for password
    if [ -z "$SERVERPOD_PASSWORD_database" ]; then
        # Try to auto-read from config/passwords.yaml
        if [ -f config/passwords.yaml ]; then
            echo "🔑 Reading password from config/passwords.yaml..."
            # Extract nested password: Look for 'production:', then find the next 'database:' line
            AUTO_PASSWORD=$(awk '/production:/{flag=1; next} /database:/{if(flag){print $2; exit}}' config/passwords.yaml | tr -d '"')
            
            # Fallback for old flat format if nested extraction failed
            if [ -z "$AUTO_PASSWORD" ]; then
                 AUTO_PASSWORD=$(grep "production:" config/passwords.yaml | awk '{print $2}' | tr -d '"')
            fi

            if [ ! -z "$AUTO_PASSWORD" ]; then
                SERVERPOD_PASSWORD_database="$AUTO_PASSWORD"
                export SERVERPOD_PASSWORD_database
                echo "   ✓ Password loaded automatically"
            fi
        else
            echo "⚠️  config/passwords.yaml not found (likely gitignored). Automatic password loading skipped."
        fi
    fi

    if [ -z "$SERVERPOD_PASSWORD_database" ]; then
        echo "🔒 Database password required for migration."
        read -s -p "Enter Production Database Password: " SERVERPOD_PASSWORD_database
        echo ""
        export SERVERPOD_PASSWORD_database
    fi

    # Runs the maintenance command locally securely connecting to the remote DB
    dart run bin/main.dart --apply-migrations --mode $RUNMODE --role maintenance
fi
echo ""
# --------------------------

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
  --set-env-vars="runmode=$RUNMODE,role=monolith,SERVERPOD_DATABASE_HOST=ep-nameless-flower-ahysl36o-pooler.c-3.us-east-1.aws.neon.tech,SERVERPOD_DATABASE_PORT=5432,SERVERPOD_DATABASE_NAME=neondb,SERVERPOD_DATABASE_USER=neondb_owner" \
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
