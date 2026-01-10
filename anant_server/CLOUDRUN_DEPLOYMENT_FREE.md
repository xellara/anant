# 100% FREE Cloud Run Deployment Guide

Deploy Anant Serverpod server to Google Cloud Run with **ZERO monthly costs** using free database providers.

## 💰 Cost Breakdown

- **Cloud Run**: FREE (2M requests/month free tier)
- **Database**: FREE (using Neon/Supabase)
- **Total**: **$0/month** 🎉

---

## Prerequisites

1. **Google Cloud Account** (free tier, no credit card required initially)
2. **Free Database Account** - Choose one:
   - [Neon](https://neon.tech) (Recommended)
   - [Supabase](https://supabase.com)
   - [Railway](https://railway.app)

---

## Step 1: Create Free Database

### Option A: Neon (Recommended) ⭐

1. Go to [neon.tech](https://neon.tech)
2. Sign up (free, no credit card)
3. Click **"Create Project"**
4. Choose **PostgreSQL 16**
5. Select region closest to `us-central1`
6. Copy connection details:
   - Host: `ep-xxx-xxx.us-east-2.aws.neon.tech`
   - Database: `neondb`
   - User: `neondb_owner`
   - Password: `xxx`
   - Port: `5432`

**Features:**
- ✅ 0.5GB storage
- ✅ Auto-pause when inactive
- ✅ Unlimited projects
- ✅ PostgreSQL 16

### Option B: Supabase

1. Go to [supabase.com](https://supabase.com)
2. Sign up (free)
3. Create new project
4. Get **Direct Connection** string from Settings → Database
5. Parse connection details

**Features:**
- ✅ 500MB storage
- ✅ Includes auth & storage
- ✅ PostgreSQL 15

---

## Step 2: Install Google Cloud SDK

**macOS:**
```bash
brew install google-cloud-sdk
```

**Authenticate:**
```bash
gcloud auth login
gcloud auth application-default login
```

---

## Step 3: Create Google Cloud Project

```bash
# Create project
gcloud projects create anant-prod --name="Anant School Management"

# Set as active
gcloud config set project anant-prod
```

**Note:** Billing is NOT required for Cloud Run free tier!

---

## Step 4: Deploy Using Free Script

### Set Database Environment Variables

```bash
# For Neon database
export DB_HOST="ep-xxx-xxx.us-east-2.aws.neon.tech"
export DB_PORT="5432"
export DB_NAME="neondb"
export DB_USER="neondb_owner"
export DB_PASSWORD="your-password"

# For Supabase database
export DB_HOST="db.xxx.supabase.co"
export DB_PORT="5432"
export DB_NAME="postgres"
export DB_USER="postgres"
export DB_PASSWORD="your-password"
```

### Run Deployment

```bash
cd /Users/amit/Me/Projects/anant/anant_server
./deploy-cloudrun-free.sh anant-prod us-central1
```

The script will:
- ✅ Enable required Google Cloud APIs (free)
- ✅ Store database password securely in Secret Manager (free)
- ✅ Deploy server to Cloud Run (free)
- ✅ Configure environment variables
- ✅ Return your service URL

---

## Step 5: Run Database Migrations

After deployment, run migrations on your free database:

```bash
# Temporarily update config/development.yaml with your database details
# Then run migrations locally
dart bin/main.dart --apply-migrations
```

Or create a one-time Cloud Run job to run migrations (also free).

---

## Step 6: Seed Initial Data

```bash
# Run seed script
dart bin/seed_data.dart
```

---

## Step 7: Update Flutter App

Update your Flutter app with the Cloud Run URL:

```dart
// In your client configuration
final client = Client(
  'https://anant-server-xxxxx-uc.a.run.app',
  authenticationKeyManager: FlutterAuthenticationKeyManager(),
);
```

---

## Verification

### Test API
```bash
SERVICE_URL=$(gcloud run services describe anant-server --region=us-central1 --format="value(status.url)")
curl $SERVICE_URL
```

### Check Logs
```bash
gcloud run services logs read anant-server --region=us-central1 --limit=50
```

### Monitor Usage
```bash
# View Cloud Run metrics
gcloud run services describe anant-server --region=us-central1
```

---

## Free Tier Limits

### Cloud Run (Google Cloud)
- **2 million requests/month**
- **360,000 GB-seconds memory**
- **180,000 vCPU-seconds**
- **1GB outbound data transfer**

### Neon Database
- **0.5GB storage**
- **Unlimited queries**
- **Auto-pause after inactivity**

### Supabase Database
- **500MB storage**
- **50,000 monthly active users**
- **2GB bandwidth**

---

## Cost Monitoring

Even though everything is free, monitor usage:

```bash
# Check Cloud Run usage
gcloud run services describe anant-server --region=us-central1 --format="yaml(spec.template.spec.containers[0].resources)"

# View billing (should show $0)
gcloud beta billing projects describe anant-prod
```

---

## Scaling Beyond Free Tier

If you exceed free tier limits:

1. **Cloud Run**: Pay only for usage above free tier (~$0.00002400/request)
2. **Database**: 
   - Neon: $19/month for 10GB
   - Supabase: $25/month for Pro plan

But for a school management system, you'll likely stay in free tier! 🎉

---

## Troubleshooting

### Database Connection Errors

Check SSL requirements:
```yaml
# In production.yaml
database:
  requireSsl: true  # Neon/Supabase require SSL
```

### Cloud Run Build Errors

View build logs:
```bash
gcloud builds list
gcloud builds log BUILD_ID
```

### Secret Manager Issues

Verify secret exists:
```bash
gcloud secrets versions access latest --secret=db-password
```

---

## Alternative: One-Command Deployment

```bash
# All in one command
DB_HOST="your-db-host" \
DB_NAME="your-db-name" \
DB_USER="your-db-user" \
DB_PASSWORD="your-db-password" \
./deploy-cloudrun-free.sh anant-prod us-central1
```

---

## Next Steps After Deployment

1. ✅ Test all API endpoints
2. ✅ Run migrations and seed data
3. ✅ Update Flutter app with production URL
4. ✅ Set up monitoring/alerting (optional)
5. ✅ Configure custom domain (optional, requires DNS)

---

## Resources

- [Neon Documentation](https://neon.tech/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Cloud Run Free Tier](https://cloud.google.com/run/pricing)
- [Serverpod Deployment Guide](https://docs.serverpod.dev/deploying)
