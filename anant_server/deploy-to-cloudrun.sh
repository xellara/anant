#!/bin/bash

# Anant Server - Automated Cloud Run Deployment Script
# Run this in Google Cloud Shell

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Anant Server - Automated Cloud Run Deployment${NC}"
echo -e "${BLUE}100% FREE with Neon Database + Cloud Run${NC}"
echo ""

# Configuration
PROJECT_ID="${1:-anant-prod}"
REGION="${2:-us-central1}"
SERVICE_NAME="anant-server"

# Neon Database Credentials
DB_HOST="ep-nameless-flower-ahysl36o-pooler.c-3.us-east-1.aws.neon.tech"
DB_PORT="5432"
DB_NAME="neondb"
DB_USER="neondb_owner"

echo "Configuration:"
echo "  Project ID: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Service Name: $SERVICE_NAME"
echo "  Database: Neon (FREE)"
echo ""

# Step 1: Prepare files
echo -e "${YELLOW}📝 Step 1: Preparing files...${NC}"

# Comment out serverpod_test for deployment
if grep -q "^  serverpod_test:" pubspec.yaml; then
    sed -i 's/^  serverpod_test:/  # serverpod_test:/' pubspec.yaml
    echo "  ✓ Commented out serverpod_test"
fi

# Move Dockerfile to use buildpacks
if [ -f "Dockerfile" ]; then
    mv Dockerfile Dockerfile.backup
    echo "  ✓ Using buildpacks instead of Dockerfile"
fi

echo ""

# Step 2: Set project
echo -e "${YELLOW}📦 Step 2: Setting active project...${NC}"
gcloud config set project "$PROJECT_ID"
echo ""

# Step 3: Check if secret exists
echo -e "${YELLOW}🔐 Step 3: Checking database password secret...${NC}"
if ! gcloud secrets describe db-password --project="$PROJECT_ID" &> /dev/null; then
    echo -e "${RED}  ✗ Secret 'db-password' not found${NC}"
    echo ""
    echo "Please create the secret first with:"
    echo "  echo -n 'npg_FHpno9hUOg6d' | gcloud secrets create db-password --data-file=- --replication-policy='automatic'"
    exit 1
fi
echo "  ✓ Secret exists"
echo ""

# Step 4: Deploy to Cloud Run
echo -e "${YELLOW}🚀 Step 4: Deploying to Cloud Run...${NC}"
echo "  This may take 5-10 minutes..."
echo ""

gcloud run deploy "$SERVICE_NAME" \
  --source . \
  --region "$REGION" \
  --platform managed \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 10 \
  --memory 1Gi \
  --cpu 1 \
  --timeout 600 \
  --concurrency 80 \
  --cpu-throttling \
  --set-env-vars "DB_HOST=$DB_HOST,DB_PORT=$DB_PORT,DB_NAME=$DB_NAME,DB_USER=$DB_USER" \
  --set-secrets "DB_PASSWORD=db-password:latest"

if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}❌ Deployment failed!${NC}"
    echo "Check the logs above for errors"
    
    # Restore Dockerfile
    if [ -f "Dockerfile.backup" ]; then
        mv Dockerfile.backup Dockerfile
    fi
    exit 1
fi

# Step 5: Get service URL
echo ""
echo -e "${YELLOW}🌐 Step 5: Getting service URL...${NC}"
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" \
    --region="$REGION" \
    --format="value(status.url)")

# Step 6: Update environment variables with actual URL
echo -e "${YELLOW}⚙️  Step 6: Updating service environment...${NC}"
gcloud run services update "$SERVICE_NAME" \
    --region "$REGION" \
    --set-env-vars "API_HOST=${SERVICE_URL#https://},INSIGHTS_HOST=${SERVICE_URL#https://},WEB_HOST=${SERVICE_URL#https://},DB_HOST=$DB_HOST,DB_PORT=$DB_PORT,DB_NAME=$DB_NAME,DB_USER=$DB_USER"

echo ""
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}Service URL:${NC} ${BLUE}$SERVICE_URL${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BLUE}💰 Cost Summary:${NC}"
echo "  • Cloud Run: FREE (within 2M requests/month)"
echo "  • Neon Database: FREE (0.5GB storage)"
echo "  • Total: $0/month 🎉"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo ""
echo "1. Run Database Migrations (on your local machine):"
echo "   cd /Users/amit/Me/Projects/anant/anant_server"
echo "   # Update config/development.yaml with Neon credentials, then:"
echo "   dart bin/main.dart --apply-migrations"
echo ""
echo "2. Test API:"
echo "   curl $SERVICE_URL"
echo ""
echo "3. Update Flutter App:"
echo "   # In your client configuration:"
echo "   final client = Client("
echo "     '$SERVICE_URL',"
echo "     authenticationKeyManager: FlutterAuthenticationKeyManager(),"
echo "   );"
echo ""
echo "4. Check Logs:"
echo "   gcloud run services logs read $SERVICE_NAME --region=$REGION --limit=50"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
