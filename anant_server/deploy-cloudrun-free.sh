#!/bin/bash

# Anant Server - FREE Cloud Run Deployment Script
# This script deploys to Cloud Run using external FREE database (Neon/Supabase)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Anant Server - FREE Cloud Run Deployment${NC}"
echo -e "${BLUE}Using external free database (Neon/Supabase)${NC}"
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ Google Cloud SDK (gcloud) is not installed${NC}"
    echo ""
    echo "To install on macOS, run:"
    echo "  brew install google-cloud-sdk"
    echo ""
    echo "Then authenticate:"
    echo "  gcloud auth login"
    exit 1
fi

echo -e "${GREEN}✓ Google Cloud SDK found${NC}"

# Configuration
PROJECT_ID="${1:-anant-prod}"
REGION="${2:-us-central1}"
SERVICE_NAME="anant-server"

# Database configuration (from Neon/Supabase)
if [ -z "$DB_HOST" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Database connection not set${NC}"
    echo ""
    echo "Please set environment variables for your FREE database:"
    echo ""
    echo "Option 1: Neon (Recommended - neon.tech)"
    echo "  1. Sign up at https://neon.tech (free)"
    echo "  2. Create a new project"
    echo "  3. Copy the connection details"
    echo ""
    echo "Option 2: Supabase (supabase.com)"
    echo "  1. Sign up at https://supabase.com (free)"
    echo "  2. Create a new project"
    echo "  3. Get database connection string"
    echo ""
    echo "Then export these variables:"
    echo "  export DB_HOST=your-db.region.provider.com"
    echo "  export DB_PORT=5432"
    echo "  export DB_NAME=your-database"
    echo "  export DB_USER=your-user"
    echo "  export DB_PASSWORD=your-password"
    echo ""
    echo "And run this script again."
    exit 1
fi

echo ""
echo "Configuration:"
echo "  Project ID: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Service Name: $SERVICE_NAME"
echo "  Database Host: $DB_HOST"
echo ""

# Set project
echo -e "${YELLOW}Setting active project...${NC}"
gcloud config set project "$PROJECT_ID"

# Check if project exists
if ! gcloud projects describe "$PROJECT_ID" &> /dev/null; then
    echo -e "${RED}❌ Project '$PROJECT_ID' not found${NC}"
    echo ""
    echo "Create it with:"
    echo "  gcloud projects create $PROJECT_ID --name='Anant School Management'"
    exit 1
fi

echo -e "${GREEN}✓ Project found${NC}"

# Enable required APIs
echo ""
echo -e "${YELLOW}Enabling required APIs...${NC}"
gcloud services enable run.googleapis.com \
    cloudbuild.googleapis.com \
    secretmanager.googleapis.com

echo -e "${GREEN}✓ APIs enabled${NC}"

# Store database password in Secret Manager
echo ""
echo -e "${YELLOW}Storing database password in Secret Manager...${NC}"

# Check if secret exists
if gcloud secrets describe db-password --project="$PROJECT_ID" &> /dev/null; then
    echo -e "${YELLOW}Secret already exists, updating...${NC}"
    echo -n "$DB_PASSWORD" | gcloud secrets versions add db-password --data-file=-
else
    echo -n "$DB_PASSWORD" | gcloud secrets create db-password \
        --data-file=- \
        --replication-policy="automatic"
fi

echo -e "${GREEN}✓ Database password secured${NC}"

# Deploy to Cloud Run
echo ""
echo -e "${YELLOW}Deploying to Cloud Run (100% FREE)...${NC}"
echo ""

gcloud run deploy "$SERVICE_NAME" \
    --source . \
    --region "$REGION" \
    --platform managed \
    --allow-unauthenticated \
    --min-instances 0 \
    --max-instances 10 \
    --memory 512Mi \
    --cpu 1 \
    --timeout 300 \
    --concurrency 80 \
    --cpu-throttling \
    --set-env-vars "DB_HOST=$DB_HOST,DB_PORT=${DB_PORT:-5432},DB_NAME=$DB_NAME,DB_USER=$DB_USER" \
    --set-secrets "DB_PASSWORD=db-password:latest"

# Get service URL
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" \
    --region="$REGION" \
    --format="value(status.url)")

# Update environment variables with actual service URL
echo ""
echo -e "${YELLOW}Updating service environment variables...${NC}"
gcloud run services update "$SERVICE_NAME" \
    --region "$REGION" \
    --set-env-vars "API_HOST=${SERVICE_URL#https://},INSIGHTS_HOST=${SERVICE_URL#https://},WEB_HOST=${SERVICE_URL#https://},DB_HOST=$DB_HOST,DB_PORT=${DB_PORT:-5432},DB_NAME=$DB_NAME,DB_USER=$DB_USER"

echo ""
echo -e "${GREEN}✅ Deployment complete - 100% FREE!${NC}"
echo ""
echo "Service URL: $SERVICE_URL"
echo ""
echo -e "${BLUE}💰 Cost Breakdown:${NC}"
echo "  • Cloud Run: FREE (within 2M requests/month)"
echo "  • Database (Neon/Supabase): FREE"
echo "  • Total: $0/month 🎉"
echo ""
echo "Next steps:"
echo "  1. Test the API: curl $SERVICE_URL"
echo "  2. Run migrations (see CLOUDRUN_DEPLOYMENT_FREE.md)"
echo "  3. Update your Flutter app with: $SERVICE_URL"
echo "  4. Check logs: gcloud run services logs read $SERVICE_NAME --region=$REGION"
echo ""
