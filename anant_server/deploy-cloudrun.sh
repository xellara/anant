#!/bin/bash

# Anant Server - Cloud Run Deployment Script
# This script helps deploy the Serverpod server to Google Cloud Run

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Anant Server - Cloud Run Deployment${NC}"
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
    echo "  gcloud auth application-default login"
    exit 1
fi

echo -e "${GREEN}✓ Google Cloud SDK found${NC}"

# Configuration
PROJECT_ID="${1:-anant-prod}"
REGION="${2:-us-central1}"
SERVICE_NAME="anant-server"
DB_INSTANCE_NAME="anant-db"

echo ""
echo "Configuration:"
echo "  Project ID: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Service Name: $SERVICE_NAME"
echo "  Database Instance: $DB_INSTANCE_NAME"
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
    sqladmin.googleapis.com \
    secretmanager.googleapis.com

echo -e "${GREEN}✓ APIs enabled${NC}"

# Check if Cloud SQL instance exists
echo ""
echo -e "${YELLOW}Checking Cloud SQL instance...${NC}"
if ! gcloud sql instances describe "$DB_INSTANCE_NAME" --project="$PROJECT_ID" &> /dev/null; then
    echo -e "${YELLOW}⚠️  Cloud SQL instance not found. Creating...${NC}"
    echo ""
    read -p "Enter a strong database password: " -s DB_PASSWORD
    echo ""
    
    gcloud sql instances create "$DB_INSTANCE_NAME" \
        --database-version=POSTGRES_16 \
        --tier=db-f1-micro \
        --region="$REGION" \
        --root-password="$DB_PASSWORD" \
        --storage-type=HDD \
        --storage-size=10GB \
        --backup-start-time=03:00
    
    echo -e "${GREEN}✓ Cloud SQL instance created${NC}"
    
    # Create database
    echo -e "${YELLOW}Creating database...${NC}"
    gcloud sql databases create anant --instance="$DB_INSTANCE_NAME"
    echo -e "${GREEN}✓ Database created${NC}"
    
    # Store password in Secret Manager
    echo -e "${YELLOW}Storing password in Secret Manager...${NC}"
    echo -n "$DB_PASSWORD" | gcloud secrets create db-password \
        --data-file=- \
        --replication-policy="automatic"
    echo -e "${GREEN}✓ Secret created${NC}"
else
    echo -e "${GREEN}✓ Cloud SQL instance exists${NC}"
fi

# Get Cloud SQL connection name
CONNECTION_NAME=$(gcloud sql instances describe "$DB_INSTANCE_NAME" \
    --format="value(connectionName)")

echo ""
echo -e "${GREEN}Cloud SQL Connection: $CONNECTION_NAME${NC}"

# Deploy to Cloud Run
echo ""
echo -e "${YELLOW}Deploying to Cloud Run...${NC}"
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
    --set-env-vars "DB_HOST=/cloudsql/$CONNECTION_NAME" \
    --set-secrets "DB_PASSWORD=db-password:latest" \
    --add-cloudsql-instances "$CONNECTION_NAME"

# Get service URL
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" \
    --region="$REGION" \
    --format="value(status.url)")

# Update environment variables with actual service URL
echo ""
echo -e "${YELLOW}Updating service environment variables...${NC}"
gcloud run services update "$SERVICE_NAME" \
    --region "$REGION" \
    --set-env-vars "API_HOST=${SERVICE_URL#https://},INSIGHTS_HOST=${SERVICE_URL#https://},WEB_HOST=${SERVICE_URL#https://}"

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "Service URL: $SERVICE_URL"
echo ""
echo "Next steps:"
echo "  1. Run database migrations (see README)"
echo "  2. Test the API: curl $SERVICE_URL"
echo "  3. Update your Flutter app with the service URL"
echo "  4. Check logs: gcloud run services logs read $SERVICE_NAME --region=$REGION"
echo ""
