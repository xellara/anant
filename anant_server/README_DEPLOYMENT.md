# One-Command Cloud Run Deployment

Deploy your Anant server to Cloud Run with a single script!

## Quick Start

### 1. Upload to Cloud Shell

In Google Cloud Shell:

```bash
cd ~/anant/anant_server
git pull  # Get latest changes
```

### 2. Make Sure Secret Exists

**First time only:**

```bash
echo -n "npg_FHpno9hUOg6d" | gcloud secrets create db-password --data-file=- --replication-policy="automatic"
```

### 3. Run the Deployment Script

```bash
./deploy-to-cloudrun.sh
```

That's it! The script will:
- ✅ Prepare files (comment out dev dependencies)
- ✅ Use buildpacks instead of Dockerfile
- ✅ Deploy to Cloud Run with free tier configuration
- ✅ Configure environment variables
- ✅ Give you the service URL

## 💰 Cost: $0/month

- **Cloud Run**: FREE (2M requests/month)
- **Neon Database**: FREE (0.5GB)

## Custom Configuration

```bash
# Deploy to different project or region
./deploy-to-cloudrun.sh my-project us-east1
```

## After Deployment

### Run Migrations

On your **local machine**:

```bash
cd /Users/amit/Me/Projects/anant/anant_server

# Temporarily update config/development.yaml with Neon credentials
# Then run:
dart bin/main.dart --apply-migrations
```

### Update Flutter App

```dart
final client = Client(
  'https://YOUR-SERVICE-URL',  // From script output
  authenticationKeyManager: FlutterAuthenticationKeyManager(),
);
```

### Test API

```bash
# Get service URL
SERVICE_URL=$(gcloud run services describe anant-server --region=us-central1 --format="value(status.url)")

# Test
curl $SERVICE_URL

# Check logs
gcloud run services logs read anant-server --region=us-central1
```

## Troubleshooting

### Build Failed

Check logs:
```bash
gcloud builds list --limit=5 --region=us-central1
gcloud builds log BUILD_ID --region=us-central1
```

### Database Connection Error

Verify secret:
```bash
gcloud secrets versions access latest --secret=db-password
```

### Service Not Starting

View logs:
```bash
gcloud run services logs read anant-server --region=us-central1 --limit=100
```

## Manual Deployment

If the script doesn't work, run commands manually:

```bash
# Prepare files
sed -i 's/^  serverpod_test:/  # serverpod_test:/' pubspec.yaml
mv Dockerfile Dockerfile.backup

# Deploy
gcloud run deploy anant-server \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 10 \
  --memory 1Gi \
  --cpu 1 \
  --timeout 600 \
  --set-env-vars "DB_HOST=ep-nameless-flower-ahysl36o-pooler.c-3.us-east-1.aws.neon.tech,DB_PORT=5432,DB_NAME=neondb,DB_USER=neondb_owner" \
  --set-secrets "DB_PASSWORD=db-password:latest"
```
