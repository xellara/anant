# 🚀 Complete Deployment Guide - Cloud Run + Neon Database

Follow these steps to deploy your Anant server with **$0/month** cost!

---

## Part 1: Create Free Neon Database (5 minutes)

### Step 1: Sign Up for Neon

1. **Open your browser** and go to: https://neon.tech

2. **Click "Sign Up"** - You'll see these options:

![Neon Signup Options](file:///Users/amit/.gemini/antigravity/brain/a6f26dc7-a8d1-41c2-8ee6-f900fd9e4661/neon_signup_options_1768070744087.png)

3. **Choose your signup method:**
   - **Google** (easiest)
   - **GitHub**
   - **Microsoft**
   - **Hasura**
   - **Email & Password**

### Step 2: Create Your Project

After signing up, you'll see the "Create project" screen:

![Neon Create Project](file:///Users/amit/.gemini/antigravity/brain/a6f26dc7-a8d1-41c2-8ee6-f900fd9e4661/neon_create_project_modal_1768070694676.png)

Fill in these details:

1. **Project name**: `anant-server-db` (or any name you like)

2. **Postgres version**: `17` (latest, or use 16)

3. **Region**: Select based on where you'll deploy Cloud Run:
   - For Cloud Run `us-central1`: Choose **AWS US East 1** or **AWS US East 2**
   - For Cloud Run `asia-south1`: Choose **AWS Asia Pacific**

4. **What are you working on?**: Select "Building a new app"

5. Click **"Create"** button

### Step 3: Copy Your Database Credentials

After creating the project, Neon will show you a **Connection String**. It looks like:

```
postgres://neondb_owner:npg_XXXXXXXXXXXXXX@ep-XXXXXX-XXXXX.us-east-2.aws.neon.tech/neondb?sslmode=require
```

**IMPORTANT:** Save these details somewhere safe:

```
DB_HOST: ep-XXXXXX-XXXXX.us-east-2.aws.neon.tech
DB_NAME: neondb
DB_USER: neondb_owner
DB_PASSWORD: npg_XXXXXXXXXXXXXX
DB_PORT: 5432
```

You can also find these later in:
- Neon Console → Your Project → Connection Details

---

## Part 2: Install Google Cloud SDK (5 minutes)

### For macOS (recommended):

Open Terminal and run:

```bash
# Install Google Cloud SDK
brew install google-cloud-sdk
```

If you don't have Homebrew installed, first run:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Alternative: Manual Installation

If Homebrew doesn't work, download directly:

1. Go to: https://cloud.google.com/sdk/docs/install-sdk
2. Download the macOS installer
3. Run the installer
4. Follow the prompts

### Authenticate with Google Cloud

After installation, authenticate:

```bash
# Login to your Google account
gcloud auth login

# Set up application credentials
gcloud auth application-default login
```

A browser window will open - sign in with your Google account.

---

## Part 3: Create Google Cloud Project (2 minutes)

```bash
# Create a new project
gcloud projects create anant-prod --name="Anant School Management"

# Set it as active
gcloud config set project anant-prod

# Verify it's set
gcloud config get-value project
```

**Note:** For Cloud Run free tier, you **DON'T need to enable billing**!

---

## Part 4: Deploy to Cloud Run (5 minutes)

### Option A: Use the Automated Script (Easiest)

1. **Set your Neon database credentials** (from Part 1, Step 3):

```bash
export DB_HOST="ep-XXXXXX-XXXXX.us-east-2.aws.neon.tech"
export DB_NAME="neondb"
export DB_USER="neondb_owner"
export DB_PASSWORD="npg_XXXXXXXXXXXXXX"
export DB_PORT="5432"
```

2. **Navigate to server directory**:

```bash
cd /Users/amit/Me/Projects/anant/anant_server
```

3. **Run the deployment script**:

```bash
./deploy-cloudrun-free.sh anant-prod us-central1
```

This will:
- ✅ Enable required Google Cloud APIs
- ✅ Store database password securely
- ✅ Build and deploy your server
- ✅ Configure environment variables
- ✅ Give you the service URL

### Option B: Manual Deployment

If the script doesn't work, deploy manually:

```bash
cd /Users/amit/Me/Projects/anant/anant_server

# Enable APIs
gcloud services enable run.googleapis.com cloudbuild.googleapis.com secretmanager.googleapis.com

# Store database password as secret
echo -n "$DB_PASSWORD" | gcloud secrets create db-password --data-file=- --replication-policy="automatic"

# Deploy to Cloud Run
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
  --set-env-vars "DB_HOST=$DB_HOST,DB_PORT=$DB_PORT,DB_NAME=$DB_NAME,DB_USER=$DB_USER" \
  --set-secrets "DB_PASSWORD=db-password:latest"
```

The deployment will take **5-10 minutes**. You'll see:
```
Building using Buildpacks...
✓ Creating Container Repository...
✓ Uploading sources...
✓ Building and pushing container...
✓ Creating Revision...
✓ Routing traffic...
Done.
```

---

## Part 5: Run Database Migrations (3 minutes)

After deployment, initialize your database:

### Method 1: From Local Machine

1. **Temporarily update** `config/development.yaml`:

```yaml
database:
  host: ep-XXXXXX-XXXXX.us-east-2.aws.neon.tech  # Your Neon host
  port: 5432
  name: neondb
  user: neondb_owner
  password: npg_XXXXXXXXXXXXXX  # Your Neon password
  requireSsl: true
```

2. **Run migrations**:

```bash
cd /Users/amit/Me/Projects/anant/anant_server
dart bin/main.dart --apply-migrations
```

3. **Revert** `config/development.yaml` to localhost settings

### Method 2: Using Cloud Run Job (Advanced)

```bash
gcloud run jobs create migrate-db \
  --source . \
  --region us-central1 \
  --set-env-vars "DB_HOST=$DB_HOST,DB_PORT=$DB_PORT,DB_NAME=$DB_NAME,DB_USER=$DB_USER" \
  --set-secrets "DB_PASSWORD=db-password:latest" \
  --execute-now
```

---

## Part 6: Get Your Service URL

```bash
# Get the deployed URL
gcloud run services describe anant-server \
  --region us-central1 \
  --format="value(status.url)"
```

You'll get something like:
```
https://anant-server-xxxxx-uc.a.run.app
```

---

## Part 7: Update Your Flutter App (2 minutes)

Update your Flutter client configuration:

1. **Find your client initialization** (likely in `lib/main.dart` or similar)

2. **Update the URL**:

```dart
final client = Client(
  'https://anant-server-xxxxx-uc.a.run.app',  // Your Cloud Run URL
  authenticationKeyManager: FlutterAuthenticationKeyManager(),
);
```

3. **Rebuild your Flutter app**:

```bash
cd /Users/amit/Me/Projects/anant/anant_flutter
flutter clean
flutter pub get
flutter run
```

---

## Verification Checklist

✅ **Test API endpoint**:
```bash
curl https://anant-server-xxxxx-uc.a.run.app
```

✅ **Check logs**:
```bash
gcloud run services logs read anant-server --region us-central1 --limit 50
```

✅ **Test from Flutter app**:
- Try logging in
- Create/read data
- Verify all features work

---

## Troubleshooting

### Issue: "gcloud: command not found"
**Solution:** Google Cloud SDK not installed properly. Reinstall or add to PATH:
```bash
echo 'source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"' >> ~/.zshrc
source ~/.zshrc
```

### Issue: Database connection failed
**Solution:** Check that:
1. Neon database is active (check neon.tech console)
2. SSL is required: `requireSsl: true` in production.yaml
3. Credentials are correct

### Issue: Build failed
**Solution:** View build logs:
```bash
gcloud builds list
gcloud builds log BUILD_ID
```

### Issue: Service won't start
**Solution:** Check logs for errors:
```bash
gcloud run services logs read anant-server --region us-central1
```

---

## Cost Summary

- **Cloud Run**: $0 (within 2M requests/month free tier)
- **Neon Database**: $0 (0.5GB free tier)
- **Secret Manager**: $0 (6 free secrets)
- **Total**: **$0/month** 🎉

---

## Monitoring Your Deployment

```bash
# View service details
gcloud run services describe anant-server --region us-central1

# Monitor metrics
gcloud run services describe anant-server --region us-central1 --format='get(status.traffic)'

# View recent logs
gcloud run services logs tail anant-server --region us-central1
```

---

## Need Help?

- **Neon Issues**: https://neon.tech/docs
- **Cloud Run Issues**: https://cloud.google.com/run/docs
- **Serverpod**: https://docs.serverpod.dev/

**You're all set! 🚀**
