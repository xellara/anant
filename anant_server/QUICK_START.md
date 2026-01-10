# Quick Deployment Checklist

## ✅ Completed
- [x] Fixed Dockerfile
- [x] Created deployment scripts
- [x] Started Neon database setup
- [x] Installing Google Cloud SDK

## 🔄 In Progress

### 1. Finish Neon Setup
In your browser:
1. Click **"Create project"** button
2. Wait for database to be created (~30 seconds)
3. Copy the connection string shown

The connection string looks like:
```
postgres://user:password@host/database?sslmode=require
```

**Save these values:**
```bash
DB_HOST=ep-XXXXXX.us-east-2.aws.neon.tech
DB_NAME=neondb
DB_USER=neondb_owner  
DB_PASSWORD=npg_XXXXXXXXXXXXXX
DB_PORT=5432
```

### 2. After SDK Installation Completes

Authenticate with Google Cloud:
```bash
gcloud auth login
gcloud auth application-default login
```

### 3. Create Google Cloud Project
```bash
gcloud projects create anant-prod --name="Anant School Management"
gcloud config set project anant-prod
```

### 4. Deploy to Cloud Run
```bash
cd /Users/amit/Me/Projects/anant/anant_server

# Set your Neon credentials (from step 1)
export DB_HOST="ep-XXXXXX.us-east-2.aws.neon.tech"
export DB_NAME="neondb"
export DB_USER="neondb_owner"
export DB_PASSWORD="npg_XXXXXXXXXXXXXX"

# Deploy!
./deploy-cloudrun-free.sh anant-prod us-central1
```

## 📋 Next: Once you click "Create project" in Neon

Let me know when you have the database credentials and I'll help you deploy!
