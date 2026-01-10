# Cloud Run Deployment Guide

This guide covers deploying the Anant Serverpod server to Google Cloud Run.

## Prerequisites

1. **Google Cloud Account** with billing enabled
2. **Google Cloud SDK** installed ([Install Guide](https://cloud.google.com/sdk/docs/install))
3. **Authenticated** with Google Cloud

## Quick Start

### 1. Install Google Cloud SDK (if not installed)

**macOS:**
```bash
brew install google-cloud-sdk
```

**Other platforms:** See [official installation guide](https://cloud.google.com/sdk/docs/install)

### 2. Authenticate

```bash
gcloud auth login
gcloud auth application-default login
```

### 3. Create Google Cloud Project

```bash
# Create project
gcloud projects create anant-prod --name="Anant School Management"

# Set as active project
gcloud config set project anant-prod

# Link billing account (required)
gcloud alpha billing projects link anant-prod --billing-account=BILLING_ACCOUNT_ID
```

To find your billing account ID:
```bash
gcloud alpha billing accounts list
```

### 4. Deploy Using Automated Script

```bash
cd /Users/amit/Me/Projects/anant/anant_server
./deploy-cloudrun.sh anant-prod us-central1
```

The script will:
- ✅ Enable required Google Cloud APIs
- ✅ Create Cloud SQL PostgreSQL instance
- ✅ Create database and store password securely
- ✅ Deploy server to Cloud Run
- ✅ Configure environment variables
- ✅ Set up Cloud SQL connection

### 5. Run Database Migrations

After deployment, run migrations using Cloud SQL Proxy:

```bash
# Install Cloud SQL Proxy
curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.0/cloud-sql-proxy.darwin.amd64
chmod +x cloud-sql-proxy

# Get connection name
CONNECTION_NAME=$(gcloud sql instances describe anant-db --format="value(connectionName)")

# Start proxy in background
./cloud-sql-proxy $CONNECTION_NAME &

# Update config/development.yaml temporarily to point to localhost:5432
# Then run migrations
dart bin/main.dart --apply-migrations

# Stop proxy
killall cloud-sql-proxy
```

### 6. Verify Deployment

```bash
# Get service URL
SERVICE_URL=$(gcloud run services describe anant-server --region=us-central1 --format="value(status.url)")

# Test endpoint
curl $SERVICE_URL

# Check logs
gcloud run services logs read anant-server --region=us-central1 --limit=50
```

## Manual Deployment (Step-by-Step)

If you prefer manual control:

### 1. Enable APIs

```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

### 2. Create Cloud SQL Instance

```bash
gcloud sql instances create anant-db \
  --database-version=POSTGRES_16 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --root-password=YOUR_STRONG_PASSWORD \
  --storage-type=HDD \
  --storage-size=10GB

# Create database
gcloud sql databases create anant --instance=anant-db

# Get connection name
gcloud sql instances describe anant-db --format="value(connectionName)"
```

### 3. Store Database Password

```bash
echo -n "YOUR_DB_PASSWORD" | gcloud secrets create db-password \
  --data-file=- \
  --replication-policy="automatic"
```

### 4. Deploy to Cloud Run

```bash
# Replace PROJECT:REGION:INSTANCE with your Cloud SQL connection name
gcloud run deploy anant-server \
  --source . \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 10 \
  --memory 512Mi \
  --cpu 1 \
  --timeout 300 \
  --concurrency 80 \
  --cpu-throttling \
  --set-env-vars "DB_HOST=/cloudsql/PROJECT:REGION:INSTANCE" \
  --set-secrets "DB_PASSWORD=db-password:latest" \
  --add-cloudsql-instances PROJECT:REGION:INSTANCE
```

### 5. Update Environment Variables

```bash
# Get service URL
SERVICE_URL=$(gcloud run services describe anant-server --region=us-central1 --format="value(status.url)")

# Update with actual URL
gcloud run services update anant-server \
  --region us-central1 \
  --set-env-vars "API_HOST=${SERVICE_URL#https://},INSIGHTS_HOST=${SERVICE_URL#https://},WEB_HOST=${SERVICE_URL#https://}"
```

## Cost Optimization

Current configuration is optimized for minimal costs:

- **Cloud Run**: Free tier covers ~2M requests/month
- **Cloud SQL**: db-f1-micro = ~$10-15/month
- **Total estimated cost**: $10-15/month for low traffic

To further reduce costs:
- Use Cloud SQL scheduled backups instead of continuous
- Consider Cloud Run scheduled scaling
- Monitor usage in Cloud Console

## Updating Your Flutter App

After deployment, update your Flutter app's server endpoint:

```dart
// lib/main.dart or your client configuration
final client = Client(
  'https://YOUR-SERVICE-URL',
  authenticationKeyManager: FlutterAuthenticationKeyManager(),
);
```

## Troubleshooting

### Check Logs
```bash
gcloud run services logs read anant-server --region=us-central1 --limit=100
```

### Database Connection Issues
- Verify Cloud SQL instance is running
- Check Secret Manager has db-password
- Ensure Cloud Run has Cloud SQL connection configured

### Build Failures
```bash
# View build logs
gcloud builds list
gcloud builds log BUILD_ID
```

## Additional Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud SQL Documentation](https://cloud.google.com/sql/docs)
- [Serverpod Deployment Guide](https://docs.serverpod.dev/)
